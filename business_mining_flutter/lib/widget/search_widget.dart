import 'package:business_mining/common/color.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const SearchWidget({
    Key key,
    this.controller,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 48,
      padding: const EdgeInsets.only(left: 22, right: 22, top: 14),
      child: TextField(
        textAlign: TextAlign.center,
        controller: controller,
        style: Theme.of(context).textTheme.bodyText2.copyWith(color: TextColor.textBlack),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          hintText: hintText ?? '请输入关键字',
          hintStyle: Theme.of(context).textTheme.bodyText2,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: Color(0xFFC7C7C7),
              width: 0.4,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 1,
            ),
          ),
          filled: true,
          fillColor: Color(0xFFf7f8f9),
        ),
      ),
    );
  }
}
