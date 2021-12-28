import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversation.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchController = TextEditingController();
  QuerySnapshot<Map<String, dynamic>>? searchSnapshot;

  initiateSearch() {
    databaseMethods.getUserByUsername(searchController.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  void createChatRoomAndStartConversation(String userName) {
    if (userName != Constants.myName) {
      List<String?> users = [userName, Constants.myName];
      String chatRoomId = HelperFunctions.getChatRoomId(users);
      Map<String, dynamic> chatRoomMap = {
        'users': users,
        'chatroomid': chatRoomId
      };

      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(
                    chatRoomID: chatRoomId,
                  )));
    } else {
      print("you cannot send message to yourself");
    }
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return SearchTile(
                  userName: searchSnapshot!.docs[index].data()["name"],
                  userEmail: searchSnapshot!.docs[index].data()["email"],
                  messageCallback: createChatRoomAndStartConversation);
            },
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search username...",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0x34FFFFFF), Color(0x0FFFFFFF)],
                          ),
                          borderRadius: BorderRadius.circular(40)),
                      child: Image.asset('assets/images/search_white.png'),
                    ),
                  ),
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

class SearchTile extends StatelessWidget {
  final String userName;
  final String userEmail;
  final Function messageCallback;

  const SearchTile(
      {Key? key,
      required this.userName,
      required this.userEmail,
      required this.messageCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: mediumTextStyle()),
              Text(userEmail, style: mediumTextStyle())
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              messageCallback(userName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.all(16),
              child: Text("Message", style: mediumTextStyle()),
            ),
          )
        ],
      ),
    );
  }
}
