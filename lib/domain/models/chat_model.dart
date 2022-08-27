import 'package:flutter/cupertino.dart';

class ChatModel {
  List<Message>? messages;
  List<String>? users;

  ChatModel({this.messages, this.users});

  ChatModel.fromJson(Map<String, dynamic> json) {
    messages = <Message>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        messages!.add(Message.fromJson(v));
      });
    }
    users = json['users']?.cast<String>() ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (messages != null) {
      data['message'] = messages!.map((v) => v.toJson()).toList();
    }
    data['users'] = users;
    return data;
  }
}

class Message {
  int? time;
  String? content;
  String? userId;
  bool? visible;

  Message({this.time, this.content, this.userId, this.visible});

  Message.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    content = json['content'];
    userId = json['user-id'];
    visible = json['visible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['time'] = time;
    data['content'] = content;
    data['user-id'] = userId;
    data['visible'] = visible;
    return data;
  }
}

class ChatController {
  static final listController = ScrollController();
  static final textController = TextEditingController();

  static bool get textIsEmpty => textController.value.text.trim().isEmpty;

  static Future<void> jumpDown({double offset = 0}) async {
    listController.jumpTo(
      0,
    );
  }
}
