import 'dart:async';

import 'package:flutter/material.dart';

import '../controller/all_widgets.dart';

class LetUsChatMessage {
  LetUsChatMessage({required this.name, required this.message});
  final String name;
  final String message;
}

class LetUsChat extends StatefulWidget {
  const LetUsChat({required this.addMessage, required this.messages});
  final FutureOr<void> Function(String message) addMessage;
  final List<LetUsChatMessage> messages;

  @override
  _LetUsChatState createState() => _LetUsChatState();
}

class _LetUsChatState extends State<LetUsChat> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_LetUsChatState');
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Firebase Chatting'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Start Chatting',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your message to continue';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  StyledButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await widget.addMessage(_controller.text);
                        _controller.clear();
                      }
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.send),
                        SizedBox(width: 6),
                        Text('SEND'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          for (var message in widget.messages)
            Paragraph('${message.name}: ${message.message}'),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
} // LetUsChat state ends

