// ignore_for_file: camel_case_types, avoid_redundant_argument_values

import 'dart:io';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String multipleFilesDelimiter = '|sharik|';

@HiveType(typeId: 1)
class shareObject {
  @HiveField(0)
  final SharingObjectType type;
  // path to file if type is file
  // path to apk if type is app
  // raw text if type is text
  @HiveField(1)
  final String data;
  @HiveField(2)
  final String name;

  IconData get icon {
    switch (type) {
      case SharingObjectType.file:
        return data.contains(multipleFilesDelimiter)
            ? BootstrapIcons.file_fill
            : _fileIcon;
      case SharingObjectType.text:
        return BootstrapIcons.file_text_fill;
      case SharingObjectType.app:
        return BootstrapIcons.file_binary_fill;
      case SharingObjectType.unknown:
        return BootstrapIcons.file_fill;
    }
  }

  // review for ios (file namming)
  // publish as pakage
  // that a mess

  IconData get _fileIcon {
    const fileMap = {
      ['exe', 'so']: BootstrapIcons.file_binary,
      [
        'js',
        'ts',
        'html',
        'htm',
        'css',
        'sql',
        'python',
        'java',
        'sh',
        'cs',
        'php',
        'cpp',
        'c',
        'go',
        'kt',
        'rb',
        'asm',
        'rust',
        'r',
        'dart',
        'xml',
        'yaml',
        'toml'
      ]: BootstrapIcons.file_code,
      ['diff']: BootstrapIcons.file_diff,
      [
        'xlsx',
        'xlsm',
        'xlsb',
        'xltx',
        'xltm',
        'xls',
        'xlt',
        'xla',
        'xlw',
        'xlam'
      ]: BootstrapIcons.file_excel_fill,
      ['pptx', 'pptm', 'ppt', 'potx', 'potm', 'pot']: BootstrapIcons.file_ppt,
      ['csv']: BootstrapIcons.file_spreadsheet,
      ['doc', 'docm', 'docx', 'rtf']: BootstrapIcons.file_word,
      ['zip', 'rar', '7z', 'tar', 'xf']: BootstrapIcons.file_zip,
      ['jfproj', 'woff', 'ttf', 'otf']: BootstrapIcons.file_font,
      ['png', 'jpg', 'gif', 'svg', 'ai', 'psd']: BootstrapIcons.file_image,
      ['mp3', 'odd']: BootstrapIcons.file_music,
      ['pdf']: BootstrapIcons.file_pdf,
      ['mp4', 'avi', 'webm', 'sub', 'srt', 'mpv']: BootstrapIcons.file_play,
      ['md', 'rmd', 'ltx', 'tex']: BootstrapIcons.file_richtext,
      ['xps', 'odp']: BootstrapIcons.file_slides,
    };
    final fileextention = name.toLowerCase().split('.').last;
    for (final icon in fileMap.entries) {
      for (final extension in icon.key) {
        if (fileextention == extension) {
          return icon.value;
        }
      }
    }
    return BootstrapIcons.file_fill;
  }

  shareObject({
    required this.type,
    required this.data,
    required this.name,
  });

  static String getshareName(SharingObjectType type, String data) {
    switch (type) {
      case SharingObjectType.file:
        return '${data.contains(multipleFilesDelimiter) ? '${data.split(multipleFilesDelimiter).length}:' : ''}${data.split(multipleFilesDelimiter).map((e) => e.split(Platform.isWindows ? '\\' : '/').last).join(" ")}';
      case SharingObjectType.text:
        final _ = data.trim().replaceAll('\n', ' ');
        return _.length >= 101 ? _.substring(0, 100) : _;
      case SharingObjectType.app:
        throw Exception('when type is app,name necessary');
      case SharingObjectType.unknown:
        throw Exception('Unknown type ie for only backwards compatability');
    }
  }
}

@HiveType(typeId: 2)
enum SharingObjectType {
  @HiveField(0)
  file,
  @HiveField(1)
  text,
  @HiveField(2)
  app,
// If, in the future, we introduce more types, the unknown type will be used as a fallback, and won't break the receiver function
  @HiveField(3)
  unknown
}

SharingObjectType string2fileType(String type) {
  switch (type) {
    case 'file':
      return SharingObjectType.file;

    case 'text':
      return SharingObjectType.text;

    case 'app':
      return SharingObjectType.app;
  }
  return SharingObjectType.unknown;
}

class SharingObjectTypeAdapter extends TypeAdapter<SharingObjectType> {
  @override
  final int typeId = 2;

  @override
  SharingObjectType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SharingObjectType.file;
      case 1:
        return SharingObjectType.text;
      case 2:
        return SharingObjectType.app;
      case 3:
        return SharingObjectType.unknown;
      default:
        return SharingObjectType.file;
    }
  }

  @override
  void write(BinaryWriter writer, SharingObjectType obj) {
    switch (obj) {
      case SharingObjectType.file:
        writer.writeByte(0);
        break;
      case SharingObjectType.text:
        writer.writeByte(1);
        break;
      case SharingObjectType.app:
        writer.writeByte(2);
        break;

      case SharingObjectType.unknown:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SharingObjectTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SharingObjectAdapter extends TypeAdapter<shareObject> {
  @override
  final int typeId = 1;

  @override
  shareObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return shareObject(
      type: fields[0] as SharingObjectType,
      data: fields[1] as String,
      name: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, shareObject obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.data)
      ..writeByte(2)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SharingObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
