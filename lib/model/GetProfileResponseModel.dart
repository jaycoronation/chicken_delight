import 'dart:convert';
/// profile : {"name":"John Doe","email":"john@chickendelight.com","username":"portage_ave","id":"12","address_line_1":"1855a Portage Ave","address_line_2":"MB R3J 0G8","address_line_3":"","address_line_4":"","country_id":"39","state_id":"867","city_id":"17215","mobile":"9825589659","type":"2","website":"www.chickendelight.com","business_name":"Portage Ave","profile_picture":"http://192.168.1.91/chicken_delight/api/assets/upload/admin/1717427821_100_3685.JPG","business_logo":"http://192.168.1.91/chicken_delight/api/assets/upload/admin/user.png"}
/// success : 1
/// message : ""

GetProfileResponseModel getProfileResponseModelFromJson(String str) => GetProfileResponseModel.fromJson(json.decode(str));
String getProfileResponseModelToJson(GetProfileResponseModel data) => json.encode(data.toJson());
class GetProfileResponseModel {
  GetProfileResponseModel({
      Profile? profile, 
      num? success, 
      String? message,}){
    _profile = profile;
    _success = success;
    _message = message;
}

  GetProfileResponseModel.fromJson(dynamic json) {
    _profile = json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    _success = json['success'];
    _message = json['message'];
  }
  Profile? _profile;
  num? _success;
  String? _message;
GetProfileResponseModel copyWith({  Profile? profile,
  num? success,
  String? message,
}) => GetProfileResponseModel(  profile: profile ?? _profile,
  success: success ?? _success,
  message: message ?? _message,
);
  Profile? get profile => _profile;
  num? get success => _success;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_profile != null) {
      map['profile'] = _profile?.toJson();
    }
    map['success'] = _success;
    map['message'] = _message;
    return map;
  }

}

/// name : "John Doe"
/// email : "john@chickendelight.com"
/// username : "portage_ave"
/// id : "12"
/// address_line_1 : "1855a Portage Ave"
/// address_line_2 : "MB R3J 0G8"
/// address_line_3 : ""
/// address_line_4 : ""
/// country_id : "39"
/// state_id : "867"
/// city_id : "17215"
/// mobile : "9825589659"
/// type : "2"
/// website : "www.chickendelight.com"
/// business_name : "Portage Ave"
/// profile_picture : "http://192.168.1.91/chicken_delight/api/assets/upload/admin/1717427821_100_3685.JPG"
/// business_logo : "http://192.168.1.91/chicken_delight/api/assets/upload/admin/user.png"

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));
String profileToJson(Profile data) => json.encode(data.toJson());
class Profile {
  Profile({
      String? name, 
      String? email, 
      String? username, 
      String? id, 
      String? addressLine1, 
      String? addressLine2, 
      String? addressLine3, 
      String? addressLine4, 
      String? countryId, 
      String? stateId, 
      String? cityId, 
      String? mobile, 
      String? type, 
      String? website, 
      String? businessName, 
      String? shippingCharge,
      String? profilePicture,
      String? businessLogo,}){
    _name = name;
    _email = email;
    _username = username;
    _id = id;
    _addressLine1 = addressLine1;
    _addressLine2 = addressLine2;
    _addressLine3 = addressLine3;
    _addressLine4 = addressLine4;
    _countryId = countryId;
    _stateId = stateId;
    _cityId = cityId;
    _mobile = mobile;
    _type = type;
    _website = website;
    _businessName = businessName;
    _shippingCharge = shippingCharge;
    _profilePicture = profilePicture;
    _businessLogo = businessLogo;
}

  Profile.fromJson(dynamic json) {
    _name = json['name'];
    _email = json['email'];
    _username = json['username'];
    _id = json['id'];
    _addressLine1 = json['address_line_1'];
    _addressLine2 = json['address_line_2'];
    _addressLine3 = json['address_line_3'];
    _addressLine4 = json['address_line_4'];
    _countryId = json['country_id'];
    _stateId = json['state_id'];
    _cityId = json['city_id'];
    _mobile = json['mobile'];
    _type = json['type'];
    _website = json['website'];
    _businessName = json['business_name'];
    _shippingCharge = json['shipping_charge'];
    _profilePicture = json['profile_picture'];
    _businessLogo = json['business_logo'];
  }
  String? _name;
  String? _email;
  String? _username;
  String? _id;
  String? _addressLine1;
  String? _addressLine2;
  String? _addressLine3;
  String? _addressLine4;
  String? _countryId;
  String? _stateId;
  String? _cityId;
  String? _mobile;
  String? _type;
  String? _website;
  String? _businessName;
  String? _shippingCharge;
  String? _profilePicture;
  String? _businessLogo;
Profile copyWith({  String? name,
  String? email,
  String? username,
  String? id,
  String? addressLine1,
  String? addressLine2,
  String? addressLine3,
  String? addressLine4,
  String? countryId,
  String? stateId,
  String? cityId,
  String? mobile,
  String? type,
  String? website,
  String? businessName,
  String? shippingCharge,
  String? profilePicture,
  String? businessLogo,
}) => Profile(  name: name ?? _name,
  email: email ?? _email,
  username: username ?? _username,
  id: id ?? _id,
  addressLine1: addressLine1 ?? _addressLine1,
  addressLine2: addressLine2 ?? _addressLine2,
  addressLine3: addressLine3 ?? _addressLine3,
  addressLine4: addressLine4 ?? _addressLine4,
  countryId: countryId ?? _countryId,
  stateId: stateId ?? _stateId,
  cityId: cityId ?? _cityId,
  mobile: mobile ?? _mobile,
  type: type ?? _type,
  website: website ?? _website,
  businessName: businessName ?? _businessName,
  shippingCharge: shippingCharge ?? _shippingCharge,
  profilePicture: profilePicture ?? _profilePicture,
  businessLogo: businessLogo ?? _businessLogo,
);
  String? get name => _name;
  String? get email => _email;
  String? get username => _username;
  String? get id => _id;
  String? get addressLine1 => _addressLine1;
  String? get addressLine2 => _addressLine2;
  String? get addressLine3 => _addressLine3;
  String? get addressLine4 => _addressLine4;
  String? get countryId => _countryId;
  String? get stateId => _stateId;
  String? get cityId => _cityId;
  String? get mobile => _mobile;
  String? get type => _type;
  String? get website => _website;
  String? get businessName => _businessName;
  String? get shippingCharge => _shippingCharge;
  String? get profilePicture => _profilePicture;
  String? get businessLogo => _businessLogo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['email'] = _email;
    map['username'] = _username;
    map['id'] = _id;
    map['address_line_1'] = _addressLine1;
    map['address_line_2'] = _addressLine2;
    map['address_line_3'] = _addressLine3;
    map['address_line_4'] = _addressLine4;
    map['country_id'] = _countryId;
    map['state_id'] = _stateId;
    map['city_id'] = _cityId;
    map['mobile'] = _mobile;
    map['type'] = _type;
    map['website'] = _website;
    map['business_name'] = _businessName;
    map['shipping_charge'] = _shippingCharge;
    map['profile_picture'] = _profilePicture;
    map['business_logo'] = _businessLogo;
    return map;
  }

}