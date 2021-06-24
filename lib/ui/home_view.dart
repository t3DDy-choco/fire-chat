import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_chat/net/auth_service.dart';
import 'package:fire_chat/net/db_service.dart';
import 'package:fire_chat/ui/chat.dart';
import 'package:fire_chat/ui/search.dart';
import 'package:fire_chat/ui/widgets.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Stream chatListStream;

  Widget chatList() {
    return StreamBuilder(
        stream: chatListStream,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          return (snapshot.data == null)
              ? Center(
                  child: CircularProgressIndicator(
                    color: MyColors.amber,
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    String email = snapshot.data.docs[index]
                        .data()['chatID']
                        .toString()
                        .replaceAll('_', '')
                        .replaceAll(
                          authService.getCurrentEmail().toString(),
                          '',
                        );
                    String name = snapshot.data.docs[index]
                        .data()['users'][(authService.getCurrentEmail() ==
                                snapshot.data.docs[index]
                                    .data()['users'][0]
                                    .toString())
                            ? 2
                            : 3]
                        .toString();
                    return ChatTile(name,
                        snapshot.data.docs[index].data()['chatID'].toString());
                  });
        });
  }

  @override
  void initState() {
    super.initState();
    dbService.getChats(authService.getCurrentEmail()).then((value) {
      setState(() {
        chatListStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'f i r e c h a t',
          style: TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
            color: MyColors.amber,
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          GestureDetector(
            onTap: () {
              authService.signOut();
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(
                Icons.exit_to_app_rounded,
                color: MyColors.amber,
              ),
            ),
          ),
        ],
      ),
      body: chatList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.amber,
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(),
            ),
          );
        },
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  final String displayName;
  final String chatID;

  const ChatTile(this.displayName, this.chatID, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8, right: 8, left: 8),
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.black87,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      color: MyColors.amber,
                      fontSize: 18.0),
                ),
              ],
            ),
          ),
          FirePadding(size: 35),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Chat(chatID: chatID)));
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.amber.shade900,
              ),
              child: Icon(
                Icons.navigate_next_rounded,
                size: 36,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
