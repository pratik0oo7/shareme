// ignore_for_file: camel_case_types, unnecessary_statements, sized_box_for_whitespace, use_named_constants

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shareme/box/file_utils.dart';
import 'package:shareme/navigators%20&%20view/navigate.dart';
import 'package:shareme/ui/file/filesScreen/folder.dart';

class storagedetails extends StatelessWidget {
  final double percent;
  final String title;
  final String path;
  final Color color;
  final IconData icon;
  final int usedspace;
  final int totalspace;
  const storagedetails({
    required this.percent,
    required this.title,
    required this.path,
    required this.color,
    required this.icon,
    required this.usedspace,
    required this.totalspace,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        navigate.pushPage(
          context,
          folder(title: title, path: path),
        );
      },
      contentPadding: const EdgeInsets.only(right: 20),
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 2,
          ),
        ),
        child: Center(
          child: Icon(
            icon,
            color: color,
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title),
          Text(
            '${FileUtils.formatBytes(usedspace, 2)}'
            'used of ${FileUtils.formatBytes(totalspace, 2)}',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15.0,
              color: Theme.of(context).textTheme.headline1!.color,
            ),
          ),
        ],
      ),
      subtitle: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: LinearPercentIndicator(
          padding: const EdgeInsets.all(0),
          backgroundColor: Colors.grey.shade300,
          percent: percent,
          progressColor: color,
        ),
      ),
    );
  }
}
