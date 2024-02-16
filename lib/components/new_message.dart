import 'package:chat/core/services/auth/auth.service.dart';
import 'package:chat/core/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _message = '';
  final _messageController = TextEditingController();

  Future<void> _sendMessage() async {
    final user = AuthService().currentUser;

    if (user != null) {
      if (_message != '') {
        await ChatService().save(_message, user);
        _messageController.clear();
        _message = '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            onChanged: (msg) => setState(() => _message = msg),
            onSubmitted: (_) {
              if (_message.trim().isNotEmpty) {
                _sendMessage();
              }
            },
            decoration: const InputDecoration(
              labelText: 'Enviar mensagem...',
              labelStyle:
                  TextStyle(color: Colors.blue), // Change to your desired color
              focusColor: Colors.blue,
              fillColor: Colors.blue,
              hoverColor: Colors.blue,
            ),
          ),
        ),
        IconButton(
            onPressed: _message.trim().isEmpty ? null : _sendMessage,
            icon: const Icon(Icons.send))
      ],
    );
  }
}
