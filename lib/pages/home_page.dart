import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oz/pages/chat_page.dart';
import 'package:oz/provider/ozCard_provider.dart';
import 'package:oz/provider/time_provider.dart';
import 'package:oz/provider/token_provider.dart';
import 'package:oz/utils/assets.dart';
import 'package:oz/widgets/home_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // late final _timeProvider = context.watch<TimeProvider>(); 좋은방법이 아님

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback은 주어진 콜백 함수를 현재 프레임이 완료된 후
    // 다음 프레임이 그려지기 전에 호출하도록 예약하는 메서드
    // 여기서 _는 콜백 함수의 매개변수로, 사용하지 않음을 나타내는 관용적인 표현입니다. 이 경우 콜백 함수가 실행될 때 전달되는 Duration 객체이다.
    //	•	위젯이 완전히 빌드된 후, 즉 UI 트리가 완전히 구축된 후에 어떤 작업을 수행하고자 할 때 사용
    //  •	주로 initState나 didChangeDependencies와 같은 메서드에서 사용

    // Provider.of<TimeProvider>(context, listen: false).timerStart(); 를 그냥쓰면 예외발생
    // 이유는 위젯이 완전히 빌드되기 전에 상태에 접근하려고 하기 때문, initState는 위젯이 완전히 빌드되기 전에 호출되므로,
    // 아직 위젯 트리가 완전히 구축되지 않았다. 이로 인해 context를 통해 Provider에 접근하려고 하면 예외가 발생할 수 있습니다.
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TimeProvider>(context, listen: false).timerStart();
      // Provider.of<OzcardProvider>(context, listen: false).getCurrentUser();
      Provider.of<TokenProvider>(context, listen: false).getData();
      Provider.of<TokenProvider>(context, listen: false).getTokenUser();
      Provider.of<OzcardProvider>(context, listen: false).getCardData();
      Provider.of<OzcardProvider>(context, listen: false).getMyCardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _timeProvider = Provider.of<TimeProvider>(context);
    final _tokenProvider = Provider.of<TokenProvider>(context);
    final _ozCardProvider = Provider.of<OzcardProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: HomeAppBar(),
        ),
        body: Stack(
          children: [
            Positioned(
              top: 15,
              left: 0,
              right: 0,
              child: _ozCardProvider.mainProfileURL.isEmpty
              ? Image.asset(Assets.homeLoading)
              : Image.network(_ozCardProvider.mainProfileURL),
            ),
            Positioned(
              top: (MediaQuery.of(context).size.height / 2) - 70,
              left: 0,
              right: 0,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    '어서오세요.\n오즈에 오신걸 환영합니다!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontFamily: 'Retro'),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (c) => ChatPage()),
                        );
                      },
                      child: Text(
                        "Start Chat",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Retro',
                            color: Color(0xFFFF2D92)),
                      ))
                ],
              ),
            ),
            Positioned(
              bottom: 40,
              right: 20,
              child: Column(
                children: [
                  Text(
                    '${_timeProvider.totalSeconds}',
                    style: TextStyle(
                      fontFamily: 'Retro',
                      color: Colors.grey[300],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_timeProvider.isRunning) {
                        _tokenProvider.addToken();
                        _timeProvider.timerStart();
                      }
                    },
                    child: Image.asset(
                      _timeProvider.isRunning
                          ? Assets.getToken2
                          : Assets.getToken,
                      width: 100,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
