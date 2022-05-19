
import 'message.dart';

class LoginResponse extends MessageModel{
  bool success;
  String message;
  LoginResponse(this.success, this.message);
  factory LoginResponse.fromJson(Map<String, dynamic> json){
    return LoginResponse(
      json['success'] ?? false,
      json['message'] ?? "",
    );
  }
}