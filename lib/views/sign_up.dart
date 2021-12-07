import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: usernameController,
                    style: simpleTextStyle(),
                    decoration: textFieldInputDecoration('username'),
                  ),
                  TextFormField(
                    controller: emailController,
                    style: simpleTextStyle(),
                    decoration: textFieldInputDecoration('email'),
                  ),
                  TextFormField(
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
              onTap: () {},
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
                  'Sign Up',
                  style: mediumTextStyle(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'Sign Up with Google',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 17,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: mediumTextStyle(),
                ),
                const Text(
                  'Sign in',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    decoration: TextDecoration.underline,
                  ),
                )
              ],
            ),
            const SizedBox(height: 50)
          ],
        ),
      ),
    );
  }
}
