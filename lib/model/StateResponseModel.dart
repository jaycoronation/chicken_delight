import 'dart:convert';
/// states : [{"id":"872","name":"Alberta","country_id":"39"},{"id":"875","name":"British Columbia","country_id":"39"},{"id":"867","name":"Manitoba","country_id":"39"},{"id":"868","name":"New Brunswick","country_id":"39"},{"id":"877","name":"Newfoundland and Labrador","country_id":"39"},{"id":"878","name":"Northwest Territories","country_id":"39"},{"id":"874","name":"Nova Scotia","country_id":"39"},{"id":"876","name":"Nunavut","country_id":"39"},{"id":"866","name":"Ontario","country_id":"39"},{"id":"871","name":"Prince Edward Island","country_id":"39"},{"id":"873","name":"Quebec","country_id":"39"},{"id":"870","name":"Saskatchewan","country_id":"39"},{"id":"869","name":"Yukon","country_id":"39"}]
/// success : 1
/// message : ""

StateResponseModel stateResponseModelFromJson(String str) => StateResponseModel.fromJson(json.decode(str));
String stateResponseModelToJson(StateResponseModel data) => json.encode(data.toJson());
class StateResponseModel {
  StateResponseModel({
      List<States>? states, 
      num? success, 
      String? message,}){
    _states = states;
    _success = success;
    _message = message;
}

  StateResponseModel.fromJson(dynamic json) {
    if (json['states'] != null) {
      _states = [];
      json['states'].forEach((v) {
        _states?.add(States.fromJson(v));
      });
    }
    _success = json['success'];
    _message = json['message'];
  }
  List<States>? _states;
  num? _success;
  String? _message;
StateResponseModel copyWith({  List<States>? states,
  num? success,
  String? message,
}) => StateResponseModel(  states: states ?? _states,
  success: success ?? _success,
  message: message ?? _message,
);
  List<States>? get states => _states;
  num? get success => _success;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_states != null) {
      map['states'] = _states?.map((v) => v.toJson()).toList();
    }
    map['success'] = _success;
    map['message'] = _message;
    return map;
  }

}

/// id : "872"
/// name : "Alberta"
/// country_id : "39"

States statesFromJson(String str) => States.fromJson(json.decode(str));
String statesToJson(States data) => json.encode(data.toJson());
class States {
  States({
      String? id, 
      String? name, 
      String? countryId,}){
    _id = id;
    _name = name;
    _countryId = countryId;
}

  States.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _countryId = json['country_id'];
  }
  String? _id;
  String? _name;
  String? _countryId;
States copyWith({  String? id,
  String? name,
  String? countryId,
}) => States(  id: id ?? _id,
  name: name ?? _name,
  countryId: countryId ?? _countryId,
);
  String? get id => _id;
  String? get name => _name;
  String? get countryId => _countryId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['country_id'] = _countryId;
    return map;
  }

}