import 'dart:convert';
/// success : 1
/// message : "success."
/// device_tokens : [{"user_id":"2","device_token":"Device Token Here","device_type":"Android","device_name":"SM-A146C","is_force_logout":"0"}]

GetDeviceTokenResponseModel getDeviceTokenResponseModelFromJson(String str) => GetDeviceTokenResponseModel.fromJson(json.decode(str));
String getDeviceTokenResponseModelToJson(GetDeviceTokenResponseModel data) => json.encode(data.toJson());
class GetDeviceTokenResponseModel {
  GetDeviceTokenResponseModel({
      num? success, 
      String? message, 
      List<DeviceTokens>? deviceTokens,}){
    _success = success;
    _message = message;
    _deviceTokens = deviceTokens;
}

  GetDeviceTokenResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    if (json['device_tokens'] != null) {
      _deviceTokens = [];
      json['device_tokens'].forEach((v) {
        _deviceTokens?.add(DeviceTokens.fromJson(v));
      });
    }
  }
  num? _success;
  String? _message;
  List<DeviceTokens>? _deviceTokens;
GetDeviceTokenResponseModel copyWith({  num? success,
  String? message,
  List<DeviceTokens>? deviceTokens,
}) => GetDeviceTokenResponseModel(  success: success ?? _success,
  message: message ?? _message,
  deviceTokens: deviceTokens ?? _deviceTokens,
);
  num? get success => _success;
  String? get message => _message;
  List<DeviceTokens>? get deviceTokens => _deviceTokens;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_deviceTokens != null) {
      map['device_tokens'] = _deviceTokens?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// user_id : "2"
/// device_token : "Device Token Here"
/// device_type : "Android"
/// device_name : "SM-A146C"
/// is_force_logout : "0"

DeviceTokens deviceTokensFromJson(String str) => DeviceTokens.fromJson(json.decode(str));
String deviceTokensToJson(DeviceTokens data) => json.encode(data.toJson());
class DeviceTokens {
  DeviceTokens({
      String? userId, 
      String? deviceToken, 
      String? deviceType, 
      String? deviceName, 
      String? isForceLogout,}){
    _userId = userId;
    _deviceToken = deviceToken;
    _deviceType = deviceType;
    _deviceName = deviceName;
    _isForceLogout = isForceLogout;
}

  DeviceTokens.fromJson(dynamic json) {
    _userId = json['user_id'];
    _deviceToken = json['device_token'];
    _deviceType = json['device_type'];
    _deviceName = json['device_name'];
    _isForceLogout = json['is_force_logout'];
  }
  String? _userId;
  String? _deviceToken;
  String? _deviceType;
  String? _deviceName;
  String? _isForceLogout;
DeviceTokens copyWith({  String? userId,
  String? deviceToken,
  String? deviceType,
  String? deviceName,
  String? isForceLogout,
}) => DeviceTokens(  userId: userId ?? _userId,
  deviceToken: deviceToken ?? _deviceToken,
  deviceType: deviceType ?? _deviceType,
  deviceName: deviceName ?? _deviceName,
  isForceLogout: isForceLogout ?? _isForceLogout,
);
  String? get userId => _userId;
  String? get deviceToken => _deviceToken;
  String? get deviceType => _deviceType;
  String? get deviceName => _deviceName;
  String? get isForceLogout => _isForceLogout;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = _userId;
    map['device_token'] = _deviceToken;
    map['device_type'] = _deviceType;
    map['device_name'] = _deviceName;
    map['is_force_logout'] = _isForceLogout;
    return map;
  }

}