import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class HtmlLinkText extends StatelessWidget {
  final String linkedText;

  const HtmlLinkText({Key? key, required this.linkedText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Html(
        data: """
                  linkedText
                  """,
        onLinkTap: (url, _, __, ___) {
          Uri uri = Uri.parse(url!);
          launchUrl(uri);
        },
        style: {
          "a": Style(
            color: Colors.blue,
            textDecoration: TextDecoration.underline,
          )
        },
      ),
    );
  }
}
