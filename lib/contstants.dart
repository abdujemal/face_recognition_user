import 'package:http/http.dart' as http;

const APP_ID = 'b5efbfa75d4643a6aaa9832825f72cb8';

getToken(String channelName) async {
  var data = await http.get(Uri.parse("https://morning-depths-23050.herokuapp.com/access_token?channelName=${channelName}"));
 
  return data.body.replaceAll("{", "").replaceAll("}", "").split(":")[1].replaceAll('"', "");
}