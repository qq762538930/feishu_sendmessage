import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '发送飞书webhook 信息',
      home: MyCustomForm(),
    );
  }
}

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  TextEditingController myController = TextEditingController();
  TextEditingController MyKey = TextEditingController();
  String? tianchongci = "";

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    MyKey.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('发送飞书webhook 信息'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 此处确定secret
            TextField(
              controller: MyKey,
              autofocus: true,
              decoration: InputDecoration(
                labelText: '输入你的secret key',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      MyKey.clear();
                    });
                    // print(MyKey.text);
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            // 此处确定需要发送的数据
            Form(
              child: TextField(
                controller: myController,
                decoration: InputDecoration(
                    labelText: '发送飞书webhook 信息',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          myController.clear();
                        });
                      },
                    )),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            const Center(
              child: Text(
                  '您的secret key看起来像“a2eff83d-3089-4900-b929-5f10f2fd6ff1”这样'),
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
                child: Text(
              tianchongci!,
              style: const TextStyle(),
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          // showDialog(
          //   context: context,
          //   builder: (context) {
          //     return AlertDialog(
          //       // Retrieve the text the that user has entered by using the
          //       // TextEditingController.
          //       content: Text(myController.text),
          //     );
          //   },
          // );
          if (MyKey.text.isEmpty) {
            setState(() {
              tianchongci = '缺少secret key发送失败';
            });
            // print(tianchongci);
            // print('secret key为空发送失败');
          } else {
            if (myController.text.isEmpty) {
              // tianchongci='你都还没告诉我，你想要发送什么呢？';
              setState(() {
                tianchongci = '你都还没告诉我想要发送什么内容呢？';
              });
              // a2eff83d-3089-4900-b929-5f10f2fd6ff1
              // print(tianchongci);
              // print('你都还没告诉我，你想要发送什么呢？');
            } else {
              sendMessage();
              // print(myController.text);
            }
          }
        },
        tooltip: '发送',
        child: const Icon(Icons.send),
      ),
    );
  }

  Future<void> sendMessage() async {
    String data = myController.text;
    String KeyData = MyKey.text;

    var headers = {
      'User-Agent':
          'Mozilla/5.0 (compatible; MSIE 9.0; Windows Phone OS 7.5; Trident/5.0; IEMobile/9.0; HTC; Titan)'
    };
    // if (kDebugMode) {
    //   print(KeyData);
    // }
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://open.feishu.cn/open-apis/bot/v2/hook/$KeyData?msg_type=text&content={"text":"$data"}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    // if (response.statusCode == 200) {
    //   print(response.contentLength);
    //   setState(() {
    //     tianchongci = '发送成功了！';
    //   });
    //   print(await response.stream.bytesToString());
    // } else {
    //   setState(() {
    //     tianchongci = '不好意思，没发出去哎，要不再试一次吧？';
    //   });

    if (response.contentLength! <= 80) {
      setState(() {
        tianchongci = '发送成功了！';
      });
      print(await response.stream.bytesToString());
    } else {
      setState(() {
        tianchongci = '不好意思，没发出去哎，请检查以下secret key吧';
      });
      // print(response.reasonPhrase);
    }
    // print(myController.text);
  }
}
