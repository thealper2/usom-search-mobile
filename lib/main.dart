import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(home: MyHomePage()));

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String scan_url = "";
  TextEditingController _controller = TextEditingController();

  var result;
  var response;
  var models;

  final scanMethods = ["domain", "url", "ip"];
  late String current_method = scanMethods[0];

  void USOM_SCAN(String urlScan) async {
    if(urlScan.length != 0) {
      response = await http.get(Uri.parse("https://www.usom.gov.tr/api/address/index?q=$urlScan&type=$current_method"));
      if (response.statusCode == 200) {
        result = jsonDecode(response.body);
        print(result);

        var models = (result['models'] as List)?.map((item) => item as String)?.toList();
        print(models);

      } else {
        print('Istek 1');
      }
    } else {
      print('Istek 2');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: new AppBar(
          title: Text("USOM Search Mobile"),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(
                'Koddaki USOM_SCAN fonksiyonu ile belirtilen url adresine tarama yapar.',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Enter URL',
                    hintText: 'URL Address'),
                controller: _controller,
                onChanged: (text) {
                  scan_url = text;
                },
              ),
            ),
            DropdownButtonFormField(
              value: scanMethods[0],
              items: scanMethods
                .map((e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
              ))
              .toList(),
              onChanged: (val) {
                setState(() {
                  current_method = val.toString();
                });
              },
              icon: const Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: "Scan Type",
                border: UnderlineInputBorder(),
              ),
            ),
            TextButton(
              onPressed: () async {
                USOM_SCAN(scan_url);
                _controller.clear();
                Timer(Duration(seconds: 3), () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SecondScreen(value1: models),),
                  );
                });
              },
              child: Text(
                'Scan',
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  final Map value1;

  const SecondScreen({
    Key? key,
    required this.value1,
}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RESULTS'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Text(
              value1['url'].toString(),
              style: TextStyle(fontSize: 32),
            ),
          ),
          TextButton(
            onPressed: () {
              print(value1);
            },
            child: Text('Goster'),
          )
        ],
      ),
    );
  }
}
