
class BaseModel {
  bool success;
  String message;
  BaseModel(this.success, this.message);
  factory BaseModel.fromJson(Map<String, dynamic> json){
    return BaseModel(
      json['success'] ?? false,
      json['message'] ?? "",
    );
  }
}