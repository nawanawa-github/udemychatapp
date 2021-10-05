import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:udemychatapp/model/user.dart';
import 'package:udemychatapp/utils/shared_prefs.dart';

class Firestore {
  static FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  static final userRef = _firestoreInstance.collection('user');
  static final roomRef = _firestoreInstance.collection('room');

  static Future<void> addUser() async{
    try {
      final newDoc = await userRef.add({
      'name': '名無し',
      'image_path': 'https://pbs.twimg.com/media/E-bTP7DVcAMLKh0.jpg'
    });
    print('アカウント作成完了');
    await SharedPrefs.setUid(newDoc.id);

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

  static Future<List<String>> getUser() async {
    try {
      final snapshot = await userRef.get();
      List<String> userIds = [];
      snapshot.docs.forEach((user) {
        userIds.add(user.id);
        print('ドキュメント: ${user.id} --- 名前: ${user.data()['name']}' );
      });
      return userIds;
    } catch(e) {
      print('取得失敗 --- &e');
      return [];
    }
  }

  static Future<User> getProfile(String uid) async{
    final profile = await userRef.doc(uid).get();
    User myProfile = User(
      name:  profile.data()?['name'],
      uid: uid,
      imagePath: profile.data()?['image_path'],
      lastMessage: ''
    );
    return myProfile;
  }
}

