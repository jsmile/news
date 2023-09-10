import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  const LoadingContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: greyContainer(),
          subtitle: greyContainer(),
        ),
        const Divider(
          height: 8.0,
        ),
      ],
    );
  }

  Widget greyContainer() {
    return Container(
      color: Colors.grey[200],
      height: 24.0,
      width: 150.0,
      margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
    );
  }
}
