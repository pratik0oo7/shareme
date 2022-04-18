import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shareme/configfile.dart';
import 'package:shareme/service/sharingobject_service.dart';

class SharingService extends ChangeNotifier {
  final shareObject _file;
  int? _port;
  HttpServer? _server;
  final BuildContext _context;

  int? get port => _port;

  bool get running => _port != null;

  SharingService(this._file, this._context);

  Future<bool> _isPortFree(int port) async {
    try {
      final _ = await HttpServer.bind(InternetAddress.anyIPv4, port);
      await _.close(force: true);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<int> _getPrettyPort() async {
    for (final el in ports) {
      if (await _isPortFree(el)) {
        return el;
      }
    }

    final _ = await HttpServer.bind(InternetAddress.anyIPv4, 0);
    final port = _.port;
    await _.close(force: true);
    return port;
  }

  Future<void> start() async {
    _port = await _getPrettyPort();

    _server = await HttpServer.bind(InternetAddress.anyIPv4, _port!);

    _serve();

    notifyListeners();
  }

  Future<void> end() async {
    await _server!.close(force: true);

    if (Platform.isAndroid || Platform.isIOS) {
      FilePicker.platform.clearTemporaryFiles();
    }
  }

  Future<void> _serve() async {
    if (_server == null) {
      throw Exception('Server was not initialized');
    }

    await for (final request in _server!) {
      // If we are requesting favicon.ico
      if (request.requestedUri.toString().split('/').length == 4 &&
          request.requestedUri.toString().split('/').last == 'favicon.ico') {
        request.response.headers.contentType =
            ContentType('image', 'x-icon', charset: 'utf-8');

        final favicon = await rootBundle.load('assets/favicon.ico');

        request.response.add(favicon.buffer.asUint8List());
        request.response.close();
        continue;
      }

      // If we are requesting sharik.json
      if (request.requestedUri.toString().split('/').length == 4 &&
          request.requestedUri.toString().split('/').last == 'sharik.json') {
        request.response.headers.contentType =
            ContentType('application', 'json', charset: 'utf-8');
        request.response.write(jsonEncode({
          'sync & share': currentVersion,
          'type': _file.type.toString().split('.').last,
          'name': _file.name,
          'os': Platform.operatingSystem,
        }));
        request.response.close();
        continue;
      }

      // If we are sharing text
      if (_file.type == SharingObjectType.text) {
        request.response.headers.contentType =
            ContentType('text', 'plain', charset: 'utf-8');
        request.response.write(_file.data);
        request.response.close();
        continue;
      }

      // If we are sharing only one file that is not a folder
      if (!_file.data.contains(multipleFilesDelimiter) &&
          FileSystemEntity.typeSync(_file.data) !=
              FileSystemEntityType.directory) {
        final f = File(_file.data);
        final size = await f.length();

        _pipeFile(
            request,
            f,
            size,
            _file.type == SharingObjectType.file
                ? _file.name
                : '${_file.name}.apk');
        continue;
      }

      // All other cases

      final fileList = _file.data.split(multipleFilesDelimiter);

      final requestedFilePath = request.requestedUri.queryParameters['q'] ?? '';
      File? file;
      int? size;
      var isDir = false;

      // if the file is requested
      if (requestedFilePath.isNotEmpty) {
        isDir = await FileSystemEntity.type(requestedFilePath) ==
            FileSystemEntityType.directory;
        // todo is that secure enough?
        if (!fileList.contains(requestedFilePath)) {
          // checking if the path belongs to a shared folder
          var isInsideAFolder = false;
          for (final el in fileList) {
            if (requestedFilePath.contains(el)) {
              isInsideAFolder = true;
            }
          }

          if (!isInsideAFolder) {
            print('NO ACCESS!!!');
            continue;
          }
        }

        if (!isDir) {
          file = File(requestedFilePath);
          size = await file.length();
        }
      }

      // We are sharing multiple files
      // Serving an entry html page or the folder page
      if (requestedFilePath.isEmpty || isDir) {
        final _fileList = isDir
            ? Directory(requestedFilePath)
                .listSync()
                .map((e) => e.path)
                .toList()
            : fileList;

        final displayFiles = Map.fromEntries(_fileList.map((e) => MapEntry(e,
            FileSystemEntity.typeSync(e) != FileSystemEntityType.directory)));

        request.response.headers.contentType =
            ContentType('text', 'html', charset: 'utf-8');
        request.response.write(_buildHTML(displayFiles,
            'Download all (Will skip folders, Requires JavaScript enabled)'));
        request.response.close();
        // Serving the files
      } else {
        _pipeFile(request, file, size,
            requestedFilePath.split(Platform.pathSeparator).last);
      }
    }
  }
}

Future<void> _pipeFile(
    HttpRequest request, File? file, int? size, String fileName) async {
  request.response.headers.contentType =
      ContentType('application', 'octet-stream', charset: 'utf-8');

  request.response.headers.add(
    'Content-Transfer-Encoding',
    'Binary',
  );

  request.response.headers.add(
    'Content-disposition',
    'attachment; filename="${Uri.encodeComponent(fileName)}"',
  );

  if (size != null) {
    request.response.headers.add(
      'Content-length',
      size,
    );
  }

  await file!.openRead().pipe(request.response).catchError((e) {}).then((a) {
    request.response.close();
  });
}

/// bool - true if the path is a file; false if it's a folder
String _buildHTML(Map<String, bool> files, String downloadButtonText) {
  final html = '''
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Sharik</title>
  </head>
  <body>
    <button onClick="downloadAll()">$downloadButtonText</button>
    <ul style="line-height:200%">
      ${files.entries.map((val) => '<li><a href="/?q=${Uri.decodeComponent(val.key)}" class="${val.value ? 'file' : 'folder'}"><b>${val.key.split(Platform.pathSeparator).last}</b> <small>(${val.key})</small></li></a>').join('\n')}
    </ul>
    
    <script>
    // Adapted from https://web.archive.org/web/20210805125534/https://developpaper.com/question/how-to-download-multiple-url-files-with-js/ 
    
    let triggerDelay = 100;
    let removeDelay = 1000; 
    
    function downloadAll(){
      var arr = [].slice.call(document.getElementsByClassName('file'));
      arr.forEach(function(item,index){
        _createIFrame(item.href, index * triggerDelay, removeDelay);
      });
    }
    
    function _createIFrame(url, triggerDelay, removeDelay) {
      setTimeout(function() {
        var node = document.createElement("iframe");
        node.setAttribute("style", "display: none;");
        node.setAttribute("src", url);
        document.body.appendChild(node);
    
        setTimeout(function() {
            node.remove();
        }, removeDelay);
        
      }, triggerDelay);
    } 
    </script>
  </body>
</html>
  ''';

  return html;
}
