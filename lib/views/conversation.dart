import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomID;
  const ConversationScreen({Key? key, required this.chatRoomID})
      : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController messageController = TextEditingController();
  late Stream chatMessagesStream;

  Widget chatMessagesList() {
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, snapshot) {
        return ListView.builder(
            itemCount: (snapshot.data! as QuerySnapshot).docs.length,
            itemBuilder: (context, index) {
              return MessageTile(
                message: (snapshot.data! as QuerySnapshot)
                    .docs[index]["message"]
                    .toString(),
              );
            });
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, String?> messageMap = {
        "message": messageController.text,
        "sender": Constants.myName
      };
      databaseMethods.addConverationMessage(widget.chatRoomID, messageMap);
      messageController.clear();
    }
  }

  @override
  void initState() {
    databaseMethods.getConverationMessages(widget.chatRoomID).then((value) {
      setState(() {
        chatMessagesStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: Stack(
          children: [
            chatMessagesList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Message...",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
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
                        child: Image.asset('assets/images/send.png'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  const MessageTile({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        this.message,
        style: mediumTextStyle(),
      ),
    );
  }
}
