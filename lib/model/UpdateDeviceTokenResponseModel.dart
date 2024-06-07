import 'dart:convert';
/// is_force_logout : "0"
/// success : 1
/// message : "Token successfully updated."

UpdateDeviceTokenResponseModel updateDeviceTokenResponseModelFromJson(String str) => UpdateDeviceTokenResponseModel.fromJson(json.decode(str));
String updateDeviceTokenResponseModelToJson(UpdateDeviceTokenResponseModel data) => json.encode(data.toJson());
class UpdateDeviceTokenResponseModel {
  UpdateDeviceTokenResponseModel({
      String? isForceLogout, 
      num? success, 
      String? message,}){
    _isForceLogout = isForceLogout;
    _success = success;
    _message = message;
}

  UpdateDeviceTokenResponseModel.fromJson(dynamic json) {
    _isForceLogout = json['is_force_logout'];
    _success = json['success'];
    _message = json['message'];
  }
  String? _isForceLogout;
  num? _success;
  String? _message;
UpdateDeviceTokenResponseModel copyWith({  String? isForceLogout,
  num? success,
  String? message,
}) => UpdateDeviceTokenResponseModel(  isForceLogout: isForceLogout ?? _isForceLogout,
  success: success ?? _success,
  message: message ?? _message,
);
  String? get isForceLogout => _isForceLogout;
  num? get success => _success;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['is_force_logout'] = _isForceLogout;
    map['success'] = _success;
    map['message'] = _message;
    return map;
  }

}