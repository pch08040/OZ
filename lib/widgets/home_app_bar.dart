import 'package:flutter/material.dart';
import 'package:oz/pages/my_page.dart';
import 'package:oz/pages/shop_page.dart';
import 'package:oz/utils/assets.dart';
import 'package:oz/provider/token_provider.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final _tokenProvider = Provider.of<TokenProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
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
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 10),
            Image.asset(
              Assets.token,
              width: 30,
            ),
            SizedBox(width: 10),
            Text(
              '${_tokenProvider.token}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (c) => ShopPage()));
                },
                icon: Icon(Icons.shopping_cart_outlined)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (c) => MyPage()));
                },
                icon: Icon(Icons.person_outlined)),
          ],
        ),
      ),
    );
  }
}
