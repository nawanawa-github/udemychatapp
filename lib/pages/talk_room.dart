import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:udemychatapp/model/message.dart';

class TalkRoomPage extends StatefulWidget {
  final String name;
  TalkRoomPage(this.name);
  @override
  _TalkRoomPageState createState() => _TalkRoomPageState();
}

class _TalkRoomPageState extends State<TalkRoomPage> {
  List<Message> messageList = [
    Message(
      message: 'あいうあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおえお',
      isMe: true,
      sendTime: DateTime(2020, 1, 1, 10, 15),
    ),
    Message(
      message: 'あいうあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおえお',
      isMe: false,
      sendTime: DateTime(2020, 1, 1, 10, 15),
    ),
    Message(
      message: 'あいうあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおえお',
      isMe: true,
      sendTime: DateTime(2020, 1, 1, 10, 15),
    ),
    Message(
      message: 'あいうあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおえお',
      isMe: false,
      sendTime: DateTime(2020, 1, 1, 10, 15),
    ),
    Message(
      message: 'あいうあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおえお',
      isMe: false,
      sendTime: DateTime(2020, 1, 1, 10, 15),
    ),
    Message(
      message: 'あいうあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおあいうえおえお',
      isMe: false,
      sendTime: DateTime(2020, 1, 1, 10, 15),
    ),
    Message(
      message: 'かきくけこ',
      isMe: false,
      sendTime: DateTime(2020, 1, 1, 10, 16),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: ListView.builder(
              physics: RangeMaintainingScrollPhysics(),
              shrinkWrap: true,
              reverse: true,
              itemCount: messageList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: index == 0 ? 10 : 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    textDirection: messageList[index].isMe ?  TextDirection.rtl : TextDirection.ltr,
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.6),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: messageList[index].isMe ? Colors.green : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(messageList[index].message),
                        ),
                      Text(intl.DateFormat('HH:mm').format(messageList[index].sendTime), style: TextStyle(fontSize: 10),),
                    ],
                  ),
                );
              }
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      print('送信');
                    },
                    icon: Icon(Icons.send),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}