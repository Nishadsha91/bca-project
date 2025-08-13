
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:missingchild/viewchildhelpline.dart';

class MyChatPage extends StatefulWidget {
  @override
  State<MyChatPage> createState() => _MyChatPageState();
}

class ChatMessage {
  String messageContent;
  String messageType;

  ChatMessage({required this.messageContent, required this.messageType});
}

class _MyChatPageState extends State<MyChatPage> {
  String name = "";

  _MyChatPageState() {
    Timer.periodic(Duration(seconds: 2), (_) {
      view_message();
    });
  }

  List<ChatMessage> messages = [];
  TextEditingController te_message = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> view_message() async {
    final pref = await SharedPreferences.getInstance();
    name = pref.getString("name").toString();

    try {
      String ip = pref.getString("url").toString();
      String url = ip + "/viewchat";

      var data = await http.post(Uri.parse(url), body: {
        'from_id': pref.getString("lid").toString(),
        'to_id': pref.getString("toid").toString()
      });
      var jsondata = json.decode(data.body);

      messages.clear();
      var arr = jsondata["data"];
      for (var item in arr) {
        if (pref.getString("lid").toString() == item['fromid'].toString()) {
          messages.add(ChatMessage(
              messageContent: item['msg'], messageType: "sender"));
        } else {
          messages.add(ChatMessage(
              messageContent: item['msg'], messageType: "receiver"));
        }
      }

      setState(() {});
    } catch (e) {
      print("Error ------------------- " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          name,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.teal.shade800,  // Dark teal for header
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: WillPopScope(
        child: Form(
          key: _formKey,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.lightBlue.shade50, Colors.white],  // Light blue gradient for background
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              ListView.builder(
                itemCount: messages.length,
                padding: EdgeInsets.only(top: 10, bottom: 70),
                itemBuilder: (context, index) {
                  return Align(
                    alignment: messages[index].messageType == "receiver"
                        ? Alignment.topLeft
                        : Alignment.topRight,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: messages[index].messageType == "receiver"
                            ? Colors.grey.shade800
                            : Colors.teal.shade700,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        messages[index].messageContent,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade800,  // Dark teal footer
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        offset: Offset(0, -2),
                        blurRadius: 5,
                      )
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: te_message,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Type a message...",
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey.shade800,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please type something';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      FloatingActionButton(
                        onPressed: () async {
                          String message = te_message.text.toString();

                          try {
                            final pref = await SharedPreferences.getInstance();
                            String ip = pref.getString("url").toString();

                            String url = ip + "/sendchat";

                            await http.post(Uri.parse(url), body: {
                              'message': message,
                              'fromid': pref.getString("lid").toString(),
                              'toid': pref.getString("toid").toString(),
                            });

                            te_message.text = "";
                            setState(() {});
                          } catch (e) {
                            print("Error ------------------- " + e.toString());
                          }
                        },
                        child: Icon(Icons.send, color: Colors.white),
                        backgroundColor: Colors.red.shade600,  // Red send button for call-to-action
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Viewchildhelpline(title: ''),
            ),
          );
          return true;
        },
      ),
    );
  }
}
