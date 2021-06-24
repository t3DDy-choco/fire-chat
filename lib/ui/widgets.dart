import 'package:flutter/material.dart';

class FirePadding extends StatelessWidget {
  final double size;

  const FirePadding({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / size,
      width: MediaQuery.of(context).size.height / size,
    );
  }
}
