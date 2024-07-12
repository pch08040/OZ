import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:oz/provider/google_provider.dart';
import 'package:oz/provider/sign_up_provider.dart';
import 'package:oz/utils/assets.dart';
import 'package:provider/provider.dart';

class SignUpPage2 extends StatefulWidget {
  const SignUpPage2({super.key});

  @override
  State<SignUpPage2> createState() => _SplashPageState();
}

class _SplashPageState extends State<SignUpPage2> {
  @override
  Widget build(BuildContext context) {
    final _signupProvider = Provider.of<SignUpProvider>(context);
    final _formKey = GlobalKey<FormState>();

    void _tryValidation() {
      final isValid = _formKey.currentState!.validate();
      // validate 에 값이 있으면
      if (isValid) {
        _formKey.currentState!.save();
      }
    }

    return KeyboardDismisser(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Form(
            key: _formKey,
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
                Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    validator: _signupProvider.validateUsername,
                    // onChaged는 사용자가 입력할 때마다 즉시 유효성을 검사를 해야 할때 유용
                    onSaved: (value) {
                      _signupProvider.userName = value;
                    },
      
                    decoration: const InputDecoration(
                      hintText: '닉네임',
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.person_outlined),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(35.0)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(35.0)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    validator: _signupProvider.validateEmail,
                    // 사용자가 입력할 때마다 즉시 유효성을 검사를 해야 할때 유용
                    onSaved: (value) {
                      _signupProvider.userEmail = value;
                    },
                    decoration: const InputDecoration(
                      hintText: '이메일',
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.mail_outline),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(35.0)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(35.0)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    validator: _signupProvider.validatePassword,
                    // 사용자가 입력할 때마다 즉시 유효성을 검사를 해야 할때 유용
                    onSaved: (value) {
                      _signupProvider.userPassword = value;
                    },
                    decoration: const InputDecoration(
                      hintText: '비밀번호 (4자리 이상)',
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(Icons.lock_outlined),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(35.0)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(35.0)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextButton(
                    onPressed: () async {
                      _tryValidation();
                      _signupProvider.signUp(context);
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFFFF2D92),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
