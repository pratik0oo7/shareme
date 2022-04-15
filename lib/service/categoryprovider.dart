import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:isolate_handler/isolate_handler.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shareme/box/file_utils.dart';

class categoryprovider extends ChangeNotifier {
  categoryprovider() {
    gethidden();
    getsort();
  }
  void setloading(value) {
    loading = value as bool;
    notifyListeners();
  }

  sethidden(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hidden', value as bool);
    showhidden = value;
    notifyListeners();
  }

  gethidden() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool h = prefs.getBool('hidden') ?? false;
    sethidden(h);
  }

  Future setsort(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('sort', value as int);
    sort = value;
    notifyListeners();
  }

  getsort() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int h = prefs.getInt('sort') ?? 0;
    setsort(h);
  }

  bool loading = false;
  List<FileSystemEntity> downloads = <FileSystemEntity>[];
  List<String> downloadtabs = <String>[];

  List<FileSystemEntity> images = <FileSystemEntity>[];
  List<String> imagetabs = <String>[];

  List<FileSystemEntity> audio = <FileSystemEntity>[];
  List<String> audiotabs = <String>[];
  List<FileSystemEntity> currentfiles = [];

  bool showhidden = false;
  int sort = 0;
  final isolates = IsolateHandler();

  getdownloads() async {
    setloading(true);
    downloadtabs.clear();
    downloads.clear();
    downloadtabs.add('All');
    List<Directory> storages = await FileUtils.getStorageList();
    storages.forEach((dir) {
      if (Directory(dir.path + 'Download').existsSync()) {
        List<FileSystemEntity> files =
            Directory(dir.path + 'Download').listSync();
        print(files);
        files.forEach((file) {
          if (FileSystemEntity.isFileSync(file.path)) {
            downloads.add(file);
            downloadtabs
                .add(file.path.split('/')[file.path.split('/').length - 2]);
            downloadtabs = downloadtabs.toSet().toList();
            notifyListeners();
          }
        });
      }
    });
    setloading(false);
  }

  getimages(String type) async {
    setloading(true);
    imagetabs.clear();
    images.clear();
    imagetabs.add('All');
    String isolateName = type;
    isolates.spawn<String>(
      getallfilesisolated,
      name: isolateName,
      onReceive: (val) {
        print(val);
        isolates.kill(isolateName);
      },
      onInitialized: () => isolates.send('hey', to: isolateName),
    );
    ReceivePort _port = ReceivePort();
    IsolateNameServer.registerPortWithName(_port.sendPort, '${isolateName}_2');
    _port.listen((files) {
      print('RECEIVED SERVER PORT');
      print(files);
      files.forEach((file) {
        String mimeType = mime(file.path as String) ?? '';
        if (mimeType.split('/')[0] == type) {
          images.add(file as FileSystemEntity);
          imagetabs
              .add('${file.path.split('/')[file.path.split('/').length - 2]}');
          imagetabs = imagetabs.toSet().toList();
        }
        notifyListeners();
      });
      currentfiles = images;
      setloading(false);
      _port.close();
      IsolateNameServer.removePortNameMapping('${isolateName}_2');
    });
  }

  static getallfilesisolated(Map<String, dynamic> context) async {
    print(context);
    String isolateName = context['name'] as String;
    print('Get files');
    List<FileSystemEntity> files =
        await FileUtils.getAllFiles(showHidden: false);
    print('Files $files');
    final messenger = HandledIsolate.initialize(context);
    try {
      final SendPort? send =
          IsolateNameServer.lookupPortByName('${isolateName}_2');
      send!.send(files);
    } catch (e) {
      print(e);
    }
    messenger.send('done');
  }

  getAudios(String type) async {
    setloading(true);
    audiotabs.clear();
    audio.clear();
    audiotabs.add('All');
    String isolateName = type;
    isolates.spawn<String>(
      getallfilesisolated,
      name: isolateName,
      onReceive: (val) {
        print(val);
        isolates.kill(isolateName);
      },
      onInitialized: () => isolates.send('hey', to: isolateName),
    );
    ReceivePort _port = ReceivePort();
    IsolateNameServer.registerPortWithName(_port.sendPort, '${isolateName}_2');
    _port.listen((files) async {
      print('RECEIVED SERVER PORT');
      print(files);
      List tabs = await compute(separateAudios, {'files': files, 'type': type});
      audio = tabs[0] as List<FileSystemEntity>;
      audiotabs = tabs[1] as List<String>;
      setloading(false);
      _port.close();
      IsolateNameServer.removePortNameMapping('${isolateName}_2');
    });
  }

  switchCurrentFiles(List list, String label) async {
    List<FileSystemEntity> l = await compute(getTabImages, [list, label]);
    currentfiles = l;
    notifyListeners();
  }

  static Future<List<FileSystemEntity>> getTabImages(List item) async {
    List items = item[0] as List<dynamic>;
    String label = item[1] as String;
    List<FileSystemEntity> files = [];
    items.forEach((file) {
      if ('${file.path.split('/')[file.path.split('/').length - 2]}' == label) {
        files.add(file as FileSystemEntity);
      }
    });
    return files;
  }

  static Future<List> separateAudios(Map body) async {
    List files = body['files'] as List<dynamic>;
    String type = body['type'] as String;
    List<FileSystemEntity> audio = [];
    List<String> audioTabs = [];
    for (File file in files as dynamic) {
      String mimeType = mime(file.path) ?? '';
      print(extension(file.path));
      if (type == 'text' && docExtensions.contains(extension(file.path))) {
        audio.add(file);
      }
      if (mimeType.isNotEmpty) {
        if (mimeType.split('/')[0] == type) {
          audio.add(file);
          audioTabs
              .add('${file.path.split('/')[file.path.split('/').length - 2]}');
          audioTabs = audioTabs.toSet().toList();
        }
      }
    }
    return [audio, audioTabs];
  }

  static List docExtensions = [
    '.pdf',
    '.epub',
    '.mobi',
    '.doc',
  ];
}
