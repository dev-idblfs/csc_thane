import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
  String actionURL;
  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
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
              child: Stack(
                children: <Widget>[
                  WebView(
                    initialUrl: actionURL,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                    },
                    // TODO(iskakaushik): Remove this when collection literals makes it to stable.
                    // ignore: prefer_collection_literals
                    javascriptChannels: <JavascriptChannel>[
                      _toasterJavascriptChannel(context),
                    ].toSet(),
                    onPageStarted: (String url) {
                      print('Page started loading: $url');
                    },
                    onPageFinished: (String url) {
                      print('Page finished loading: $url');
                    },
                    gestureNavigationEnabled: true,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Developed by developer idblfs")
                        ],
                      )
                    ],
                  )
                ],
              )),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                _controller.future.then((value) => value.loadUrl(actionURL));
              });
            },
            autofocus: true,
            child: Icon(Icons.home),
            backgroundColor: Colors.blueAccent,
            splashColor: Colors.deepOrange,
          ),
        ));
  }

  Future<bool> _exitApp(BuildContext context) async {
    var webViewController = await _controller.future;
    if (webViewController.canGoBack() != null) {
      webViewController.currentUrl().then((value) =>
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
                  onPressed: () => SystemNavigator.pop(),
                  child: Text("Yes")),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('No'))
            ],
          ),
        ) ??
        false;
  }
}

void main() {
  runApp(MyApp());
}
