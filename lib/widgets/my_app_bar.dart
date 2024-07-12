import 'package:flutter/material.dart';
import 'package:oz/pages/shop_page.dart';
import 'package:oz/utils/assets.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({super.key});

  @override
  State<MyAppBar> createState() => _ChatAppBarState();
}

class _ChatAppBarState extends State<MyAppBar> {
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
          // 자식위젯을 부모위젯의 중앙에 위치하게 만듬
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min, // Row의 크기를 자식의 크기에 맞추도록 설정
              children: [
                Text(
                  'MY OZ',
                  style: TextStyle(fontSize: 20, fontFamily: 'Retro', color: Color(0xFFFF2D92)),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (c) => ShopPage()));
                },
                icon: Icon(Icons.shopping_cart_outlined)),
          ),
        ],
      ),
    );
  }
}
