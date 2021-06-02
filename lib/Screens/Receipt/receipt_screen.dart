import 'package:Canny/Screens/Sidebar/sidebar_menu.dart';
import 'package:flutter/material.dart';
import 'package:Canny/Shared/colors.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ReceiptScreen extends StatefulWidget {
  static final String id = 'receipt_screen';

  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {

  final List imgList = [
    'styles/images/Function-Screen-illustration.png',
    'styles/images/add-comment-illustration.png',
    'styles/images/add-discussion-illustration.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDeepOrangePrimary,
        title: Text(
          "RECEIPT",
          style: TextStyle(fontFamily: 'Lato'),
        ),
      ),
      drawer: SideBarMenu(),
      backgroundColor: kBackgroundColour,
      body: new Swiper(
        itemBuilder: (BuildContext context, int index) {
          return new Image.asset(
            imgList[index],
            fit: BoxFit.fitWidth,
          );
        },
        itemCount: imgList.length,
        pagination: SwiperPagination(),
        viewportFraction: 0.7,
        scale: 0.8,
      ),
    );
  }
}