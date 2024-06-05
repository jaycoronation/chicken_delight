import 'dart:convert';

import 'package:flutter/cupertino.dart';
/// records : [{"id":"512","description":"<p>test</p>\r\n","name":"test local","icon":"http://192.168.1.91/chicken_delight/api/assets/upload/items/1717480504_download (8).jfif","product_code":"852963","unit":"kg","variation_name":"test","sku_code":"741258","sale_price":"56.4","mrp_price":"50","dp_price":"40","category":"Chicken","variation_id":"519","category_id":"32"},
/// message : "items details found"
/// success : 1
/// total_records : "509"

ItemResponseModel itemResponseModelFromJson(String str) => ItemResponseModel.fromJson(json.decode(str));
String itemResponseModelToJson(ItemResponseModel data) => json.encode(data.toJson());
class ItemResponseModel {
  ItemResponseModel({
      List<Records>? records, 
      String? message, 
      num? success, 
      String? totalRecords,}){
    _records = records;
    _message = message;
    _success = success;
    _totalRecords = totalRecords;
}

  ItemResponseModel.fromJson(dynamic json) {
    if (json['records'] != null) {
      _records = [];
      json['records'].forEach((v) {
        _records?.add(Records.fromJson(v));
      });
    }
    _message = json['message'];
    _success = json['success'];
    _totalRecords = json['total_records'];
  }
  List<Records>? _records;
  String? _message;
  num? _success;
  String? _totalRecords;
ItemResponseModel copyWith({  List<Records>? records,
  String? message,
  num? success,
  String? totalRecords,
}) => ItemResponseModel(  records: records ?? _records,
  message: message ?? _message,
  success: success ?? _success,
  totalRecords: totalRecords ?? _totalRecords,
);
  List<Records>? get records => _records;
  String? get message => _message;
  num? get success => _success;
  String? get totalRecords => _totalRecords;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_records != null) {
      map['records'] = _records?.map((v) => v.toJson()).toList();
    }
    map['message'] = _message;
    map['success'] = _success;
    map['total_records'] = _totalRecords;
    return map;
  }

}

/// id : "512"
/// description : "<p>test</p>\r\n"
/// name : "test local"
/// icon : "http://192.168.1.91/chicken_delight/api/assets/upload/items/1717480504_download (8).jfif"
/// product_code : "852963"
/// unit : "kg"
/// variation_name : "test"
/// sku_code : "741258"
/// sale_price : "56.4"
/// mrp_price : "50"
/// dp_price : "40"
/// category : "Chicken"
/// variation_id : "519"
/// category_id : "32"

Records recordsFromJson(String str) => Records.fromJson(json.decode(str));
String recordsToJson(Records data) => json.encode(data.toJson());
class Records {
  Records({
      String? id, 
      String? description, 
      String? name, 
      String? icon, 
      String? productCode, 
      String? unit, 
      String? variationName, 
      String? skuCode, 
      String? salePrice, 
      String? mrpPrice, 
      String? dpPrice, 
      String? category, 
      String? variationId, 
      String? categoryId,
    bool? isSelected,
    num? quantity,
    num? amount,
  }){
    _id = id;
    _description = description;
    _name = name;
    _icon = icon;
    _productCode = productCode;
    _unit = unit;
    _variationName = variationName;
    _skuCode = skuCode;
    _salePrice = salePrice;
    _mrpPrice = mrpPrice;
    _dpPrice = dpPrice;
    _category = category;
    _variationId = variationId;
    _categoryId = categoryId;
    _isSelected = isSelected;
    _quantity = quantity;
    _amount = amount;
}

  Records.fromJson(dynamic json) {
    _id = json['id'];
    _description = json['description'];
    _name = json['name'];
    _icon = json['icon'];
    _productCode = json['product_code'];
    _unit = json['unit'];
    _variationName = json['variation_name'];
    _skuCode = json['sku_code'];
    _salePrice = json['sale_price'];
    _mrpPrice = json['mrp_price'];
    _dpPrice = json['dp_price'];
    _category = json['category'];
    _variationId = json['variation_id'];
    _categoryId = json['category_id'];
    _isSelected = json['isSelected'] ?? false;
    _quantity = json['quantity'];
    _amount = json['amount'];
  }
  String? _id;
  String? _description;
  String? _name;
  String? _icon;
  String? _productCode;
  String? _unit;
  String? _variationName;
  String? _skuCode;
  String? _salePrice;
  String? _mrpPrice;
  String? _dpPrice;
  String? _category;
  String? _variationId;
  String? _categoryId;
  bool? _isSelected;
  num? _quantity;
  num? _amount;


Records copyWith({  String? id,
  String? description,
  String? name,
  String? icon,
  String? productCode,
  String? unit,
  String? variationName,
  String? skuCode,
  String? salePrice,
  String? mrpPrice,
  String? dpPrice,
  String? category,
  String? variationId,
  String? categoryId,
  bool? isSelected,
  num? quantity,
  num? amount,

}) => Records(  id: id ?? _id,
  description: description ?? _description,
  name: name ?? _name,
  icon: icon ?? _icon,
  productCode: productCode ?? _productCode,
  unit: unit ?? _unit,
  variationName: variationName ?? _variationName,
  skuCode: skuCode ?? _skuCode,
  salePrice: salePrice ?? _salePrice,
  mrpPrice: mrpPrice ?? _mrpPrice,
  dpPrice: dpPrice ?? _dpPrice,
  category: category ?? _category,
  variationId: variationId ?? _variationId,
  categoryId: categoryId ?? _categoryId,
  isSelected: isSelected ?? _isSelected,
  quantity: quantity ?? _quantity,
  amount: amount ?? _amount,
);
  String? get id => _id;
  String? get description => _description;
  String? get name => _name;
  String? get icon => _icon;
  String? get productCode => _productCode;
  String? get unit => _unit;
  String? get variationName => _variationName;
  String? get skuCode => _skuCode;
  String? get salePrice => _salePrice;
  String? get mrpPrice => _mrpPrice;
  String? get dpPrice => _dpPrice;
  String? get category => _category;
  String? get variationId => _variationId;
  String? get categoryId => _categoryId;
  bool? get isSelected => _isSelected;
  num? get quantity => _quantity;
  num? get amount => _amount;

  TextEditingController quantityController = TextEditingController();

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['description'] = _description;
    map['name'] = _name;
    map['icon'] = _icon;
    map['product_code'] = _productCode;
    map['unit'] = _unit;
    map['variation_name'] = _variationName;
    map['sku_code'] = _skuCode;
    map['sale_price'] = _salePrice;
    map['mrp_price'] = _mrpPrice;
    map['dp_price'] = _dpPrice;
    map['category'] = _category;
    map['variation_id'] = _variationId;
    map['category_id'] = _categoryId;
    map['isSelected'] = _isSelected;
    map['quantity'] = _quantity;
    map['amount'] = _amount;
    return map;
  }

  set isSelected(bool? value) {
    _isSelected = value;
  }

  set quantity(num? value) {
    _quantity = value;
  }

  set amount(num? value) {
    _amount = value;
  }

}