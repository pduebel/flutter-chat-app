import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chat_rooms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class SignIn extends StatefulWidget {
  final VoidCallback toggle;

  const SignIn({Key? key, required this.toggle}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthMethods authMethods = AuthMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();

  bool isLoading = false;
  QuerySnapshot<Map<String, dynamic>>? snapshotUserInfo;

  signIn() {
    if (formKey.currentState!.validate()) {
      String userEmail = emailController.text;

      setState(() {
        isLoading = true;
      });

      authMethods
          .signInWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((val) {
        if (val != null) {
          HelperFunctions.saveUserEmailSharedPreference(userEmail);
          databaseMethods.getUserByEmail(userEmail).then((val) {
            snapshotUserInfo = val;
            HelperFunctions.saveUserNameSharedPreference(
                snapshotUserInfo!.docs[0].data()['name']);
          });
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (val) {
                        return val != null &&
                                RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val)
                            ? null
                            : "Please enter a valid email address";
                      },
                      controller: emailController,
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration('email'),
                    ),
                    TextFormField(
                      validator: (val) {
                        return val != null && val.length >= 6
                            ? null
                            : "Please enter a password longer than 6 characters";
                      },
                      obscureText: true,
                      controller: passwordController,
                      style: simpleTextStyle(),
                      decoration: textFieldInputDecoration('password'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    'Forgot Password?',
                    style: simpleTextStyle(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  signIn();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff007EF4), Color(0xff2A75BC)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Sign In',
                    style: mediumTextStyle(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: mediumTextStyle(),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.toggle();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 50)
            ],
          ),
        ),
      ),
    );
  }
}
