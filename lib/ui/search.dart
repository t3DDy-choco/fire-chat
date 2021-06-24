import 'package:cloud_firestore/cloud_firestore.dart';
import '/net/auth_service.dart';
import '/net/database.dart';
import 'chat.dart';
import 'package:flutter/material.dart';
import 'widgets.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  QuerySnapshot? searchSnapshot;

  TextEditingController searchTextController = TextEditingController();

  initiateSearch() {
    dbService.getUserByDisplayName(searchTextController.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  Widget searchList() {
    return (searchSnapshot != null)
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return SearchTile(
                displayName: (searchSnapshot!.docs[index].data()
                    as dynamic)!['displayName'],
                email:
                    (searchSnapshot!.docs[index].data() as dynamic)!['email'],
                startNewChat: startNewChat,
              );
            })
        : Container();
  }

  String getChatID(String a, String b) {
    if (a.compareTo(b) == -1) {
      return '$a\_$b';
    } else {
      return '$b\_$a';
    }
  }

  startNewChat(String email, BuildContext context) {
    String? myEmail = authService.getCurrentEmail();
    List<String?> chatBetween = [email, myEmail];
    String chatID = getChatID(email, myEmail!);
    dbService.createChat(chatID, chatBetween);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Chat()),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: fireAppBar(context, "f i r e c h a t"),
      body: Container(
        child: Column(
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
                      controller: searchTextController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: 'search username...',
                          hintStyle: TextStyle(
                            color: Colors.amber.shade200,
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                  GestureDetector(
                    onTap: initiateSearch(),
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

class SearchTile extends StatelessWidget {
  final String displayName;
  final String email;
  final startNewChat;

  const SearchTile({
    Key? key,
    required this.displayName,
    required this.email,
    required this.startNewChat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, right: 10, left: 10),
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.black,
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
                      color: Colors.amber.shade900,
                      fontSize: 18.0),
                ),
                Text(
                  email,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          FirePadding(size: 35),
          GestureDetector(
            onTap: () {
              startNewChat(email, context);
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.amber.shade900,
                image: DecorationImage(
                  image: AssetImage('assets/fire_round_square.gif'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
