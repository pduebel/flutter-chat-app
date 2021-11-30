import 'package:flutter/material.dart';

PreferredSizeWidget appBarMain(BuildContext context) {
  return AppBar(
    title: Image.asset(
      'assets/images/logo.png',
      height: 50,
    ),
  );
}

InputDecoration textFieldInputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.white54),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
      ),
    ),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  );
}

TextStyle simpleTextFieldStyle() {
  return const TextStyle(
    color: Colors.white,
  );
}
