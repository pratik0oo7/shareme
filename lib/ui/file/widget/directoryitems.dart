// ignore_for_file: use_named_constants

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

// ignore: camel_case_types
class directoryitem extends StatelessWidget {
  final FileSystemEntity file;
  final Function tap;
  final Function? popTap;

  const directoryitem({
    Key? key,
    required this.file,
    required this.tap,
    this.popTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => tap(),
      contentPadding: const EdgeInsets.all(0),
      leading: Container(
        height: 40,
        width: 40,
        child: const Center(
          child: Icon(
            Icons.folder,
          ),
        ),
      ),
      title: Text(
        '${basename(file.path)}',
        style: const TextStyle(
          fontSize: 14,
        ),
        maxLines: 2,
      ),
      trailing: popTap == null
          ? null
          : directorypopup(path: file.path, popTap: popTap),
    );
  }
}

class directorypopup extends StatelessWidget {
  final String path;
  final Function? popTap;

  const directorypopup({
    Key? key,
    required this.path,
    this.popTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: (val) => popTap!(val),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 0,
          child: Text(
            'Rename',
          ),
        ),
        const PopupMenuItem(
          value: 1,
          child: Text(
            'Delete',
          ),
        ),
      ],
      icon: Icon(
        Icons.arrow_drop_down,
        color: Theme.of(context).textTheme.headline6!.color,
      ),
      color: Theme.of(context).scaffoldBackgroundColor,
      offset: const Offset(0, 30),
    );
  }
}
