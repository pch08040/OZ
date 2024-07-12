import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:oz/provider/ozCard_provider.dart';
import 'package:oz/provider/sign_in_provider.dart';
import 'package:oz/provider/token_provider.dart';
import 'package:oz/utils/assets.dart';
import 'package:oz/widgets/my_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Provider.of<TokenProvider>(context, listen: false).getData();
      Provider.of<OzcardProvider>(context, listen: false).getMyCardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _tokenProvider = Provider.of<TokenProvider>(context);
    final _ozCardProvider = Provider.of<OzcardProvider>(context);
    final _signInProvider = Provider.of<SignInProvider>(context);

    return KeyboardDismisser(
      child: SafeArea(
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(60), child: MyAppBar()),
              body: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(Assets.token),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${_tokenProvider.token}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
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
                      child: TextField(
                        onChanged: (text) {
                          _ozCardProvider.updateMySearchText(text);
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFFFF2D92),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(35.0)),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(35.0)),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Consumer<OzcardProvider>(
                    builder: (context, provider, child) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: _ozCardProvider.myCardDataList.length,
                          itemBuilder: (context, i) {
                            final myCardData =
                                _ozCardProvider.myCardDataList[i];
                            return Column(
                              children: [
                                Image.network(myCardData['url']),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(25, 0, 25, 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        '${myCardData['token']} token',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          // 카드 선택해서 프로필 바꾸는 버튼
                                          _ozCardProvider
                                              .changeProfile(myCardData['id']);
                                          if (_ozCardProvider.choiceId ==
                                              myCardData['id']) {
                                            await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    child: Container(
                                                      width: 200,
                                                      height: 170,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                15), // 모든 모서리를 15의 반지름으로 둥글게 처리
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black26,
                                                            blurRadius: 6,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Text(
                                                            '이미 선택된 오즈입니다!',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Retro',
                                                                fontSize: 20),
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                              '확인',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Retro',
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .amber),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                          }
                                        },
                                        // 나의 프로필번호와 이미지 아이디가 같으면
                                        child: _ozCardProvider.choiceId ==
                                                myCardData['id']
                                            ? Image.asset(Assets.choiceButton2)
                                            : Image.asset(Assets.choiceButton),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                _ozCardProvider
                                                    .plusLove(myCardData['id']);
                                                // print(myCardData['id']);
                                              },
                                              icon: myCardData['love'] != 0
                                                  ? Icon(
                                                      Icons.favorite,
                                                      color: Colors.red,
                                                    )
                                                  : Icon(
                                                      Icons.favorite,
                                                      color: Colors.grey,
                                                    )),
                                          Text(
                                            '${myCardData['love']}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () async {
                    await _signInProvider.signOut(context);
                  },
                  child: Text('LogOut',
                      style: TextStyle(
                          fontFamily: 'Retro',
                          fontSize: 17,
                          color: Colors.black)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
