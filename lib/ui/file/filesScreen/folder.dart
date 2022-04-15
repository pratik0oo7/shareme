import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as pathlib;
import 'package:provider/provider.dart';
import 'package:shareme/box/dialog.dart';
import 'package:shareme/box/file_utils.dart';
import 'package:shareme/configfile.dart';
import 'package:shareme/service/categoryprovider.dart';
import 'package:shareme/ui/file/filesScreen/add_file_dialog.dart';
import 'package:shareme/ui/file/filesScreen/rename_file_dialog.dart';
import 'package:shareme/ui/file/widget/directoryitems.dart';
import 'package:shareme/ui/file/widget/fileitems.dart';
import 'package:shareme/ui/file/widget/pathbar.dart';
import 'package:shareme/ui/file/widget/sort.dart';

class folder extends StatefulWidget {
  final String title;
  final String path;

  folder({
    Key? key,
    required this.title,
    required this.path,
  }) : super(key: key);

  @override
  _folderState createState() => _folderState();
}

class _folderState extends State<folder> with WidgetsBindingObserver {
  late String path;
  List<String> paths = <String>[];

  List<FileSystemEntity> files = <FileSystemEntity>[];
  bool showhidden = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getfiles();
    }
  }

  getfiles() async {
    try {
      var provider = Provider.of<categoryprovider>(context, listen: false);
      Directory directory = Directory(path);
      List<FileSystemEntity> directoryfiles = directory.listSync();
      files.clear();
      showhidden = provider.showhidden;
      setState(() {});
      for (FileSystemEntity file in directoryfiles) {
        if (!showhidden) {
          if (!pathlib.basename(file.path).startsWith('.')) {
            files.add(file);
            setState(() {});
          }
        } else {
          files.add(file);
          setState(() {});
        }
      }

      files = FileUtils.sortList(files, provider.sort);
    } catch (e) {
      if (e.toString().contains('Permission denied')) {
        Dialogs.showToast('Permission Denied! cannot access this Directory!');
        navigateback();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    path = widget.path;
    getfiles();
    paths.add(widget.path);
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  navigateback() {
    paths.removeLast();
    path = paths.last;
    setState(() {});
    getfiles();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (paths.length == 1) {
          return true;
        } else {
          paths.removeLast();
          setState(() {
            path = paths.last;
          });
          getfiles();
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (paths.length == 1) {
                Navigator.pop(context);
              } else {
                navigateback();
              }
            },
          ),
          elevation: 4,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${widget.title}'),
              Text(
                '$path',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          bottom: pathbar(
            paths: paths,
            icon: widget.path.toString().contains('emulated')
                ? Icons.smartphone
                : Icons.sd_card,
            onChanged: (index) {
              print(paths[index]);
              path = paths[index];
              paths.removeRange(index + 1, paths.length);
              setState(() {});
              getfiles();
            },
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                await showModalBottomSheet(
                  context: context,
                  builder: (context) => sortsheet(),
                );
                getfiles();
              },
              tooltip: 'Sort by',
              icon: Icon(Icons.sort),
            ),
          ],
        ),
        body: Visibility(
          replacement: Center(child: Text('There\'s nothing here')),
          visible: files.isNotEmpty,
          child: ListView.separated(
            padding: EdgeInsets.only(left: 20),
            itemCount: files.length,
            itemBuilder: (BuildContext context, int index) {
              FileSystemEntity file = files[index];
              if (file.toString().split(':')[0] == 'Directory') {
                return directoryitem(
                  popTap: (v) async {
                    if (v == 0) {
                      rename(context, file.path, 'dir');
                    } else if (v == 1) {
                      delete(true, file);
                    }
                  },
                  file: file,
                  tap: () {
                    paths.add(file.path);
                    path = file.path;
                    setState(() {});
                    getfiles();
                  },
                );
              }
              return fileitem(
                file: file,
                popTap: (v) async {
                  if (v == 0) {
                    rename(context, file.path, 'file');
                  } else if (v == 1) {
                    delete(false, file);
                  } else if (v == 2) {
                    /// TODO: Implement Share file feature
                    print('Share');
                  }
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return CustomDivider();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => add(context, path),
          child: Icon(Icons.add),
          tooltip: 'Add Folder',
        ),
      ),
    );
  }

  delete(bool directory, var file) async {
    try {
      if (directory) {
        // ignore: avoid_dynamic_calls
        await Directory(file.path as String).delete(recursive: true);
      } else {
        await File(file.path as String).delete(recursive: true);
      }
      Dialogs.showToast('Delete Successful');
    } catch (e) {
      print(e.toString());
      if (e.toString().contains('Permission denied')) {
        Dialogs.showToast('Cannot write to this Storage device!');
      }
    }
    getfiles();
  }

  add(BuildContext context, String path) async {
    await showDialog(
      context: context,
      builder: (context) => addfile(path: path),
    );
    getfiles();
  }

  rename(BuildContext context, String path, String type) async {
    await showDialog(
      context: context,
      builder: (context) => renamefile(path: path, type: type),
    );
    getfiles();
  }
}
