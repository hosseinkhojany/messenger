import 'message.dart';

class History {
  List<Message>? history;

  History({
  List<Message>? history}){
    this.history = history ?? [];
  }

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      history: json['data'] != null
          ? (json['data'] as List)
              .map((i) => Message.fromJson(i))
              .toList()
          : null,
    );
  }
}
