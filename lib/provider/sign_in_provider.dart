import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oz/pages/home_page.dart';
import 'package:oz/pages/sign_up_page.dart';
import 'package:oz/pages/splash_page.dart';
import 'package:oz/provider/ozCard_provider.dart';
import 'package:provider/provider.dart';

class SignInProvider extends ChangeNotifier {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  String _email = '';
  String _password = '';

  String get email => _email;

  set userEmail(value) {
    _email = value;
    notifyListeners();
  }

  String get password => _password;

  set userPassword(value) {
    _password = value;
    notifyListeners();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해 주세요';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return '이메일 형식에 맞게 입력해 주세요';

      // example@example.com (가능)
      // user.name@domain.com (가능)

      // example@.com (’.’ 앞에 문자가 없음)
      // example@com (’.’이 없음)
      // @example.com (’@’ 앞에 문자가 없음)
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty || value.length < 4) {
      return '4자리 이상의 비밀번호를 입력해 주세요';
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return '이름을 입력해 주세요';
    }
    return null;
  }

  Future<void> signIn(BuildContext context) async {
    // 로그인처리 함수
    try {
      final newUser = await _authentication.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      if (newUser.user != null) {
        OzcardProvider ozcardProvider =
            Provider.of<OzcardProvider>(context, listen: false);
        await ozcardProvider.getCurrentUser();
        // 로그인하면 그 전 페이지 스택 사라지게
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (c) => HomePage()),
            (Route<dynamic> route) => false);
      }
      // 파이어베이스 로그인 인증관련 오류를 명시
    } on FirebaseAuthException catch (e) {
      print('signIn(로그인인증오류): $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('없는 이메일 or 비밀번호 입니다.'),
          backgroundColor: Color(0xFFFF2D92),
        ),
      );
    } catch (e) {
      print('signIn(없는로그인정보): $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('없는 이메일 or 비밀번호 입니다.'),
          backgroundColor: Color(0xFFFF2D92),
        ),
      );
    }
  }

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
        // print(loggedUser!.email);
      }
    } catch (e) {
      print('signIn(유저정보) : ${e}');
    }
  }

  Future<void> signOut(BuildContext context) async {
    getCurrentUser();
    try {
      if (loggedUser != null) {
        await _authentication.signOut();
        loggedUser = null;

        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => SignUpPage()),
        );
        notifyListeners();
      }
    } catch (e) {
      print('signIn(로그아웃) : ${e}');
    }
  }
}
