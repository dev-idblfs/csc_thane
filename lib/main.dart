import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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
      darkTheme: ThemeData.dark()
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
  InAppWebViewController _webViewController;

  final url = 'https://sites.google.com/view/digitaldesh-co-in/home';
  String actionURL;

  @override
  void initState() {
    super.initState();
    actionURL = url;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _exitApp(context),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            padding: EdgeInsets.only(top: 24.0),
            child: InAppWebView(
              initialUrl: actionURL,
              initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                debuggingEnabled: true,
                cacheEnabled: true,
                javaScriptEnabled: true,
              )),
              onWebViewCreated: (InAppWebViewController _controller) {
                _webViewController = _controller;
              },
            ),
          ),
          floatingActionButton: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 35.0),
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _webViewController.loadUrl(url: actionURL);
                    });
                  },
                  autofocus: true,
                  child: Icon(Icons.home),
                  backgroundColor: Colors.blueAccent,
                  splashColor: Colors.deepOrange,
                ),
              )
            ],
          ),
        ));
  }

  Future<bool> _exitApp(BuildContext context) async {
    var webViewController = _webViewController;
    if (webViewController.canGoBack() != null) {
      webViewController.getUrl().then((value) =>
          _matchURL(value) ? _showDialogue() : webViewController.goBack());
    }
    return false;
  }

  bool _matchURL(value) {
    if ((url == value)) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _showDialogue() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Platform.isAndroid
                        ? SystemNavigator.pop(animated: true)
                        : Navigator.of(context).pop(true);
                  },
                  child: Text("Yes")),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No'))
            ],
          ),
        ) ??
        false;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
