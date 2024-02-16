import 'dart:async';
import 'dart:math';
import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/chat/chat_service.dart';

class ChatMockSerice implements ChatService {
  static final List<ChatMessage> _msgs = [
    // ChatMessage(
    //   id: '1',
    //   text:
    //       'Opções de Ajuda: \n\n 1 - Falar com Suporte\n 2 - Cancelar serviço\n 3 - Negociar Dividas\n\n No que posso de ajudar?',
    //   createdAt: DateTime.now(),
    //   userId: '1',
    //   userName: 'Chat',
    //   userImageURL: 'assets/images/avatar.png',
    // ),
  ];
  static MultiStreamController<List<ChatMessage>>? _controller;
  static final _msgsStream = Stream<List<ChatMessage>>.multi((controller) {
    _controller = controller;
    controller.add(_msgs);
  });

  @override
  Stream<List<ChatMessage>> messagesStream() {
    return _msgsStream;
  }

  @override
  Future<ChatMessage> save(String text, ChatUser user) async {
    final newMessage = ChatMessage(
      id: Random().nextDouble().toString(),
      text: text,
      createdAt: DateTime.now(),
      userId: user.id,
      userName: user.name,
      userImageURL: user.imageURL,
    );
    _msgs.add(newMessage);
    _controller?.add(_msgs.reversed.toList());
    return newMessage;
  }
}
