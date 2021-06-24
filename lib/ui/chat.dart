import 'package:fire_chat/net/auth_service.dart';
import 'package:fire_chat/net/db_service.dart';
import 'package:fire_chat/ui/widgets.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String chatID;
  Chat({
    Key? key,
    required this.chatID,
  }) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController messageController = TextEditingController();
  late Stream chatStream;

  Widget convoList() {
    return StreamBuilder(
        stream: chatStream,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          return (snapshot.data == null)
              ? Center(
                  child: CircularProgressIndicator(
                    color: MyColors.amber,
                  ),
                )
              : ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    String message =
                        snapshot.data.docs[index].data()['message'];
                    bool from = snapshot.data.docs[index].data()['fromEmail'] ==
                        authService.getCurrentEmail();
                    return MessageTile(
                      message: message,
                      fromMe: from,
                    );
                  },
                );
        });
  }

  @override
  void initState() {
    super.initState();
    dbService.getConvo(widget.chatID).then((value) {
      setState(() {
        chatStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: fireAppBar(context, "f i r e c h a t"),
      body: Container(
        child: Stack(
          children: [
            convoList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
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
                        controller: messageController,
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
                      onTap: () {
                        if (messageController.text.trim().isNotEmpty) {
                          dbService.sendMessage(
                              widget.chatID, messageController.text.trim());
                          messageController.text = '';
                        }
                      },
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
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool fromMe;
  const MessageTile({
    Key? key,
    required this.message,
    required this.fromMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: fromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(top: 8, right: 8, left: 8),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: fromMe ? MyColors.amber : Colors.black54,
          borderRadius: fromMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
