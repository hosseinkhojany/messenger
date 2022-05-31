
import 'dart:convert';

class BaseMessageModel{}

class MessageModel extends BaseMessageModel{
  String? realName;
  String? userName;
  String? message;
  String? messageType;
  bool my = false;

  MessageModel({
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

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
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

class UserTypingModel extends BaseMessageModel{
  String? userName;
  UserTypingModel({String? userName}){
    this.userName = userName ?? "";
  }
  factory UserTypingModel.fromJson(Map<String, dynamic> json){
    return UserTypingModel(
      userName: json['username'],
    );
  }
}

class UserTypingStopModel extends BaseMessageModel{
  String? userName;
  UserTypingStopModel({String? userName}){
    this.userName = userName ?? "";
  }
  factory UserTypingStopModel.fromJson(Map<String, dynamic> json){
    return UserTypingStopModel(
      userName: json['username'],
    );
  }
}

class UserLeftModel extends BaseMessageModel{
  String? userName;
  int? numUsers;
  bool my = false;
  UserLeftModel({String? userName, int? numUsers, bool? my}){
    this.userName = userName ?? "";
    this.numUsers = numUsers ?? 1;
    this.my = my ?? false;
  }
  factory UserLeftModel.fromJson(Map<String, dynamic> json){
    return UserLeftModel(
      userName: json['username'],
      numUsers: json['numUsers'],
    );
  }
}
class UserJoinedModel extends BaseMessageModel{
  String? userName;
  int? numUsers;
  bool my = false;
  UserJoinedModel({String? userName, int? numUsers, bool? my}){
    this.userName = userName ?? "";
    this.numUsers = numUsers ?? 1;
    this.my = my ?? false;
  }
  factory UserJoinedModel.fromJson(Map<String, dynamic> json){
    return UserJoinedModel(
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