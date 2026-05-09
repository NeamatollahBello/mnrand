import 'package:dio/dio.dart';
import 'api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'apptype.dart';

SharedPreferences? prefs;

late String lastServer;
late String lastUser;
late String lastComp;
late String lastPass;

loadSettings() async {
  prefs ??= await SharedPreferences.getInstance();
  apiToken = prefs!.getString('apiToken') ?? '';
  lastServer = prefs!.getString('lastServer') ?? '';
  lastUser = prefs!.getString('lastUser') ?? '';
  lastComp = prefs!.getString('lastComp') ?? 'main';
  lastPass = prefs!.getString('lastPass') ?? '';
  lastServer = prefs!.getString('lastServer') ?? '';
  if (lastServer.isNotEmpty) {
    apiUrl = 'http://$lastServer:${isMazeed ? 8031 : 8030}/';
  }
  apiHttpOptions = Options(headers: {
    'Accept': '*/*',
    'Content-Type': 'application/json',
    'authorization': 'Bearer $apiToken'
  });
}

setLastServer(String s, bool save) async {
  prefs ??= await SharedPreferences.getInstance();
  await prefs!.setString('lastServer', save ? s : '');

  lastServer = s;
  apiUrl = 'http://$lastServer:${isMazeed ? 8031 : 8030}/';
}

setLastUserPass(String c, String u, String p, bool save) async {
  prefs ??= await SharedPreferences.getInstance();
  await prefs!.setString('lastComp', save ? c : 'main');
  await prefs!.setString('lastUser', save ? u : '');
  await prefs!.setString('lastPass', save ? p : '');

  lastComp = c;
  lastUser = u;
  lastPass = p;
}

setApiToken(String token, bool save) async {
  prefs ??= await SharedPreferences.getInstance();
  await prefs!.setString('apiToken', save ? token : '');
  apiToken = token;
  apiHttpOptions = Options(headers: {
    'Accept': '*/*',
    'Content-Type': 'application/json',
    'authorization': 'Bearer $apiToken'
  });
}
