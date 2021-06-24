import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_chat/net/database.dart';
import 'package:fire_chat/ui/widgets.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final Color _amber = Colors.amber.shade900;
  QuerySnapshot? searchSnapshot;

  TextEditingController searchTextController = TextEditingController();

  initiateSearch() {
    dbService.getUserByDisplayName(searchTextController.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  startNewChat(String userName) {}

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
              );
            })
        : Container();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
          color: _amber,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        centerTitle: true,
        title: Text(
          'f i r e c h a t',
          style: TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
            color: _amber,
          ),
        ),
        backgroundColor: Colors.black,
      ),
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
                color: _amber,
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

  const SearchTile({
    Key? key,
    required this.displayName,
    required this.email,
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
            onTap: () {},
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
