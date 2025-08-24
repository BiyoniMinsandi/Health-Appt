// providers/chat_provider.dart
import 'package:flutter/foundation.dart';

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final String messageType;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.messageType = 'text',
  });
}

class ChatProvider with ChangeNotifier {
  List<Message> _messages = [];
  bool _isLoading = false;

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;

  void sendMessage(String senderId, String receiverId, String message) {
    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      timestamp: DateTime.now(),
    );
    
    _messages.add(newMessage);
    notifyListeners();
  }

  List<Message> getChatMessages(String userId, String otherUserId) {
    return _messages.where((msg) => 
      (msg.senderId == userId && msg.receiverId == otherUserId) ||
      (msg.senderId == otherUserId && msg.receiverId == userId)
    ).toList();
  }
}