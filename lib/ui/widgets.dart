import 'package:flutter/material.dart';

class MyColors {
  static final Color amber = Colors.amber.shade900;
}

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

AppBar fireAppBar(BuildContext context, String title) {
  return AppBar(
    leading: IconButton(
      icon: Icon(Icons.arrow_back_rounded),
      onPressed: () => Navigator.of(context).pop(),
      color: MyColors.amber,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    ),
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(
        fontFamily: 'monospace',
        fontWeight: FontWeight.bold,
        color: MyColors.amber,
      ),
    ),
    backgroundColor: Colors.black,
  );
}
