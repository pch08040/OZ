import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:oz/pages/home_page.dart';
import 'package:oz/pages/sign_in_page.dart';
import 'package:oz/pages/sign_up_page2.dart';
import 'package:oz/provider/google_provider.dart';
import 'package:oz/utils/assets.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SignUpPage> {
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    final _googleProvider = Provider.of<GoogleProvider>(context);

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Assets.logo,
                width: 180,
              ),
              SizedBox(
                height: 50,
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) => SignUpPage2()),
                  );
                },
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    minimumSize: Size(270, 45),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    backgroundColor: Color(0xFFFF2D92)),
                icon: Icon(Icons.mail_outline),
                label: Text('Sign Up with Email'),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton.icon(
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  await _googleProvider.signInWithGoogle(context);
                  setState(() {
                    showSpinner = false;
                  });
                },
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    minimumSize: Size(270, 45),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    backgroundColor: Colors.black),
                icon: Image.asset(Assets.google_logo),
                label: Text('Sign Up with Google'),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => SignInPage()),
                    );
                  },
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
