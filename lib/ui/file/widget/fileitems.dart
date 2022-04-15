import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:shareme/box/file_utils.dart';
import 'package:video_player/video_player.dart';

class fileitem extends StatelessWidget {
  final FileSystemEntity file;
  final Function? popTap;

  fileitem({
    Key? key,
    required this.file,
    this.popTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => OpenFile.open(file.path),
      contentPadding: const EdgeInsets.all(0),
      leading: fileicon(file: file),
      title: Text(
        '${basename(file.path)}',
        style: const TextStyle(fontSize: 14),
        maxLines: 2,
      ),
      subtitle: Text(
        '${FileUtils.formatBytes(File(file.path).lengthSync(), 2)},'
        ' ${FileUtils.formatTime(File(file.path).lastModifiedSync().toIso8601String())}',
      ),
      trailing:
          popTap == null ? null : filepopup(path: file.path, popTap: popTap!),
    );
  }
}

class fileicon extends StatelessWidget {
  final FileSystemEntity file;

  fileicon({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    File f = File(file.path);
    String _extension = extension(f.path).toLowerCase();
    String mimeType = mime(basename(file.path).toLowerCase()) ?? '';
    String type = mimeType.isEmpty ? '' : mimeType.split('/')[0];
    if (_extension == '.apk') {
      return const Icon(Icons.android, color: Colors.green);
    } else if (_extension == '.crdownload') {
      return const Icon(Icons.download, color: Colors.lightBlue);
    } else if (_extension == '.zip' || _extension.contains('tar')) {
      return const Icon(Icons.archive);
    } else if (_extension == '.epub' ||
        _extension == '.pdf' ||
        _extension == '.mobi') {
      return const Icon(Icons.text_snippet, color: Colors.orangeAccent);
    } else {
      switch (type) {
        case 'image':
          return Container(
            width: 50,
            height: 50,
            child: Image(
              errorBuilder: (b, o, c) {
                return const Icon(Icons.image);
              },
              image: ResizeImage(FileImage(File(file.path)),
                  width: 50, height: 50),
            ),
          );
        case 'video':
          return Container(
            height: 40,
            width: 40,
            child: videothumbnail(
              path: file.path,
            ),
          );
        case 'audio':
          return const Icon(Icons.music_note, color: Colors.blue);
        case 'text':
          return const Icon(Icons.text_snippet, color: Colors.orangeAccent);
        default:
          return const Icon(Icons.file_copy);
      }
    }
  }
}

class videothumbnail extends StatefulWidget {
  final String path;

  videothumbnail({
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  _videothumbnailState createState() => _videothumbnailState();
}

class _videothumbnailState extends State<videothumbnail>
    with AutomaticKeepAliveClientMixin {
  String thumb = '';
  bool loading = true;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            loading = false;
          }); //when your thumbnail will show.
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return loading
        ? Image.asset(
            'assets/images/video-placeholder.png',
            height: 40,
            width: 40,
            fit: BoxFit.cover,
          )
        : VideoPlayer(_controller);
  }

  @override
  bool get wantKeepAlive => true;
}

class filepopup extends StatelessWidget {
  final String path;
  final Function popTap;

  filepopup({
    Key? key,
    required this.path,
    required this.popTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: (val) => popTap(val),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 0, child: Text('Rename')),
        const PopupMenuItem(value: 1, child: const Text('Delete')),
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
