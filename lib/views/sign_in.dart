import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              TextField(
                style: simpleTextFieldStyle(),
                decoration: textFieldInputDecoration('email'),
              ),
              TextField(
                style: simpleTextFieldStyle(),
                decoration: textFieldInputDecoration('password'),
              ),
            ],
          ),
        ));
  }
}
