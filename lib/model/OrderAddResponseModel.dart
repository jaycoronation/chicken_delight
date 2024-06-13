import 'dart:convert';

/// success : 1
/// message : " order has been added.."
/// order_id : 57

OrderAddResponseModel orderAddResponseModelFromJson(String str) => OrderAddResponseModel.fromJson(json.decode(str));
String orderAddResponseModelToJson(OrderAddResponseModel data) => json.encode(data.toJson());
class OrderAddResponseModel {
  OrderAddResponseModel({
      num? success, 
      String? message, 
      num? orderId,}){
    _success = success;
    _message = message;
    _orderId = orderId;
}

  OrderAddResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _orderId = json['order_id'];
  }
  num? _success;
  String? _message;
  num? _orderId;
OrderAddResponseModel copyWith({  num? success,
  String? message,
  num? orderId,
}) => OrderAddResponseModel(  success: success ?? _success,
  message: message ?? _message,
  orderId: orderId ?? _orderId,
);
  num? get success => _success;
  String? get message => _message;
  num? get orderId => _orderId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    map['order_id'] = _orderId;
    return map;
  }

}