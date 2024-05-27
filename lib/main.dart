import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KylianERP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WebBrowser(),
    );
  }
}

class WebBrowser extends StatefulWidget {
  @override
  _WebBrowserState createState() => _WebBrowserState();
}

class _WebBrowserState extends State<WebBrowser> {
  InAppWebViewController? webViewController;
  double progress = 0;

  Future<bool> _onWillPop() async {
    if (webViewController != null) {
      bool canGoBack = await webViewController!.canGoBack();
      if (canGoBack) {
        webViewController!.goBack();
        return Future.value(false);
      }
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: RefreshIndicator(
        onRefresh: () async {
          webViewController?.reload();
        },
        child: SafeArea(
          child: Scaffold(
           /* appBar: AppBar(
              title: const Text('Kylian ERP Browser'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    webViewController?.reload();
                  },
                ),
              ],
            ),*/
            body: Column(
              children: [
                progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : const SizedBox.shrink(),
                Expanded(
                  child: InAppWebView(
                    initialUrlRequest: URLRequest(
                        url: WebUri("https://kylianerp.com/login")),
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    onLoadStart: (controller, url) {
                      setState(() {
                        progress = 0;
                      });
                    },
                    onLoadStop: (controller, url) {
                      setState(() {
                        progress = 1.0;
                      });
                    },
                    onProgressChanged: (controller, progress) {
                      setState(() {
                        this.progress = progress / 100;
                      });
                    },
                    shouldOverrideUrlLoading: (controller, navigationAction) async {
                      final uri = navigationAction.request.url!;
                      if (uri.host == 'www.kylianerp.com' || uri.host == 'kylianerp.com') {
                        return NavigationActionPolicy.ALLOW;
                      } else {
                        return NavigationActionPolicy.CANCEL;
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
