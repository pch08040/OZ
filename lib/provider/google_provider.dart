import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oz/pages/home_page.dart';

class GoogleProvider extends ChangeNotifier {
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // 구글 로그인 프로세스 시작
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // 로그인 취소된 경우
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Firebase에 인증 정보를 전달하여 사용자 로그인
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Firestore에 사용자 정보 저장
        final userDoc =
            FirebaseFirestore.instance.collection('userinfo').doc(user.uid);

        final userSnapshot = await userDoc.get();
        if (!userSnapshot.exists) {
          // Firestore에 사용자 정보 저장
          final userData = {
            'email': user.email,
            'myOz': ['1'], // 초기값으로 '1'을 포함하는 배열
            'myProfile': '1', // 초기값으로 '1'
            'name': user.email, // 가입한 구글 이메일 사용
            'token': 10, // 초기값으로 10
          };

          await userDoc.set(userData, SetOptions(merge: true));
        }

        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (c) => HomePage()),
        //     (Route<dynamic> route) => false);
        Navigator.pushReplacementNamed(context, '/home');
      }
      notifyListeners();
    } catch (e) {
      print('구글오류: $e');
      // 오류 처리 로직 추가
    }
  }
}
