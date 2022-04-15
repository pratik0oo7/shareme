// ignore_for_file: prefer_final_locals, parameter_assignments, avoid_dynamic_calls, prefer_interpolation_to_compose_strings, unused_local_variable

import 'dart:io';
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

// ignore: avoid_classes_with_only_static_members
class FileUtils {
  String waPath = '/storage/emulated/0/WhatsApp/Media/.Statuses';

  /// Convert Byte to KB, MB, .......
  // ignore: type_annotate_public_apis
  // static String? formatBytes(bytes, decimals) {
  //   decimals = 2;
  //   if (bytes == 0) return '0.0 KB';
  //   var k = 1024;
  //   if (decimals <= 0) {
  //     decimals = 0;
  //   } else {
  //     decimals = decimals;
  //   }
  //   const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
  //   var i = log(bytes) / log(k);
  //   return ((bytes / pow(k, i)).toFixed(decimals)) + ' ' + sizes[i];
  // }
  static String formatBytes(num bytes, int decimals) {
    if (bytes == 0) {
      '0.0 Bytes';
    }
    const k = 1024;
    var dm = decimals < 0 ? 0 : decimals;
    const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    var i = (log(bytes) / log(k)).floor();
    return (bytes / pow(k, i)).toStringAsFixed(dm) + ' ' + sizes[i];
  }

  /// Get mime information of a file
  static String getMime(String path) {
    final File file = File(path);
    final String mimeType = mime(file.path) ?? '';
    return mimeType;
  }

  /// Return all available Storage path
  static Future<List<Directory>> getStorageList() async {
    final List<Directory> paths = (await getExternalStorageDirectories())!;
    final List<Directory> filteredPaths = <Directory>[];
    for (final Directory dir in paths) {
      filteredPaths.add(removeDataDirectory(dir.path));
    }
    return filteredPaths;
  }

  static Directory removeDataDirectory(String path) {
    return Directory(path.split('Android')[0]);
  }

  /// Get all Files and Directories in a Directory
  static Future<List<FileSystemEntity>> getFilesInPath(String path) async {
    final Directory dir = Directory(path);
    return dir.listSync();
  }

  /// Get all Files on the Device
  static Future<List<FileSystemEntity>> getAllFiles(
      {bool showHidden = false}) async {
    final List<Directory> storages = await getStorageList();
    final List<FileSystemEntity> files = <FileSystemEntity>[];
    for (final Directory dir in storages) {
      List<FileSystemEntity> allFilesInPath = [];
      // This is important to catch storage errors
      try {
        allFilesInPath =
            await getAllFilesInPath(dir.path, showHidden: showHidden);
      } catch (e) {
        allFilesInPath = [];
        print(e);
      }
      files.addAll(allFilesInPath);
    }
    return files;
  }

  static Future<List<FileSystemEntity>> getRecentFiles(
      {bool showHidden = false}) async {
    final List<FileSystemEntity> files =
        await getAllFiles(showHidden: showHidden);
    files.sort(
      (a, b) => File(a.path)
          .lastAccessedSync()
          .compareTo(File(b.path).lastAccessedSync()),
    );
    return files.reversed.toList();
  }

  static Future<List<FileSystemEntity>> searchFiles(String query,
      {bool showHidden = false}) async {
    final List<Directory> storage = await getStorageList();
    final List<FileSystemEntity> files = <FileSystemEntity>[];
    for (final Directory dir in storage) {
      final List fs = await getAllFilesInPath(dir.path, showHidden: showHidden);
      for (final FileSystemEntity fs in files) {
        if (basename(fs.path).toLowerCase().contains(query.toLowerCase())) {
          files.add(fs);
        }
      }
    }
    return files;
  }

  /// Get all files
  static Future<List<FileSystemEntity>> getAllFilesInPath(String path,
      {bool showHidden = false}) async {
    final List<FileSystemEntity> files = <FileSystemEntity>[];
    final Directory d = Directory(path);
    final List<FileSystemEntity> l = d.listSync();
    for (final FileSystemEntity file in l) {
      if (FileSystemEntity.isFileSync(file.path)) {
        if (!showHidden) {
          if (!basename(file.path).startsWith('.')) {
            files.add(file);
          }
        } else {
          files.add(file);
        }
      } else {
        if (!file.path.contains('/storage/emulated/0/Android')) {
//          print(file.path);
          if (!showHidden) {
            if (!basename(file.path).startsWith('.')) {
              files.addAll(
                await getAllFilesInPath(file.path, showHidden: showHidden),
              );
            }
          } else {
            files.addAll(
              await getAllFilesInPath(file.path, showHidden: showHidden),
            );
          }
        }
      }
    }
//    print(files);
    return files;
  }

  static String formatTime(String iso) {
    final DateTime date = DateTime.parse(iso);
    final DateTime now = DateTime.now();
    final DateTime yDay = DateTime.now().subtract(Duration(days: 1));
    final DateTime dateFormat = DateTime.parse(
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T00:00:00.000Z',
    );
    final DateTime today = DateTime.parse(
      '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}T00:00:00.000Z',
    );
    final DateTime yesterday = DateTime.parse(
      '${yDay.year}-${yDay.month.toString().padLeft(2, '0')}-${yDay.day.toString().padLeft(2, '0')}T00:00:00.000Z',
    );

    if (dateFormat == today) {
      return 'Today ${DateFormat('HH:mm').format(DateTime.parse(iso))}';
    } else if (dateFormat == yesterday) {
      return 'Yesterday ${DateFormat('HH:mm').format(DateTime.parse(iso))}';
    } else {
      return '${DateFormat('MMM dd, HH:mm').format(DateTime.parse(iso))}';
    }
  }

  static List<FileSystemEntity> sortList(
      List<FileSystemEntity> list, int sort) {
    switch (sort) {

      /// Sort by name
      case 0:
        list.sort(
          (f1, f2) => basename(f1.path)
              .toLowerCase()
              .compareTo(basename(f2.path).toLowerCase()),
        );
        break;

      case 1:
        list.sort(
          (f1, f2) => basename(f2.path)
              .toLowerCase()
              .compareTo(basename(f1.path).toLowerCase()),
        );
        break;

      /// Sort by date
      case 2:
        list.sort(
          (FileSystemEntity f1, FileSystemEntity f2) =>
              f1.statSync().modified.compareTo(f2.statSync().modified),
        );
        break;

      case 3:
        list.sort(
          (FileSystemEntity f1, FileSystemEntity f2) =>
              f2.statSync().modified.compareTo(f1.statSync().modified),
        );
        break;

      /// sort by size
      case 4:
        list.sort(
          (FileSystemEntity f1, FileSystemEntity f2) =>
              f2.statSync().size.compareTo(f1.statSync().size),
        );
        break;

      case 5:
        list.sort(
          (FileSystemEntity f1, FileSystemEntity f2) =>
              f1.statSync().size.compareTo(f2.statSync().size),
        );
        break;

      default:
        list.sort();
    }

    return list;
  }
}
