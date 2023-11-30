import 'package:flutter/material.dart';

enum SampleItem { create, enter }

class HomeBody extends StatefulWidget {
  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  SampleItem? selectedMenu;
  var offsetValue = 50.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 48,
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Color(0xff6d8aa1))),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            cursorHeight: 20,
            cursorColor: Color(0xff6d8aa1),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 12),
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xff6d8aa1),
                ),
                suffixIcon: Icon(
                  Icons.send,
                  color: Color(0xff6d8aa1),
                  size: 20,
                )),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('그룹'),
              PopupMenuButton(
                offset: Offset(-20, offsetValue),
                icon: Icon(Icons.add),
                initialValue: selectedMenu,
                onSelected: (SampleItem item) {
                  setState(() {
                    selectedMenu = item;
                    if (selectedMenu == SampleItem.create) {
                      offsetValue = 60.0;
                      Navigator.of(context).pushNamed('/createroom');
                    } else if (selectedMenu == SampleItem.enter) {
                      offsetValue = 110.0;
                      Navigator.of(context).pushNamed('/enterroom');
                    }
                  });
                },
                itemBuilder: (context) => <PopupMenuEntry<SampleItem>>[
                  PopupMenuItem<SampleItem>(
                    value: SampleItem.create,
                    child: Text("그룹 생성하기"),
                  ),
                  PopupMenuItem<SampleItem>(
                    value: SampleItem.enter,
                    child: Text("그룹 참가하기"),
                  )
                ],
              ),
            ],
          ),
        ),
        //TODO: GirdView
      ],
    );
  }
}
