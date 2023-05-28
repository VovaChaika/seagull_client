import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final Color color;

  const Loader({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: CircularProgressIndicator( // prebuilt animation
        color: color,
        strokeWidth: 10,
      ),
    );
  }
}
