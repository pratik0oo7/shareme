import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:isolate_handler/isolate_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shareme/box/file_utils.dart';

class CoreProvider extends ChangeNotifier {
  List<FileSystemEntity> availableStorage = <FileSystemEntity>[];
  List<FileSystemEntity> recentFiles = <FileSystemEntity>[];
  final isolate = IsolateHandler();
  int totalSpace = 0;
  int freeSpace = 0;
  int totalSDSpace = 0;
  int freeSDSpace = 0;
  int usedSpace = 0;
  int usedSDSpace = 0;
  bool storageLoading = true;
  bool recentLoading = true;

  checkSpace() async {
    setRecentLoading(true);
    setStorageLoading(true);
    recentFiles.clear();
    availableStorage.clear();
    List<Directory> dirList = (await getExternalStorageDirectories())!;
    availableStorage.addAll(dirList);
    notifyListeners();
    MethodChannel platform = MethodChannel('shareme_storage');
    var free = await platform.invokeMethod('getStorageFreeSpace');
    var total = await platform.invokeMethod('getStorageTotalSpace');
    setFreeSpace(free);
    setTotalSpace(total);
    setUsedSpace(total - free);
    if (dirList.length > 1) {
      var freeSD = await platform.invokeMethod('getExternalStorageFreeSpace');
      var totalSD = await platform.invokeMethod('getExternalStorageTotalSpace');
      setFreeSDSpace(freeSD);
      setTotalSDSpace(totalSD);
      setUsedSDSpace(totalSD - freeSD);
    }
    setStorageLoading(false);
    getrecentfile();
  }

  /// I had to use a combination of [isolate_handler] plugin and
  /// [IsolateNameServer] because compute doesnt work as my function uses
  /// an external plugin and also [isolate_handler] plugin doesnt allow me
  /// to pass complex data (in this case List<FileSystemEntity>). so basically
  /// i used the [isolate_handler] to do get the file and use [IsolateNameServer]
  /// to send it back to the main Thread
  getrecentfile() async {
    String isolateName = 'recent';
    isolate.spawn<String>(
      getisolatefile,
      name: isolateName,
      onReceive: (val) {
        print(val);
        isolate.kill(isolateName);
      },
      onInitialized: () => isolate.send('hey', to: isolateName),
    );
    ReceivePort _port = ReceivePort();
    IsolateNameServer.registerPortWithName(_port.sendPort, '${isolateName}_2');
    _port.listen((message) {
      print('RECEIVED SERVER PORT');
      print(message);
      recentFiles.addAll(message as Iterable<FileSystemEntity>);
      setRecentLoading(false);
      _port.close();
      IsolateNameServer.removePortNameMapping('${isolateName}_2');
    });
  }

  static getisolatefile(Map<String, dynamic> context) async {
    print(context);
    final String isolateName = context.toString();
    List<FileSystemEntity> l =
        await FileUtils.getRecentFiles(showHidden: false);
    final messenger = HandledIsolate.initialize(context);
    final SendPort? send =
        IsolateNameServer.lookupPortByName('${isolateName}_2');
    send!.send(l);
    messenger.send('done');
  }

  void setFreeSpace(value) {
    freeSpace = value as int;
    notifyListeners();
  }

  void setTotalSpace(value) {
    totalSpace = value as int;
    notifyListeners();
  }

  void setUsedSpace(value) {
    usedSpace = value as int;
    notifyListeners();
  }

  void setFreeSDSpace(value) {
    freeSDSpace = value as int;
    notifyListeners();
  }

  void setTotalSDSpace(value) {
    totalSDSpace = value as int;
    notifyListeners();
  }

  void setUsedSDSpace(value) {
    usedSDSpace = value as int;
    notifyListeners();
  }

  void setStorageLoading(value) {
    storageLoading = value as bool;
    notifyListeners();
  }

  void setRecentLoading(value) {
    recentLoading = value as bool;
    notifyListeners();
  }
}
