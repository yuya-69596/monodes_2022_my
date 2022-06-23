// ignore_for_file: avoid_print, duplicate_import

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  final message = "Initial Message.";

  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Sample',
      home: MyPage(message: message),
    );
  }
}

class MyPageState extends State<MyPage> {
  // テキストフィールドのステートを管理
  final _stateController = TextEditingController();

  get kDebugMode => null;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _stateController.dispose();
    super.dispose();
  }

  /// LoadボタンがおされたらFirestoreの値を取得
  void loadOnPressed() {
    Firestore.instance
        .collection("sample")
        .doc("sandwichData")
        .get()
        .then((DocumentSnapshot ds) {
      setState(() {
        _stateController.text = ds["hotDogStatus"];
      });
      if (kDebugMode) {
        print("status=$this.status");
      }
    });
  }

  /// SaveボタンがおされたらFirestoreに値を保存
  void saveOnPressed() {
    Firestore.instance
        .collection("sample")
        .doc("sandwichData")
        .updateData({"hotDogStatus": _stateController.text})
        .then((value) => print("success"))
        .catchError((value) => print("error $value"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter State Sample'),
      ),
      body: Column(
        // Columnの配置場所
        mainAxisAlignment: MainAxisAlignment.start,
        // Widgetのサイズ
        mainAxisSize: MainAxisSize.max,
        //　Columnに組み込んだWidgetの配置場所
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _stateController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: ElevatedButton(
                    onPressed: saveOnPressed, child: const Text("Save")),
              ),
              Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ElevatedButton(
                      onPressed: loadOnPressed, child: const Text("Load")))
            ],
          ),
        ],
      ),
    );
  }
}

class Firestore {
  // ignore: prefer_typing_uninitialized_variables
  static var instance;
}

class MyPage extends StatefulWidget {
  final String message;
  // ignore: use_key_in_widget_constructors
  const MyPage({required this.message}) : super();
  @override
  State<StatefulWidget> createState() => MyPageState();
}
