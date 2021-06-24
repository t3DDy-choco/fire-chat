import 'package:fire_chat/ui/widgets.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: fireAppBar(context, "f i r e c h a t"),
      body: Container(
        alignment: Alignment.bottomCenter,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: MyColors.amber,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      // controller: searchTextController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: 'type message...',
                          hintStyle: TextStyle(
                            color: Colors.amber.shade200,
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                  GestureDetector(
                    // onTap: initiateSearch(),
                    child: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Icon(
                        Icons.message,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
