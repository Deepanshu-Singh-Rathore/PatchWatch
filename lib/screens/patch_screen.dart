import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PatchNotesScreen extends StatefulWidget {
  const PatchNotesScreen({super.key});

  @override
  State<PatchNotesScreen> createState() => _PatchNotesScreenState();
}

class _PatchNotesScreenState extends State<PatchNotesScreen> {
  bool isLoading = true;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (_) {
                setState(() {
                  isLoading = false;
                });
              },
              onWebResourceError: (error) {
                setState(() {
                  isLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to load patch notes.')),
                );
              },
            ),
          )
          ..loadRequest(
            Uri.parse(
              "https://www.leagueoflegends.com/en-gb/news/tags/patch-notes/",
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Patch Notes")),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
