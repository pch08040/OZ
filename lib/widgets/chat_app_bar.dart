import 'package:flutter/material.dart';
import 'package:oz/utils/assets.dart';

class ChatAppBar extends StatefulWidget {
  const ChatAppBar({super.key, required this.clearMessages});
  final VoidCallback clearMessages;

  @override
  State<ChatAppBar> createState() => _ChatAppBarState();
}

class _ChatAppBarState extends State<ChatAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        //앱바와 페이지의 구분을 주기 위해 BoxShadow로 그림자 만들어서 사용.
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
              child: Image.asset(
            Assets.logo,
            width: 30,
          )),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.close),
              // State 클래스 내부에서는 widget 속성을 통해 부모 StatefulWidget에 접근할 수 있다
              // 이는 State 객체가 StatefulWidget과 연결되어 있기 때문
              onPressed: widget.clearMessages,
            ),
          ),
        ],
      ),
    );
  }
}
