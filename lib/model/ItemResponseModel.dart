import 'dart:convert';

import 'package:flutter/cupertino.dart';
/// records : [{"id":"11","description":"<p>test</p>\r\n","name":"Check Product","icon":"https://chickendelight.saltpixels.in/api/assets/upload/items/default.png","product_code":"adada","unit":"kg","variation_name":"Var 1","sku_code":"","sale_price":"15","mrp_price":"15","variation_id":"18","dp_price":"10","category":"Check Product Category","shipping_charge":"0","compositions":[{"id":"40","raw_material_id":"17","amount_used":"0.25","item_id":"11","variation_id":"18","timestamp":"1718725480"}],"category_id":"39"}]
/// message : "items details found"
/// success : 1
/// total_records : "15"

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

/// id : "11"
/// description : "<p>test</p>\r\n"
/// name : "Check Product"
/// icon : "https://chickendelight.saltpixels.in/api/assets/upload/items/default.png"
/// product_code : "adada"
/// unit : "kg"
/// variation_name : "Var 1"
/// sku_code : ""
/// sale_price : "15"
/// mrp_price : "15"
/// variation_id : "18"
/// dp_price : "10"
/// category : "Check Product Category"
/// shipping_charge : "0"
/// compositions : [{"id":"40","raw_material_id":"17","amount_used":"0.25","item_id":"11","variation_id":"18","timestamp":"1718725480"}]
/// category_id : "39"

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
      String? variationId, 
      String? dpPrice, 
      String? category, 
      List<Compositions>? compositions,
      String? categoryId,
    bool? isSelected,
    num? quantity,
    num? amount,
    int? updateCartCount
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
    _variationId = variationId;
    _dpPrice = dpPrice;
    _category = category;
    _compositions = compositions;
    _categoryId = categoryId;
    _isSelected = isSelected;
    _quantity = quantity;
    _amount = amount;
    _updateCartCount = updateCartCount;
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
    _variationId = json['variation_id'];
    _dpPrice = json['dp_price'];
    _category = json['category'];
    if (json['compositions'] != null) {
      _compositions = [];
      json['compositions'].forEach((v) {
        _compositions?.add(Compositions.fromJson(v));
      });
    }
    _categoryId = json['category_id'];
    _isSelected = json['isSelected'] ?? false;
    _quantity = json['quantity'];
    _amount = json['amount'];
    _updateCartCount = json['update_cart_count'];
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
  String? _variationId;
  String? _dpPrice;
  String? _category;
  List<Compositions>? _compositions;
  String? _categoryId;
  bool? _isSelected;
  num? _quantity;
  num? _amount;
  int? _updateCartCount;
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
  String? variationId,
  String? dpPrice,
  String? category,
  String? shippingCharge,
  List<Compositions>? compositions,
  String? categoryId,
  bool? isSelected,
  num? quantity,
  num? amount,
  int? updateCartCount,
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
  variationId: variationId ?? _variationId,
  dpPrice: dpPrice ?? _dpPrice,
  category: category ?? _category,
  compositions: compositions ?? _compositions,
  categoryId: categoryId ?? _categoryId,
  isSelected: isSelected ?? _isSelected,
  quantity: quantity ?? _quantity,
  amount: amount ?? _amount,
  updateCartCount: updateCartCount ?? _updateCartCount,
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
  String? get variationId => _variationId;
  String? get dpPrice => _dpPrice;
  String? get category => _category;
  List<Compositions>? get compositions => _compositions;
  String? get categoryId => _categoryId;
  bool? get isSelected => _isSelected;
  num? get quantity => _quantity;
  num? get amount => _amount;
  int? get updateCartCount => _updateCartCount;

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
    map['variation_id'] = _variationId;
    map['dp_price'] = _dpPrice;
    map['category'] = _category;
    if (_compositions != null) {
      map['compositions'] = _compositions?.map((v) => v.toJson()).toList();
    }
    map['category_id'] = _categoryId;
    map['isSelected'] = _isSelected;
    map['quantity'] = _quantity;
    map['amount'] = _amount;
    map['update_cart_count'] = _updateCartCount;
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

  set updateCartCount(int? value) {
    _updateCartCount = value;
  }

}

/// id : "40"
/// raw_material_id : "17"
/// amount_used : "0.25"
/// item_id : "11"
/// variation_id : "18"
/// timestamp : "1718725480"

Compositions compositionsFromJson(String str) => Compositions.fromJson(json.decode(str));
String compositionsToJson(Compositions data) => json.encode(data.toJson());
class Compositions {
  Compositions({
      String? id, 
      String? rawMaterialId, 
      String? amountUsed, 
      String? itemId, 
      String? variationId, 
      String? timestamp,}){
    _id = id;
    _rawMaterialId = rawMaterialId;
    _amountUsed = amountUsed;
    _itemId = itemId;
    _variationId = variationId;
    _timestamp = timestamp;
}

  Compositions.fromJson(dynamic json) {
    _id = json['id'];
    _rawMaterialId = json['raw_material_id'];
    _amountUsed = json['amount_used'];
    _itemId = json['item_id'];
    _variationId = json['variation_id'];
    _timestamp = json['timestamp'];
  }
  String? _id;
  String? _rawMaterialId;
  String? _amountUsed;
  String? _itemId;
  String? _variationId;
  String? _timestamp;
Compositions copyWith({  String? id,
  String? rawMaterialId,
  String? amountUsed,
  String? itemId,
  String? variationId,
  String? timestamp,
}) => Compositions(  id: id ?? _id,
  rawMaterialId: rawMaterialId ?? _rawMaterialId,
  amountUsed: amountUsed ?? _amountUsed,
  itemId: itemId ?? _itemId,
  variationId: variationId ?? _variationId,
  timestamp: timestamp ?? _timestamp,
);
  String? get id => _id;
  String? get rawMaterialId => _rawMaterialId;
  String? get amountUsed => _amountUsed;
  String? get itemId => _itemId;
  String? get variationId => _variationId;
  String? get timestamp => _timestamp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['raw_material_id'] = _rawMaterialId;
    map['amount_used'] = _amountUsed;
    map['item_id'] = _itemId;
    map['variation_id'] = _variationId;
    map['timestamp'] = _timestamp;
    return map;
  }

}