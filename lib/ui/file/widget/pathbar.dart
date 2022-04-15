import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class pathbar extends StatelessWidget implements PreferredSizeWidget {
  final List paths;
  final Function(int) onChanged;
  final IconData? icon;

  pathbar({
    Key? key,
    required this.paths,
    required this.onChanged,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: paths.length,
          itemBuilder: (BuildContext context, int index) {
            String i = paths[index] as String;
            List splited = i.split('/');
            if (index == 0) {
              return IconButton(
                icon: Icon(
                  icon ?? Icons.smartphone,
                  color: index == paths.length - 1
                      ? Theme.of(context).accentColor
                      : Theme.of(context).textTheme.headline6!.color,
                ),
                onPressed: () => onChanged(index),
              );
            }
            return InkWell(
              onTap: () => onChanged(index),
              child: SizedBox(
                height: 40,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      '${splited[splited.length - 1]}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: index == paths.length - 1
                            ? Theme.of(context).accentColor
                            : Theme.of(context).textTheme.headline6!.color,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Icon(LucideIcons.arrowRight);
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40.0);
}
