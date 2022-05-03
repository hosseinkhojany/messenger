
import 'dart:convert';

class MessageModel{}

class Message extends MessageModel{
  String? userName;
  String? message;
  bool my = false;

  Message({String? userName,
        String? message,
        bool? my,
      }){
    this.userName = userName ?? "";
    this.message = message ?? "";
    this.my = my ?? false;
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      userName: json['username'],
      message: json['message'],
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
  UserLeft({String? userName, int? numUsers}){
    this.userName = userName ?? "";
    this.numUsers = numUsers ?? 1;
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
  UserJoined({String? userName, int? numUsers}){
    this.userName = userName ?? "";
    this.numUsers = numUsers ?? 1;
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