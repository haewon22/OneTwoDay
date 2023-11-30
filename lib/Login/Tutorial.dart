import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Tutorial extends StatefulWidget{
  @override
  TutorialState createState() => TutorialState();
}

class TutorialState extends State<Tutorial> {
  int _page = 0;
  List<dynamic> _pageColor = [Color(0xff2e8b57), Color(0xff8a4ebf), Color(0xff4169e1)];
  List<dynamic> _firstBoxColor = [Colors.white, Colors.white70, Colors.transparent];
  List<dynamic> _secondBoxColor = [Colors.white70, Colors.white, Colors.transparent];
  List<String> _centerLottie = ['assets/lotties/collaboration.json', 'assets/lotties/alarm.json', 'assets/lotties/handshake.json'];
  List<String> _titleText = ["협업의 모든 것을 간편하게", "이제 까먹지 말아요", "협업을 시작해볼까요"];
  List<String> _descriptionText = [
    "그룹 캘린더, 일정, 공지, 채팅 기능 모두\n원투데이 하나로 해결",
    "다가오는 일정, 마감 기한을 따로 기록하지 않아도\n원투데이에서 미리 푸시알람으로 알려드려요",
    "원투데이로 세상의 모든 협업을 시작해봅시다"
  ];
  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            height: mediaSize.height,
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
            color: _pageColor[_page]
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 30,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _page = 0;
                              });
                            },
                            child: AnimatedContainer(
                              width: (_page == 0) ? 30 : 15,
                              height: 7,
                              margin: EdgeInsets.symmetric(horizontal: 2),
                              duration: const Duration(seconds: 1),
                              curve: Curves.fastOutSlowIn,
                              decoration: BoxDecoration(
                                color: _firstBoxColor[_page],
                                borderRadius: BorderRadius.circular(10)
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _page = 1;
                              });
                            },
                            child: AnimatedContainer(
                              width: (_page == 0) ? 15 : 30,
                              height: 7,
                              margin: EdgeInsets.symmetric(horizontal: 2),
                              duration: const Duration(seconds: 1),
                              curve: Curves.fastOutSlowIn,
                              decoration: BoxDecoration(
                                color: _secondBoxColor[_page],
                                borderRadius: BorderRadius.circular(10)
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _page = 2;
                            });
                          },
                          child: Text(
                            "Skip",
                            style: TextStyle(
                              color: (_page == 2) ? Colors.transparent : Colors.white,
                              fontWeight: FontWeight.bold
                            )
                          )
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: mediaSize.height * 0.45,
                  alignment: Alignment.center,
                  child: Lottie.asset(_centerLottie[_page]),
                ),
                Container(
                  height: 60,
                  child: Text(
                    _titleText[_page],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900
                    )
                  ),
                ),
                Container(
                  height: 60,
                  child: Text(
                    _descriptionText[_page],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      height: 1.7
                    )
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _page++;
                      });
                    },
                    child: Container(
                      child: _bottomButton(mediaSize)
                    )
                  )
                )
              ]
            )
          )
        ],
      )
    );
  }

  Widget _bottomButton(dynamic mediaSize) {
    if (_page == 2) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/signup');
            },
            child: Container(
              width: mediaSize.width,
              height: 55,
              margin: EdgeInsets.symmetric(horizontal: 30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(55)
              ),
              child: Text(
                "새로운 계정으로 시작하기",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700
                )
              ),
            )
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 25),
            child: GestureDetector(
              onTap: () {
                  Navigator.of(context).pushNamed('/signin');
              },
              child: Text(
                "이미 계정이 있어요",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                )
              )
            ),
          )
        ],
      );
    }
    return Container(
      padding: EdgeInsets.all(25),
      child: Icon(Icons.navigate_next, size: 30, color: Colors.black),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle
      ),
    );
  }
}