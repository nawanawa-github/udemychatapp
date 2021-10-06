import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:udemychatapp/pages/settings_profile.dart';
import 'package:udemychatapp/pages/talk_room.dart';
import 'package:udemychatapp/utils/firebase.dart';
import 'package:udemychatapp/utils/shared_prefs.dart';
import 'package:udemychatapp/model/talk_room.dart';

class TopPage extends StatefulWidget {
  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  List<TalkRoom> talkUserList = [];

  Future<void> createRoom() async{
    String myUid = SharedPrefs.getUid();
    talkUserList = await Firestore.getRooms(myUid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('チャットアプリ'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsProfilePage()));
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.roomSnapshot,
        builder: (context, snapshot) {
          return FutureBuilder(
            future: createRoom(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  itemCount: talkUserList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        print(talkUserList[index].roomId);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TalkRoomPage(talkUserList[index])));
                      },
                      child: Container(
                        height: 70,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(talkUserList[index].talkUser.imagePath),
                                radius: 30,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(talkUserList[index].talkUser.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                Text(talkUserList[index].lastMessage, style: TextStyle(color: Colors.grey),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }
          );
        }
      ),
    );
  }
}