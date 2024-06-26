import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget{
final  String url ;

  const WebPage({super.key, required this.url});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WebPageState();
  }

}

class WebPageState extends State<WebPage> {

 late WebViewController webViewController ;

 @override
  void didUpdateWidget(covariant WebPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setState(() {
      webViewController  = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onHttpError: (HttpResponseError error) {},
            onWebResourceError: (WebResourceError error) {},

          ),
        )
        ..addJavaScriptChannel("getSongInfo", onMessageReceived: (JavaScriptMessage message) {
          // 接收来自 WebView 的消息
          String messageData = message.message;
          // 在这里处理从 WebView 返回的数据
          print('Received message from WebView: $messageData');
        },)
        ..loadRequest(Uri.parse(widget.url));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    webViewController  = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},

        ),
      )
      ..runJavaScript('window.flutterWebViewPlugin.callFlutter("data from web");',)
      ..addJavaScriptChannel("KEYCODE_BACK", onMessageReceived: (JavaScriptMessage message) {
        // 接收来自 WebView 的消息
        String messageData = message.message;
        // 在这里处理从 WebView 返回的数据
        print('Received message from WebView: $messageData');
      },)

      ..loadRequest(Uri.parse(widget.url));


  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body:

      WebViewWidget(
        controller: webViewController,),
    );
  }
}