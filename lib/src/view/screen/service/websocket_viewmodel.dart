import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketMessage {
  final String? action;
  final String topic;
  final dynamic data;
  final String? status;
  final String? error;

  WebSocketMessage({
    this.action,
    required this.topic,
    this.data,
    this.status,
    this.error,
  });

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) {
    return WebSocketMessage(
      action: json['action'],
      topic: json['topic'],
      data: json['data'],
      status: json['status'],
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'topic': topic,
      if (data != null) 'data': data,
      if (status != null) 'status': status,
      if (error != null) 'error': error,
    };
  }
}

class WsService extends ChangeNotifier {
  WebSocketChannel? _channel;
  final _messagesController = StreamController<WebSocketMessage>.broadcast();
  final _connectionStatusController = StreamController<bool>.broadcast();

  Stream<WebSocketMessage> get messages => _messagesController.stream;
  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  Future<bool> connect(String url) async {
    try {
      final token = await getAccessToken();
      _channel = WebSocketChannel.connect(Uri.parse(
          'wss://nairqua-api.onrender.com/ws/?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzI2ODEzODc5LCJpYXQiOjE3MjY4MDMwNzksImp0aSI6ImJhZjY5NGQ1MGQyNjQyZjZhMmY4Y2ZkMGY3YWU1Mjc5IiwidXNlcl9pZCI6MSwidXNlcm5hbWUiOiJuYWlycXVhX2RlbW8iLCJlbWFpbCI6Im5haXJxdWFAbmFzdW9tYS5jb20ifQ.w8vlWBsy_qCHUN4HGud1qc89QLLUdaurgoEdEeEsvHk'));

      _channel!.stream.listen(
        (message) {
          try {
            final parsedMessage =
                WebSocketMessage.fromJson(json.decode(message));
            print('Received: $parsedMessage');
            _messagesController.add(parsedMessage);
          } catch (e) {
            print('Error parsing message: $e');
            // You might want to add error handling here, such as notifying listeners of the parsing error
          }
        },
        onError: (error) {
          print('WebSocket error: $error');
          _connectionStatusController.add(false);
        },
        onDone: () {
          print('WebSocket connection closed');
          _connectionStatusController.add(false);
        },
      );

      // Wait for the connection to be established
      await _channel!.ready;

      _connectionStatusController.add(true);
      return true;
    } catch (e) {
      print('Error connecting to WebSocket: $e');
      _connectionStatusController.add(false);
      return false;
    }
  }

  void subscribe(String topic) {
    _sendMessage('subscribe', topic);
  }

  void unsubscribe(String topic) {
    _sendMessage('unsubscribe', topic);
  }

  void publish(String topic, dynamic data) {
    _sendMessage('publish', topic, data);
  }

  void _sendMessage(String action, String topic, [dynamic data]) {
    if (_channel != null) {
      final message =
          WebSocketMessage(action: action, topic: topic, data: data);
      _channel!.sink.add(json.encode(message.toJson()));
    } else {
      print('WebSocket is not open. Message not sent.');
    }
  }

  Stream<dynamic> getMessages(String topic) {
    return _messagesController.stream
        .where((message) =>
            message.topic == topic &&
            message.action != 'subscribe' &&
            message.action != 'unsubscribe')
        .map((message) => message.data);
  }

  void disconnect() {
    _channel?.sink.close();
    _connectionStatusController.add(false);
  }

  @override
  void dispose() {
    disconnect();
    _messagesController.close();
    _connectionStatusController.close();
    super.dispose();
  }

  Future<String> getAccessToken() async {
    // TODO: Implement token retrieval logic
    return 'your_access_token_here';
  }
}
