import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});


  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _messages = [];
  // A simple flag to simulate different senders (e.g., true for current user, false for others)
  bool _isCurrentUser = true;

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _messages.add(text);
      _isCurrentUser = !_isCurrentUser; // Toggle sender for demonstration
    });
  }
  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.only(bottom: 12.0), // Add padding below the input
      child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text), // Call _handleSubmitted
                ),
              ),

          ],
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'), // Changed the app bar title
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 10.0), // Add vertical padding to the message list
              reverse: true, // Display latest messages at the bottom
              itemBuilder: (_, int index) => Text(_messages[index]),
              itemCount: _messages.length,
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}