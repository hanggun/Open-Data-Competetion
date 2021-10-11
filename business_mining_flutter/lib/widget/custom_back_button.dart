import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../r.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    Key key,
    this.icon,
    this.color,
    this.onPressed,
  }) : super(key: key);

  final Color color;
  final VoidCallback onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: this.icon ??
          ImageIcon(
            AssetImage(R.imgBackIcon),
            size: 16,
            color: color ?? Colors.white,
          ),
      onPressed: () {
        if (onPressed != null) {
          onPressed();
        } else {
          Navigator.maybePop(context);
        }
      },
    );
  }
}
