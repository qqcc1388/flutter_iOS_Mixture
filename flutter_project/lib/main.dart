import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp(route: window.defaultRouteName));

class MyApp extends StatefulWidget {
  String route;
  MyApp({@required this.route});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    //收到iOS中传入指令
    print(widget.route);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

//创建消息通道并初始化消息名 这个名字要与iOS对应
 static const MethodChannel methodChannel = MethodChannel('MSGChannel');


  @override
  void initState() {
    super.initState();

    //设置消息监听
    methodChannel.setMethodCallHandler((MethodCall call){
      //接收到消息
      print(call.method);
      print(call.arguments);
      return Future.value(true);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('iOS与Flutter通讯'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            //发送消息通过invokeMethod方法
             methodChannel.invokeMethod('dismiss');
          },
          child: Container(
            alignment: Alignment.center,
            color: Colors.red,
            width: 100,
            height: 40,
            child: Text(
              '点击返回iOS',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
