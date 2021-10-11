import 'package:business_mining/common/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../r.dart';

typedef OnMultiTap = Function(String text);

class FilterListWidget extends StatelessWidget {
  final List<String> filters;
  final String checked;
  final OnMultiTap onTap;

  const FilterListWidget({
    Key key,
    this.filters,
    this.checked,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = filters
        .map<Widget>(
          (e) => ListTile(
            onTap: () {
              onTap(e);
            },
            contentPadding: const EdgeInsets.only(top: 4, bottom: 4, left: 32, right: 16),
            title: Text(
              e,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(color: e == checked ? Theme.of(context).primaryColor : TextColor.textBlack),
            ),
            trailing: e == checked
                ? SvgPicture.asset(
                    R.svgChecked,
                    width: 16,
                  )
                : null,
          ),
        )
        .toList(growable: true);
    children.add(
      Padding(padding: const EdgeInsets.only(top: 16)),
    );
    children.add(Material(
      color: Theme.of(context).primaryColor,
      child: InkWell(
        onTap: () {
          onTap('');
        },
        child: Container(
          height: 48,
          width: double.infinity,
          alignment: Alignment.center,
          child: Text('确定', style: TextStyle(color: Colors.white, fontSize: 14)),
        ),
      ),
    ));
    return Material(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
