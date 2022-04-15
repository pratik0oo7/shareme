// ignore_for_file: avoid_multiple_declarations_per_line, avoid_dynamic_calls, prefer_final_locals, camel_case_types, non_constant_identifier_names, sized_box_for_whitespace

import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shareme/service/coreprovider.dart';
import 'package:shareme/ui/file/widget/storadedetails.dart';

import '../../configfile.dart';

class Browse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.shade50,
      // body: Container(
      // color: Colors.amber,
      // child: const Text('browser Screen'),
      // ),
      // );
      // return Scaffold(
      //   appBar: AppBar(
      //     centerTitle: true,
      //     // ignore: prefer_const_constructors
      //     title: Text(
      //       'Sync & Share',
      //       style: const TextStyle(fontSize: 25.0),
      //     ),
      //   ),
      body: ListView(
        padding: const EdgeInsets.only(left: .0),
        children: <Widget>[
          const SizedBox(height: 20.0),
          const sectionname(
            name: 'Storage Devices',
          ),
          storagedetail(),
          CustomDivider(),
          //       const SizedBox(height: 20.0),
          //       _SectionTitle('Categories'),
          //       _CategoriesSection(),
          //       CustomDivider(),
          //       const SizedBox(height: 20.0),
          //       _SectionTitle('Recent Files'),
          //       _RecentFiles(),
        ],
      ),
      // ),
      // }
    );
  }
}

class sectionname extends StatelessWidget {
  final String name;
  const sectionname({Key? key, required this.name}) : super(key: key);
  // const sectionname(this.name);
  @override
  Widget build(BuildContext context) {
    return Text(
      name.toUpperCase(),
      // ignore: prefer_const_constructors
      style: TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class storagedetail extends StatelessWidget {
  const storagedetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CoreProvider>(
      builder:
          (BuildContext context, CoreProvider CoreProvider, Widget? child) {
        if (CoreProvider.storageLoading) {
          return SizedBox(
            height: 100,
            width: 50,
            child: CircularProgressIndicator(),
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            FileSystemEntity item = CoreProvider.availableStorage[index];
            String path = item.path.split('Android')[0];
            double percent = 0;
            if (index == 0) {
              percent = calculatepercent(
                  CoreProvider.usedSpace, CoreProvider.totalSpace) as double;
            } else {
              percent = calculatepercent(
                      CoreProvider.usedSDSpace, CoreProvider.totalSDSpace)
                  as double;
            }
            return storagedetails(
              color: index == 0 ? Colors.lightBlue : Colors.orange,
              percent: percent,
              icon: index == 0 ? Icons.smartphone : Icons.sd_storage,
              path: path,
              title: index == 0 ? 'Device' : 'SD Card',
              totalspace: index == 0
                  ? CoreProvider.totalSpace
                  : CoreProvider.totalSDSpace,
              usedspace: index == 0
                  ? CoreProvider.usedSpace
                  : CoreProvider.usedSDSpace,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return CustomDivider();
          },
          itemCount: CoreProvider.availableStorage.length,
        );
      },
    );
  }

  calculatepercent(int usedSpace, int totalSpace) {
    return double.parse((usedSpace / totalSpace * 100).toStringAsFixed(0)) /
        100;
  }
}
