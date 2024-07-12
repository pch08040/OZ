import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OzcardProvider extends ChangeNotifier {
  final _authentication = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  User? loggedUser;

  String choiceId = '';
  String profileURL = '';
  String mainProfileURL = '';

  List<Map<String, dynamic>> cardDataList = [];

  List<Map<String, dynamic>> myCardDataList = [];

  bool checkShopOz = false;

  bool cardLoading = false;

  bool loveState = false;

  Future<void> getCurrentUser() async {
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
        // print(loggedUser!.email);
        var userEmail = loggedUser!.email;
        // 문서 가져오는 함수
        QuerySnapshot userData = await firestore
            .collection('userinfo')
            .where('email', isEqualTo: userEmail)
            .get();

        // choiceId로 메인프로필이랑 프로필 url찾아서 돌려주는 부분

        choiceId = userData.docs.first['myProfile'];

        QuerySnapshot ozProfile = await firestore
            .collection('ozProfile')
            .where('id', isEqualTo: choiceId)
            .get();

        QuerySnapshot ozMainProfile = await firestore
            .collection('ozGif')
            .where('id', isEqualTo: choiceId)
            .get();

        profileURL = ozProfile.docs.first['url'];
        mainProfileURL = ozMainProfile.docs.first['url'];

        notifyListeners();
      }
    } catch (e) {
      print('ozCard(유저정보): $e');
    }
  }

  Future<void> updateSearchText(String newText) async {
    String _searchText = '';
    _searchText = newText;

    try {
      QuerySnapshot result = await firestore.collection('ozCard').get();

      // 검색어와 일치하는 문서들을 필터링하여 새로운 리스트에 저장
      // ozCard 컬렉션과 내가 검색한 값과 같은 키워드를 가진 문서를 가져와서 filteredList에 넣어줌
      List<Map<String, dynamic>> filterList = result.docs
          .where((doc) => doc['name']
              .toString()
              .toLowerCase()
              .contains(_searchText.toLowerCase().toString()))
          .map((doc) => {
                'id': doc['id'],
                'love': doc['love'],
                'name': doc['name'],
                'token': doc['token'],
                'url': doc['url'],
              })
          .toList();

      if (_searchText == '') {
        getCardData();
        cardDataList = cardDataList;
      } else {
        cardDataList = filterList;
      }

      // if (filterList.isEmpty) {
      //   cardDataList = cardDataList;
      // } else {
      //   cardDataList = filterList;
      // }
      notifyListeners();
    } catch (e) {
      print('ozCard(검색 업데이트): $e');
    }
  }

  Future<void> updateMySearchText(String newText) async {
    String _searchText = '';
    _searchText = newText;
    List<Map<String, dynamic>> filterList = [];

    try {
      if (loggedUser != null) {
        var userEmail = loggedUser!.email;
        // 카드 문서정보 가져오기
        QuerySnapshot cardData = await firestore.collection('ozCard').get();
        // 나의 문서정보 가져오기
        QuerySnapshot userData = await firestore
            .collection('userinfo')
            .where('email', isEqualTo: userEmail)
            .get();

        // 나의 문서의 필드값 가져오기
        List<String> myOzIds = [];
        if (userData.docs.isNotEmpty) {
          myOzIds = List.from(userData.docs.first['myOz']);
        }

        // 카드 아이디와 내가 가진 아이디들 비교 후 같은값 배열에 저장
        for (var cardDoc in cardData.docs) {
          if (myOzIds.contains(cardDoc['id'])) {
            myCardDataList.add({
              'id': cardDoc['id'],
              'love': cardDoc['love'],
              'name': cardDoc['name'],
              'token': cardDoc['token'],
              'url': cardDoc['url'],
            });
          }
        }

        for (var card in myCardDataList) {
          if (card['name']
              .toString()
              .toLowerCase()
              .contains(_searchText.toLowerCase().toString())) {
            filterList.add(card);
          }
        }

        if (_searchText == '') {
          getMyCardData();
          myCardDataList = myCardDataList;
        } else {
          myCardDataList = filterList;
        }
        notifyListeners();
      }
    } catch (e) {
      print('ozCard(검색 업데이트): $e');
    }
  }

