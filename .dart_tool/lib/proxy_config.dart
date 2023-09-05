import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_proxy/shelf_proxy.dart';

Future<void> main() async {
  var reqHandle = proxyHandler("https://pvp.qq.com/web201605/js/herolist.json");
  var server = await shelf_io.serve(reqHandle, 'localhost', 556);

  server.defaultResponseHeaders.add('Access-Control-Allow-Origin', '*');
  server.defaultResponseHeaders.add('Access-Control-Allow-Credentials', true);
}
