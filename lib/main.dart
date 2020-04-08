import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final title = 'CSC Thane';
    return MaterialApp(
      title: title,
      theme: ThemeData.light(),
      home: CustomWebView(title: title),
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.light(),
    );
  }
}

class CustomWebView extends StatefulWidget {
  CustomWebView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CustomWebView createState() => _CustomWebView();
}

class _CustomWebView extends State<CustomWebView> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  final url = 'https://sites.google.com/view/digitaldesh-co-in/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        padding: EdgeInsets.only(top: 21.0),
        child: WebView(
          initialUrl: url,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
