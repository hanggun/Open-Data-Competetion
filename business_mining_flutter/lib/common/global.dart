import 'package:business_mining/net/api_service.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

Logger logger = Logger(
  printer: PrefixPrinter(PrettyPrinter(colors: true)),
);

///保存在本地的数据
class Global {
  static const keySession = "session";
  static const keyAvatar = "avatar";

  static SharedPreferences _sp;

  static String _session;
  static String id;
  static String avatarPath;

  static String get session => _session;

  static set session(String string) {
    _session = string;
    https.resetHeaders();
    saveProfile();
  }

  /// 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  static Future<void> init() async {
    _sp = await SharedPreferences.getInstance();
    _session = _sp.get(keySession);
    avatarPath = _sp.get(keyAvatar);
    id = _sp.get('id');
  }

  static saveProfile() {
    _sp.setString(keySession, _session);
    _sp.setString(keyAvatar, avatarPath);
    _sp.setString('id', id);
  }

  static List getHistory() {
    var str = _sp.getStringList('history');
    if (str == null) {
      return List<String>();
    }
    return str;
  }

  static void setHistory(List<String> history) {
    _sp.setStringList('history', history);
  }
}
