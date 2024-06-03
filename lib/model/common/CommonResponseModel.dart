import 'dart:convert';
/// success : 1
/// message : "UNISON Verification code has been successfully sent to mobile no."

CommonResponseModel commonResponseModelFromJson(String str) => CommonResponseModel.fromJson(json.decode(str));
String commonResponseModelToJson(CommonResponseModel data) => json.encode(data.toJson());
class CommonResponseModel {
  CommonResponseModel({
      num? success, 
      String? message,}){
    _success = success;
    _message = message;
}

  CommonResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
  }
  num? _success;
  String? _message;
CommonResponseModel copyWith({  num? success,
  String? message,
}) => CommonResponseModel(  success: success ?? _success,
  message: message ?? _message,
);
  num? get success => _success;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    return map;
  }

}