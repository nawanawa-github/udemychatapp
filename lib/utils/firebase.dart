import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:udemychatapp/utils/shared_prefs.dart';
import 'package:udemychatapp/model/talk_room.dart';
import 'package:udemychatapp/model/user.dart';
import 'package:udemychatapp/model/message.dart';

class Firestore {
  static FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  static final userRef = _firestoreInstance.collection('user');
  static final roomRef = _firestoreInstance.collection('room');
  //ルームコレクション更新によるsnapshot
  static final roomSnapshot = roomRef.snapshots();

  // 新規アカウント作成,新規ルーム作成
  static Future<void> addUser() async{
    try {
      final newDoc = await userRef.add({
      'name': '名無し',
      'image_path': 'https://pbs.twimg.com/media/E-bTP7DVcAMLKh0.jpg'
    });
    await SharedPrefs.setUid(newDoc.id);
    print('アカウント作成完了');
    List<String> userIds = await getUser();
    userIds.forEach((user) async{
      if(user != newDoc.id) {
        await roomRef.add({
          'joined_user_ids': [user, newDoc.id],
          'updated_taime': Timestamp.now(),
        });
      }
    });
    print('ルーム作成完了');
    } catch(e) {
      print('アカウント作成に失敗しました --- $e');
    }
  }

  // 全ユーザ情報取得(サブ)
  static Future<List<String>> getUser() async {
    try {
      final snapshot = await userRef.get();
      List<String> userIds = [];
      snapshot.docs.forEach((user) {
        userIds.add(user.id);
      });
      return userIds;
    } catch(e) {
      print('取得失敗 --- &e');
      return [];
    }
  }

  // 相手ユーザ情報取得(サブ)
  static Future<User> getProfile(String uid) async{
    final profile = await userRef.doc(uid).get();
    User myProfile = User(
      name:  profile.data()?['name'],
      uid: uid,
      imagePath: profile.data()?['image_path'],
    );
    return myProfile;
  }

  // ルーム一覧情報取得
  static Future<List<TalkRoom>> getRooms(String myUid) async {
    final snapshot = await roomRef.get();
    List<TalkRoom> roomList = [];
    await Future.forEach(snapshot.docs, (QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
      if(doc.data()['joined_user_ids'].contains(myUid)) {
        String yourUid ='';
        doc.data()['joined_user_ids'].forEach((id) {
          if(id != myUid) {
            yourUid = id;
            return;
          }
        });
        User yourProfile = await getProfile(yourUid);
        TalkRoom room = TalkRoom(
          roomId:  doc.id,
          talkUser: yourProfile,
          lastMessage: doc.data()['last_message'] ?? '',
        );
        roomList.add(room);
      }
    });
    print('ルーム一覧情報取得完了');
    return roomList;
  }

  //トークメッセージ情報取得
  static Future<List<Message>> getMessages(String roomId) async{
    final messageRef = roomRef.doc(roomId).collection('message');
    List<Message> messageList = [];
    final snapshot = await messageRef.get();
    await Future.forEach(snapshot.docs, (QueryDocumentSnapshot<dynamic> doc) {
      bool isMe;
      String myUid = SharedPrefs.getUid();
      if(doc.data()['sender_id'] == myUid) {
        isMe = true;
      } else {
        isMe = false;
      }
      Message message = Message(
        message: doc.data()['message']  ?? '',
        isMe: isMe,
        sendTime: doc.data()['send_time'] ?? Timestamp.now(),
      );
      messageList.add(message);
    });
    messageList.sort((a,b) => b.sendTime.compareTo(a.sendTime));
    print('トークルームメッセージ取得完了');
    return messageList;
  }

  //メッセージをデータベース追加処理
  static Future<void> sendMessage(String roomId, String message) async{
    final messageRef = roomRef.doc(roomId).collection('message');
    String myUid = SharedPrefs.getUid();
    await messageRef.add({
      'message': message,
      'sender_id': myUid,
      'send_time': Timestamp.now(),
    });

    roomRef.doc(roomId).update({
      'last_message': message,
    });
  }

  //メッセージコレクション更新によるsnapshot
  static Stream<QuerySnapshot> messageSnapshot(String roomId) {
    return roomRef.doc(roomId).collection('message').snapshots();
  }
}