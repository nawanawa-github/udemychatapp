import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:udemychatapp/model/talk_room.dart';
import 'package:udemychatapp/model/user.dart';
import 'package:udemychatapp/utils/shared_prefs.dart';

class Firestore {
  static FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  static final userRef = _firestoreInstance.collection('user');
  static final roomRef = _firestoreInstance.collection('room');
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

  // 既存ルーム情報取得
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
    print('room情報取得完了');
    return roomList;
  }
}

