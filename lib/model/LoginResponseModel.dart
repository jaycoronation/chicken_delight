import 'dart:convert';
/// success : 1
/// message : "Login successful!"
/// records : {"id":"5","token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjUiLCJBUElfVElNRSI6MTcxNzM5NzI2Mn0.bEEuTebghHel7RL9sLuwzO3qGtRY0vQH-CxLUe0qTOI","type":"2","name":"John Doe","profile_picture":"http://192.168.1.91/chicken_delight/api/assets/upload/admin/1715753982_100_3685.JPG"}

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));
String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());
class LoginResponseModel {
  LoginResponseModel({
      num? success, 
      String? message, 
      Records? records,}){
    _success = success;
    _message = message;
    _records = records;
}

  LoginResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _records = json['records'] != null ? Records.fromJson(json['records']) : null;
  }
  num? _success;
  String? _message;
  Records? _records;
LoginResponseModel copyWith({  num? success,
  String? message,
  Records? records,
}) => LoginResponseModel(  success: success ?? _success,
  message: message ?? _message,
  records: records ?? _records,
);
  num? get success => _success;
  String? get message => _message;
  Records? get records => _records;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_records != null) {
      map['records'] = _records?.toJson();
    }
    return map;
  }

}

/// id : "5"
/// token : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjUiLCJBUElfVElNRSI6MTcxNzM5NzI2Mn0.bEEuTebghHel7RL9sLuwzO3qGtRY0vQH-CxLUe0qTOI"
/// type : "2"
/// name : "John Doe"
/// profile_picture : "http://192.168.1.91/chicken_delight/api/assets/upload/admin/1715753982_100_3685.JPG"

Records recordsFromJson(String str) => Records.fromJson(json.decode(str));
String recordsToJson(Records data) => json.encode(data.toJson());
class Records {
  Records({
      String? id, 
      String? token, 
      String? type, 
      String? name, 
      String? profilePicture,
    String? shippingCharge,}){
    _id = id;
    _token = token;
    _type = type;
    _name = name;
    _profilePicture = profilePicture;
    _shippingCharge = shippingCharge;
}

  Records.fromJson(dynamic json) {
    _id = json['id'];
    _token = json['token'];
    _type = json['type'];
    _name = json['name'];
    _profilePicture = json['profile_picture'];
    _shippingCharge = json['shipping_charge'];
  }
  String? _id;
  String? _token;
  String? _type;
  String? _name;
  String? _profilePicture;
  String? _shippingCharge;
Records copyWith({  String? id,
  String? token,
  String? type,
  String? name,
  String? profilePicture,
  String? shippingCharge,
}) => Records(  id: id ?? _id,
  token: token ?? _token,
  type: type ?? _type,
  name: name ?? _name,
  profilePicture: profilePicture ?? _profilePicture,
  shippingCharge: shippingCharge ?? _shippingCharge,
);
  String? get id => _id;
  String? get token => _token;
  String? get type => _type;
  String? get name => _name;
  String? get profilePicture => _profilePicture;
  String? get shippingCharge => _shippingCharge;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['token'] = _token;
    map['type'] = _type;
    map['name'] = _name;
    map['profile_picture'] = _profilePicture;
    map['shipping_charge'] = _shippingCharge;
    return map;
  }

}