import 'package:flutter/material.dart';
import 'Myboard.dart';

class Mywriting extends StatefulWidget{
  @override
  MywritingState createState() => MywritingState();
}

class MywritingState extends State<Mywriting> {
  final _textEditingController=TextEditingController(text:'');
  final notice2=MyboardState().notice;
  final String me='minseung';

  final List<Map<String,dynamic>> comment=[
    {
      'name':'minseung',
      'content':'미안해 내가..'
    },
    {
      'name':'haewon',
      'content':'이것도 추가해?'
    },
    {
      'name':'wonseok',
      'content':'zzz..'
    }
  ];

  List<Widget> commentContent(){
    List<Widget> a=[];
    for(int i=0;i<comment.length;i++){
      var name=comment[i]['name'];
      var content=comment[i]['content'];
      a.add(Container(
        margin: EdgeInsets.only(bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(25, 0, 5, 0),
              child: Icon(Icons.account_circle,size: 35,)
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name),
                Container(
                  margin: EdgeInsets.only(left: 3),
                  child: Text(content),
                )
              ],
            )
          ],
        ),
      ));
    }
    return a;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
        IconButton(
          icon:Icon(Icons.navigate_before,color: Colors.white,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Colors.grey,
        //Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("공지", style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(15),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notice2[0]['title']),
                Text(notice2[0]['writer']+' '+notice2[0]['startday'],style: TextStyle(fontSize: 12),),
              ],
            ),
          ),
          Container(
            height: 180,
            width: 340,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
          ),
          Container(
            margin: EdgeInsets.all(15),
            alignment: Alignment.centerLeft,
            child: Text("댓글")
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: commentContent(),
              ),
            ),
          ),
          Container(
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey),
            ),
            margin: EdgeInsets.all(5),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: _textEditingController,
              onChanged: (String? val){
                _textEditingController.text=val!;
              },
              decoration: InputDecoration(
                  hintText: '내용을 입력해주세요',
                  suffix:Container(
                    height:40,
                    width: 40,
                    margin: EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_upward,color: Colors.white),
                      onPressed: (){
                        if (_textEditingController.text.replaceAll('\n', '')!='') {
                          for(int i=0;i<_textEditingController.text.length;i++){
                            if(_textEditingController.text.replaceAll('\n', '')[i]!=' '){
                              DateTime dt=DateTime.now();
                              setState(() {
                                comment.add({
                                  'name':me,
                                  'content':_textEditingController.text
                                });
                                _textEditingController.clear();
                              });
                              break;
                            }
                          }
                        }
                      },
                    ),
                  )
              ),
            ),
          )
        ],
      ),
    );
  }
}