/////////////////////////////////////// cardData

  void getCardData() async {
    cardLoading = true;
    notifyListeners();
    try {
      // ozCard 컬렉션의 모든 문서를 가져옴
      QuerySnapshot result = await firestore.collection('ozCard').get();
      print('현재 로그인한 유저입니다!!!!!!! : ${loggedUser!.email}');

      cardDataList = result.docs.map((doc) {
        return {
          'id': doc['id'],
          'love': doc['love'],
          'name': doc['name'],
          'token': doc['token'],
          'url': doc['url'],
        };
      }).toList();

      cardDataList.sort((a, b) => b['id'].compareTo(a['id']));
    } catch (e) {
      print('ozCard(카드데이터): $e');
    }

    cardLoading = false;
    notifyListeners();
  }

  void getMyCardData() async {
    getCurrentUser();
    try {
      if (loggedUser != null) {
        var userEmail = loggedUser!.email;
        // 카드 문서정보 가져오기
        QuerySnapshot cardData = await firestore.collection('ozCard').get();
        // 나의 문서정보 가져오기
        QuerySnapshot userData = await firestore
            .collection('userinfo')
            .where('email', isEqualTo: userEmail)
            .get();

        // 나의 문서의 필드값 가져오기
        List<String> myOzIds = [];
        if (userData.docs.isNotEmpty) {
          myOzIds = List.from(userData.docs.first['myOz']);
        }

        // 기존 리스트제거(중복 데이터가 쌓이는걸 방지)
        myCardDataList.clear();

        // 카드 아이디와 내가 가진 아이디들 비교 후 같은값 배열에 저장
        for (var cardDoc in cardData.docs) {
          if (myOzIds.contains(cardDoc['id'])) {
            myCardDataList.add({
              'id': cardDoc['id'],
              'love': cardDoc['love'],
              'name': cardDoc['name'],
              'token': cardDoc['token'],
              'url': cardDoc['url'],
            });
          }
        }
        myCardDataList.sort((a, b) => b['id'].compareTo(a['id']));
        notifyListeners();
      }

      // 거기서 myOz에 들어있는 값과 같은 id값을 가진 문서만 list에 넣고 출력
    } catch (e) {
      print('ozCard(내카드데이터): $e');
    }
  }

  void changeProfile(String profileId) async {
    try {
      if (loggedUser != null) {
        // var userEmail = loggedUser!.email;
        var result = await firestore.collection('userinfo').get();
        for (var doc in result.docs) {
          if (loggedUser!.email == doc['email']) {
            await firestore
                .collection('userinfo')
                .doc(doc.id)
                .update({'myProfile': profileId});
            choiceId = profileId;
            getCurrentUser();
            notifyListeners();
          }
        }
      }
    } catch (e) {
      print('ozCard(나의프로필바꾸기): $e');
    }
  }

  void plusLove(String? loveid) async {
    try {
      // userinfo 컬렉션에서 현재 사용자의 문서를 찾음
      QuerySnapshot user = await firestore
          .collection('userinfo')
          .where('email', isEqualTo: loggedUser!.email)
          .get();

      if (user.docs.isNotEmpty) {
        DocumentSnapshot userDoc = user.docs.first;
        DocumentReference userDocRef = userDoc.reference;

        // 유저의 loveList 배열을 가져옴
        List<dynamic> loveList = userDoc['loveList'] ?? [];

        // loveid가 loveList에 있는지 확인
        bool isLoved = loveList.contains(loveid);

        // ozCard 컬렉션의 해당 문서를 참조
        QuerySnapshot result = await firestore
            .collection('ozCard')
            .where('id', isEqualTo: loveid)
            .get();

        if (result.docs.isNotEmpty) {
          DocumentSnapshot cardLove = result.docs.first;
          DocumentReference cardDocRef = cardLove.reference;

          // love 필드의 현재 값을 가져옴
          int currentLove = cardLove['love'];

          if (isLoved) {
            // loveid가 loveList에 있으면 제거하고, love 값을 -1
            loveList.remove(loveid);
            currentLove -= 1;
            loveState = false;
          } else {
            // loveid가 loveList에 없으면 추가하고, love 값을 +1
            loveList.add(loveid);
            loveState = true;
            currentLove += 1;
          }

          // Firestore에 loveList와 love 필드를 업데이트
          await userDocRef.update({'loveList': loveList});
          await cardDocRef.update({'love': currentLove});

          // 로컬 데이터 업데이트
          int index = cardDataList.indexWhere((doc) => doc['id'] == loveid);
          if (index != -1) {
            cardDataList[index]['love'] = currentLove;
          }

          // 화면 갱신
          notifyListeners();
        }
      }
    } catch (e) {
      print('ozCard(하트추가): $e');
    }

    // 유저가 하트를 누르면 유저의 하트리스트에 love카드의 id값이 들어가고 card의 하트값이 +1
    // 그리고 loveState true로 바꿈.
    // 다시클릭했을때 유저의 하트리스트에 카드의 id값이 있으면 card 하트값 -1
    // 그리고 loveState false로 바꿈
  }

  Future<void> checkGetOz(String shopId) async {
    try {
      // 문서가져오고 그 문서의 myOz필드에 shopId와 같은 값이 있으면 false, 없으면 true
      QuerySnapshot result = await firestore
          .collection('userinfo')
          .where('email', isEqualTo: loggedUser!.email)
          .get();

      for (var doc in result.docs) {
        List<dynamic> myOzList = doc['myOz'];
        if (myOzList.contains(shopId)) {
          checkShopOz = true;
        } else {
          checkShopOz = false;
        }
      }
      notifyListeners();
    } catch (e) {
      print('ozCard(구매오즈체크): $e');
    }
  }
}
