import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _launchInWebViewWithDomStorage(String url) async {
    if (await canLaunch(url)) {
      launch(url,
          forceSafariVC: true,
          forceWebView: true,
          enableDomStorage: true,
          enableJavaScript: true).then((value) => Platform.isIOS ? exit(0) : SystemNavigator.pop(animated: true));
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return const Text('open');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: Column(
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(16.0)),
            FutureBuilder<void>(
                future: _launchInWebViewWithDomStorage(url),
                builder: _launchStatus),
          ],
        ));
  }
}

void main() {
  runApp(MyApp());
}
