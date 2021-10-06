
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? prefsInstance;

  // インスタンス作成
  static Future<void> setInstance() async{
    if(prefsInstance == null) {
      prefsInstance = await SharedPreferences.getInstance();
      print('インスタンスを生成');
    }
  }

  // 端末にユーザid作成
  static Future<void> setUid(String newUid) async{
    await prefsInstance?.setString('uid', newUid);
    print('端末保存完了');
  }

  // 端末からユーザid取得
  static String getUid() {
    String uid = prefsInstance?.getString('uid') ?? '';
    print('端末情報取得完了');
    return uid;
  }
}