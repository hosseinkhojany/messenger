import 'message.dart';

class History {
  List<MessageModel>? history;

  History({
  List<MessageModel>? history}){
    this.history = history ?? [];
  }

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      history: json['data'] != null
          ? (json['data'] as List)
              .map((i) => MessageModel.fromJson(i))
              .toList()
          : null,
    );
  }
}
