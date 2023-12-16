import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Ensure you have this import for date formatting

class MessagePage extends StatefulWidget {
  static const route = '/message_screen';
  final String message;
  final String time;

  MessagePage({
    Key? key,
    required this.message,
    required this.time,
  }) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController _replyController = TextEditingController();
  final List<Map<String, String>> _replies = []; // Store replies with their timestamps

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  void _sendReply() {
    final String currentTime = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    setState(() {
      // Add the reply with the current timestamp
      _replies.add({'reply': _replyController.text, 'time': currentTime});
      _replyController.clear();
    });
  }

  Widget _buildMessageBadge(String message, String time, bool isReply) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // Center-align the timestamp
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            time,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey[600],
            ),
          ),
        ),
        Align(
          alignment: isReply ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4.0),
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: isReply ? Colors.lightGreen[100] : Colors.grey[300],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMessageBadge(widget.message, widget.time, false),
                  for (var reply in _replies) 
                    _buildMessageBadge(reply['reply']!, reply['time']!, true),
                ],
              ),
            ),
          ),
          // Reply Text Field and Send Button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _replyController,
                    decoration: InputDecoration(
                      hintText: 'Type your reply...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendReply,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
