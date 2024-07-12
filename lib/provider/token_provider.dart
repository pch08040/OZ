import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TokenProvider extends ChangeNotifier {
  final _authentication = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  User? loggedUser;
  var token;

  Future<void> getTokenUser() async {
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
        await getData();
      }
    } catch (e) {
      print('token(토큰유저오류): $e');
    }
    notifyListeners();
  }

  Future<void> getData() async {
    try {
      // 로그인한 필드의 여러 값을 가져올 수 있음
      if (loggedUser != null) {
        var userEmail = loggedUser!.email;
        var userData = await firestore
            .collection('userinfo')
            .where('email', isEqualTo: userEmail)
            .get();

        var result = userData.docs.first.data();
        token = result['token'];
      }
    } catch (e) {
      print('token(토큰데이터오류): $e');
    }
    ;
    notifyListeners();
  }

  Future<void> addToken() async {
    try {
      var result = await firestore.collection('userinfo').get();
      for (var doc in result.docs) {
        if (loggedUser != null && loggedUser!.email == doc['email']) {
          await firestore
              .collection('userinfo')
              .doc(doc.id)
              .update({'token': token + 1});
          token = token + 1;
          notifyListeners();
        }
      }
    } catch (e) {
      print('token(토큰추가오류): $e');
    }
  }

  Future<void> getOz(String? ozid, BuildContext context) async {
    // - 현재 token의 값이 10을 넘지 않으면 token이 부족하다는 다이얼로그 보여주고 아무일도 없음
    // id값을 전달 받고 id값과 내가 myOz array를 비교
    //  - 값이 존재하면 이미 있다는 다이얼로그 보여주고 아무일도 없음
    // 값이 없다면 해당 값을 myOz array에 넣어주고 token -10

    try {
      if (loggedUser != null) {
        var userEmail = loggedUser!.email;
        var userData = await firestore
            .collection('userinfo')
            .where('email', isEqualTo: userEmail)
            .get();

        var result = userData.docs.first.data();
        var myOz = result['myOz'];
        token = result['token'];

        bool haveOz = false;

        for (var i = 0; i < myOz.length; i++) {
          if (myOz[i] == ozid) {
            haveOz = true;
            break;
          }
        }

        if (token < 10) {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: Container(
                  width: 200,
                  height: 170,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(15), // 모든 모서리를 15의 반지름으로 둥글게 처리
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '토큰이 부족합니다!\n10개의 토큰이 필요합니다',
                        style: TextStyle(fontFamily: 'Retro', fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          // 교환 버튼
                          Navigator.of(context).pop(); // 다이얼로그 닫기
                        },
                        child: Text(
                          '확인',
                          style: TextStyle(
                              fontFamily: 'Retro',
                              fontSize: 20,
                              color: Colors.amber),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        } else if (haveOz) {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: Container(
                  width: 200,
                  height: 170,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(15), // 모든 모서리를 15의 반지름으로 둥글게 처리
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '이미 소유한 오즈입니다!',
                        style: TextStyle(fontFamily: 'Retro', fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          // 교환 버튼
                          Navigator.of(context).pop(); // 다이얼로그 닫기
                        },
                        child: Text(
                          '확인',
                          style: TextStyle(
                              fontFamily: 'Retro',
                              fontSize: 20,
                              color: Colors.amber),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          var result = await firestore.collection('userinfo').get();
          for (var doc in result.docs) {
            if (loggedUser != null && loggedUser!.email == doc['email']) {
              await firestore
                  .collection('userinfo')
                  .doc(doc.id)
                  .update({'token': token - 10});
              token = token - 10;

              await firestore.collection('userinfo').doc(doc.id).update({
                'myOz': FieldValue.arrayUnion([ozid])
              });
              notifyListeners();
              return;
            }
          }
        }
      }
    } catch (e) {
      print('token(오즈교환오류): $e');
    }
    ;
  }
}
