import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebView',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'My WebView'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WebViewController _controller;
  late WebViewController _controller1;
  late WebViewController _controller2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            print("Page Started loading: $url");
          },
          onPageFinished: (url) {
            print("Page Finished loading: $url");
          },
          onNavigationRequest: (request) {
            if (request.url.startsWith("https://flutter.dev/")) {
              return NavigationDecision.navigate;
            }
            print("Blocked navigation to: ${request.url}");
            return NavigationDecision.prevent;
          },
        ),
      );
    _controller.loadRequest(Uri.parse("https://flutter.dev/"));
    _controller1 = WebViewController()..loadFlutterAsset('assets/index.html');
    _controller2 = WebViewController()..loadHtmlString('''<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>WebView</title></head><body><h1>WebView meow meow</h1></body></html>''',);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("WebView Navigation & Events"),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              if (await _controller.canGoBack()) {
                _controller.goBack();
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () async {
              if (await _controller.canGoForward()) {
                _controller.goForward();
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: WebViewWidget(controller: _controller1)),
          const Divider(thickness: 2, height: 1),
          Expanded(child: WebViewWidget(controller: _controller2)),
        ],
      ),
    );
  }
}
