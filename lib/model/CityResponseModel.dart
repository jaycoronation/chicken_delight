import 'dart:convert';
/// cities : [{"id":"16160","name":"Altona","state_id":"867"},{"id":"16206","name":"Beausejour","state_id":"867"},{"id":"16225","name":"Boissevain","state_id":"867"},{"id":"16238","name":"Brandon","state_id":"867"},{"id":"16275","name":"Carberry","state_id":"867"},{"id":"16283","name":"Carman","state_id":"867"},{"id":"16348","name":"Cross Lake 19A","state_id":"867"},{"id":"16356","name":"Dauphin","state_id":"867"},{"id":"16360","name":"De Salaberry","state_id":"867"},{"id":"16364","name":"Deloraine","state_id":"867"},{"id":"16422","name":"Flin Flon","state_id":"867"},{"id":"16452","name":"Gimli","state_id":"867"},{"id":"16477","name":"Grunthal","state_id":"867"},{"id":"16500","name":"Headingley","state_id":"867"},{"id":"16518","name":"Ile des Chênes","state_id":"867"},{"id":"16544","name":"Killarney","state_id":"867"},{"id":"16563","name":"La Broquerie","state_id":"867"},{"id":"16576","name":"Lac du Bonnet","state_id":"867"},{"id":"16593","name":"Landmark","state_id":"867"},{"id":"16629","name":"Lorette","state_id":"867"},{"id":"16677","name":"Melita","state_id":"867"},{"id":"16693","name":"Minnedosa","state_id":"867"},{"id":"16714","name":"Moose Lake","state_id":"867"},{"id":"16717","name":"Morden","state_id":"867"},{"id":"16720","name":"Morris","state_id":"867"},{"id":"16734","name":"Neepawa","state_id":"867"},{"id":"16749","name":"Niverville","state_id":"867"},{"id":"16848","name":"Portage la Prairie","state_id":"867"},{"id":"16894","name":"Rivers","state_id":"867"},{"id":"16898","name":"Roblin","state_id":"867"},{"id":"17026","name":"Selkirk","state_id":"867"},{"id":"17041","name":"Shilo","state_id":"867"},{"id":"17056","name":"Souris","state_id":"867"},{"id":"17067","name":"St. Adolphe","state_id":"867"},{"id":"17075","name":"Steinbach","state_id":"867"},{"id":"17080","name":"Stonewall","state_id":"867"},{"id":"17093","name":"Swan River","state_id":"867"},{"id":"17105","name":"The Pas","state_id":"867"},{"id":"17108","name":"Thompson","state_id":"867"},{"id":"17161","name":"Virden","state_id":"867"},{"id":"17192","name":"West St. Paul","state_id":"867"},{"id":"17214","name":"Winkler","state_id":"867"},{"id":"17215","name":"Winnipeg","state_id":"867"}]
/// success : 1
/// message : ""

CityResponseModel cityResponseModelFromJson(String str) => CityResponseModel.fromJson(json.decode(str));
String cityResponseModelToJson(CityResponseModel data) => json.encode(data.toJson());
class CityResponseModel {
  CityResponseModel({
      List<Cities>? cities, 
      num? success, 
      String? message,}){
    _cities = cities;
    _success = success;
    _message = message;
}

  CityResponseModel.fromJson(dynamic json) {
    if (json['cities'] != null) {
      _cities = [];
      json['cities'].forEach((v) {
        _cities?.add(Cities.fromJson(v));
      });
    }
    _success = json['success'];
    _message = json['message'];
  }
  List<Cities>? _cities;
  num? _success;
  String? _message;
CityResponseModel copyWith({  List<Cities>? cities,
  num? success,
  String? message,
}) => CityResponseModel(  cities: cities ?? _cities,
  success: success ?? _success,
  message: message ?? _message,
);
  List<Cities>? get cities => _cities;
  num? get success => _success;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_cities != null) {
      map['cities'] = _cities?.map((v) => v.toJson()).toList();
    }
    map['success'] = _success;
    map['message'] = _message;
    return map;
  }

}

/// id : "16160"
/// name : "Altona"
/// state_id : "867"

Cities citiesFromJson(String str) => Cities.fromJson(json.decode(str));
String citiesToJson(Cities data) => json.encode(data.toJson());
class Cities {
  Cities({
      String? id, 
      String? name, 
      String? stateId,}){
    _id = id;
    _name = name;
    _stateId = stateId;
}

  Cities.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _stateId = json['state_id'];
  }
  String? _id;
  String? _name;
  String? _stateId;
Cities copyWith({  String? id,
  String? name,
  String? stateId,
}) => Cities(  id: id ?? _id,
  name: name ?? _name,
  stateId: stateId ?? _stateId,
);
  String? get id => _id;
  String? get name => _name;
  String? get stateId => _stateId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['state_id'] = _stateId;
    return map;
  }

}