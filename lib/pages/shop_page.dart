import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:oz/provider/ozCard_provider.dart';
import 'package:oz/provider/token_provider.dart';
import 'package:oz/utils/assets.dart';
import 'package:oz/widgets/shop_app_bar.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OzcardProvider>(context, listen: false).getCardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _tokenProvider = Provider.of<TokenProvider>(context);
    final _ozCardProvider = Provider.of<OzcardProvider>(context);

    return KeyboardDismisser(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(60), child: ShopAppBar()),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    // controller: _searchController,
                    onChanged: (text) {
                      _ozCardProvider.updateSearchText(text);
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
              ),
              Consumer<OzcardProvider>(builder: (context, provider, child) {
                if (_ozCardProvider.cardLoading) {
                  return Center(
                    child: Image.asset(Assets.homeLoading),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: _ozCardProvider.cardDataList.length,
                    itemBuilder: (context, i) {
                      final cardData = _ozCardProvider.cardDataList[i];
                      return Column(
                        children: [
                          // 카드 이미지
                          Image.network(cardData['url']),
                          Padding(
                            padding: EdgeInsets.fromLTRB(25, 0, 25, 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // 카드 가격
                                Text(
                                  '${cardData['token']} Token',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                // 카드 get버튼
                                GestureDetector(
                                  onTap: () async {
                                    await _ozCardProvider
                                        .checkGetOz(cardData['id']);
                                    print(
                                        '_ozCardProvider.checkShopOz : ${_ozCardProvider.checkShopOz}');
                                    if (_ozCardProvider.checkShopOz) {
                                      showDialog(
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
                                                      color: Colors.black26,
                                                      blurRadius: 6,
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Text(
                                                      '이미 소유한 오즈입니다!',
                                                      style: TextStyle(
                                                          fontFamily: 'Retro',
                                                          fontSize: 20),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        '확인',
                                                        style: TextStyle(
                                                            fontFamily: 'Retro',
                                                            fontSize: 20,
                                                            color:
                                                                Colors.amber),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    } else {
                                      showDialog(
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
                                                      color: Colors.black26,
                                                      blurRadius: 6,
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Text(
                                                      '정말 교환하실 건가요?',
                                                      style: TextStyle(
                                                          fontFamily: 'Retro',
                                                          fontSize: 20),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        // 교환 버튼
                                                        await _tokenProvider
                                                            .getOz(
                                                                cardData['id'],
                                                                context);
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        'GET',
                                                        style: TextStyle(
                                                            fontFamily: 'Retro',
                                                            fontSize: 20,
                                                            color:
                                                                Colors.amber),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    }
                                  },
                                  child: Image.asset(Assets.getButton),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          _ozCardProvider
                                              .plusLove(cardData['id']);
                                          print(cardData['id']);
                                        },
                                        icon: cardData['love'] != 0
                                            ? Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                              )
                                            : Icon(
                                                Icons.favorite,
                                                color: Colors.grey,
                                              )),
                                    Text(
                                      '${cardData['love']}',
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
              }),
            ],
          ),
        ),
      ),
    );
  }
}
