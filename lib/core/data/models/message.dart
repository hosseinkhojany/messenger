
import 'dart:convert';

class MessageModel{}

class Message extends MessageModel{
  String? realName;
  String? userName;
  String? message;
  String? messageType;
  bool my = false;

  Message({
    String? realName,
    String? userName,
        String? message,
        String? messageType,
        bool? my,
      }){
    this.userName = userName ?? "";
    this.message = message ?? "";
    this.messageType = messageType ?? "";
    this.my = my ?? false;
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      realName: json['realName'],
      userName: json['username'],
      message: json['message'],
      messageType: json['messageType'],
    );
  }
  String toJsonMessage() {
    return jsonEncode({
      "username": userName,
      "message": message,
    }).toString();
  }
}

class UserTyping extends MessageModel{
  String? userName;
  UserTyping({String? userName}){
    this.userName = userName ?? "";
  }
  factory UserTyping.fromJson(Map<String, dynamic> json){
    return UserTyping(
      userName: json['username'],
    );
  }
}

class UserTypingStop extends MessageModel{
  String? userName;
  UserTypingStop({String? userName}){
    this.userName = userName ?? "";
  }
  factory UserTypingStop.fromJson(Map<String, dynamic> json){
    return UserTypingStop(
      userName: json['username'],
    );
  }
}

class UserLeft extends MessageModel{
  String? userName;
  int? numUsers;
  bool my = false;
  UserLeft({String? userName, int? numUsers, bool? my}){
    this.userName = userName ?? "";
    this.numUsers = numUsers ?? 1;
    this.my = my ?? false;
  }
  factory UserLeft.fromJson(Map<String, dynamic> json){
    return UserLeft(
      userName: json['username'],
      numUsers: json['numUsers'],
    );
  }
}
class UserJoined extends MessageModel{
  String? userName;
  int? numUsers;
  bool my = false;
  UserJoined({String? userName, int? numUsers, bool? my}){
    this.userName = userName ?? "";
    this.numUsers = numUsers ?? 1;
    this.my = my ?? false;
  }
  factory UserJoined.fromJson(Map<String, dynamic> json){
    return UserJoined(
      userName: json['username'],
      numUsers: json['numUsers'],
    );
  }

  String toJsonUserJoined() {
    return jsonEncode({
      "username": userName,
    }).toString();
  }
}


enum MessageType{
  none,
  userJoined,
  userLeft,
  newMessage,
  typing,
  stopTyping,
  image,
  video,
  voice,
  gif,
  sticker,
}