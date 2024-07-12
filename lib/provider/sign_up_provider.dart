import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oz/pages/Sign_up_page.dart';

class SignUpProvider extends ChangeNotifier {
  final _authentication = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User? loggedUser;

  String _name = '';
  String _email = '';
  String _password = '';

  var _token = 20;
  List _myOz = ["1"];
  String _myProfile = '1';

  String get name => _name;

  set userName(value) {
    _name = value;
    notifyListeners();
  }

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
      // return '이메일을 입력해 주세요';
      return null;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      // return '이메일 형식에 맞게 입력해 주세요';
      return null;

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
      // return '4자리 이상의 비밀번호를 입력해 주세요';
      return null;
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      // return '이름을 입력해 주세요';
      return null;
    }
    return null;
  }

  Future<void> signUp(BuildContext context) async {
    // 로그인처리 함수
    try {
      final newUser = await _authentication.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      if (newUser.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => SignUpPage()),
        );
        addData();
      }
    } catch (e) {
      print('signUn(회원가입오류): $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('이메일과 비밀번호를 형식에 맞게 작성해 주세요!'),
          backgroundColor: Color(0xFFFF2D92),
        ),
      );
    }
  }

  void addData() async {
    await _firestore.collection('userinfo').add({
      'email': _email,
      'myOz': _myOz,
      'myProfile': _myProfile,
      'name': _name,
      'token': _token,
    });
  }

  // void getCurrentUser() {
  //   try {
  //     final user = _authentication.currentUser;
  //     if (user != null) {
  //       loggedUser = user;
  //       // print(loggedUser!.email);
  //     }
  //     notifyListeners();
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
