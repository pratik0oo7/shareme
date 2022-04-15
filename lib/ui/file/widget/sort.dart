// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shareme/configfile.dart';
import 'package:shareme/service/categoryprovider.dart';

class sortsheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.85,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 15,
            ),
            Text(
              'Sort by'.toUpperCase(),
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Flexible(
              child: ListView.builder(
                itemCount: Constants.sortList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () async {
                      await Provider.of<categoryprovider>(
                        context,
                        listen: false,
                      ).setsort(index);
                      Navigator.pop(context);
                    },
                    contentPadding: const EdgeInsets.all(0),
                    trailing: index ==
                            Provider.of<categoryprovider>(
                              context,
                              listen: false,
                            ).sort
                        ? const Icon(
                            Icons.check,
                            color: Colors.blue,
                            size: 16,
                          )
                        : const SizedBox(),
                    title: Text(
                      '${Constants.sortList[index]}',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: index ==
                                Provider.of<categoryprovider>(
                                  context,
                                  listen: false,
                                ).sort
                            ? Colors.blue
                            : Theme.of(context).textTheme.headline6!.color,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
