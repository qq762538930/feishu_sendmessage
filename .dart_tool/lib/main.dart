
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model/heros.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '王者荣耀英雄榜',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '王者荣耀英雄榜'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required String title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Heroes> heros = [];
  int? hero_num = 0;

  Future getHeros() async {
    var response =
        await http.get(Uri.https('pvp.qq.com', '/web201605/js/herolist.json'));
    // var jsonData = jsonDecode(response.body);
    var jsonData = json.decode(utf8.decode(response.bodyBytes));
    // print(jsonData[0]['cname']);
    //112
    hero_num=jsonData.length;


    for (var eachTeam in jsonData) {
      // print(eachTeam);
      final heroes = Heroes(
        ename: eachTeam['ename'],
        cname: eachTeam['cname'],
        title: eachTeam['title'],
      );
      // print('${heroes.title}-${heroes.cname}');
      // print(heroes.title);
      heros.add(heroes);
      // print(jsonData.length);//112
      // print(jsonData.length);
      // print(heros.length);

      // print(heros);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('王者荣耀英雄榜'),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: getHeros(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return GridView.builder(
                  itemCount: hero_num,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          // title: const Text('1'),
                          title: Image.network(
                              'https://game.gtimg.cn/images/yxzj/img201606/heroimg/${heros[index].ename}/${heros[index].ename}.jpg'),
                          subtitle: Text(heros[index].cname),
                        ),
                      ),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 100,
                      childAspectRatio: 1 / 1,
                      crossAxisSpacing: 40,
                      mainAxisSpacing: 10),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
