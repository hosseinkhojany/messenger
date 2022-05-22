
class ChatModel{}

class PrivateChat extends ChatModel{

  late String username;
  late String lastMessage;
  late String imageUrl;
  late String time;
  int unreadCounts = 0;
  bool isActive = false;

  PrivateChat({String? username,
  String? lastMessage,
  String? imageUrl,
  String? time,
  int? unreadCounts}){

    this.username = username ?? "";
    this.lastMessage = lastMessage ?? "";
    this.imageUrl = imageUrl ?? "";
    this.time = time ?? "";
    this.unreadCounts = unreadCounts ?? 0;

  }
}