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
  Stream? chatMessagesStream;

  Widget chatMessagesList() {
    return StreamBuilder(
      stream: chatMessagesStream,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.data != null) {
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return MessageTile(
                  message: snapshot.data.docs[index]["message"].toString(),
                  isSentByMe:
                      snapshot.data.docs[index]["sender"] == Constants.myName,
                );
              });
        } else {
          return Container();
        }
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sender": Constants.myName,
        'timestamp': Timestamp.now().millisecondsSinceEpoch
      };
      databaseMethods.addConverationMessage(widget.chatRoomID, messageMap);
      messageController.clear();
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomID).then((value) {
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
  final bool isSentByMe;
  const MessageTile({Key? key, required this.message, required this.isSentByMe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSentByMe
                ? [Color(0xff007EF4), Color(0xff2A75BC)]
                : [Color(0x1AFFFFFF), Color(0x1AFFFFFF)],
          ),
          borderRadius: isSentByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23),
                ),
        ),
        child: Text(message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
            )),
      ),
    );
  }
}
