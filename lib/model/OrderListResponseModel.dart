import 'dart:convert';
/// order_list : [{"id":"3","order_number":"IN06240000003","sub_total":"2201","grand_total":"2276","discount":"","status":"Accepted","is_cancelled":"","created_for":"Portage Ave","warehouse":"Alberta","remarks":"fsddfsdf","timestamp":"03-06-2024","items":[{"id":"9","order_id":"3","item_id":"511","item":"test-test 200","category_id":"32","category":"Chicken","base_price":"50.5","amount":"101","sku_code":"852741","unit":"kg","quantity":"2","timestamp":"1717405982"}]}]
/// message : "order details found"
/// success : 1
/// total_records : "2"

OrderListResponseModel orderListResponseModelFromJson(String str) => OrderListResponseModel.fromJson(json.decode(str));
String orderListResponseModelToJson(OrderListResponseModel data) => json.encode(data.toJson());
class OrderListResponseModel {
  OrderListResponseModel({
      List<OrderList>? orderList, 
      String? message, 
      num? success, 
      String? totalRecords,}){
    _orderList = orderList;
    _message = message;
    _success = success;
    _totalRecords = totalRecords;
}

  OrderListResponseModel.fromJson(dynamic json) {
    if (json['list'] != null) {
      _orderList = [];
      json['list'].forEach((v) {
        _orderList?.add(OrderList.fromJson(v));
      });
    }
    _message = json['message'];
    _success = json['success'];
    _totalRecords = json['total_records'];
  }
  List<OrderList>? _orderList;
  String? _message;
  num? _success;
  String? _totalRecords;
OrderListResponseModel copyWith({  List<OrderList>? orderList,
  String? message,
  num? success,
  String? totalRecords,
}) => OrderListResponseModel(  orderList: orderList ?? _orderList,
  message: message ?? _message,
  success: success ?? _success,
  totalRecords: totalRecords ?? _totalRecords,
);
  List<OrderList>? get orderList => _orderList;
  String? get message => _message;
  num? get success => _success;
  String? get totalRecords => _totalRecords;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_orderList != null) {
      map['list'] = _orderList?.map((v) => v.toJson()).toList();
    }
    map['message'] = _message;
    map['success'] = _success;
    map['total_records'] = _totalRecords;
    return map;
  }

}

/// id : "3"
/// order_number : "IN06240000003"
/// sub_total : "2201"
/// grand_total : "2276"
/// discount : ""
/// status : "Accepted"
/// is_cancelled : ""
/// created_for : "Portage Ave"
/// warehouse : "Alberta"
/// remarks : "fsddfsdf"
/// timestamp : "03-06-2024"
/// items : [{"id":"9","order_id":"3","item_id":"511","item":"test-test 200","category_id":"32","category":"Chicken","base_price":"50.5","amount":"101","sku_code":"852741","unit":"kg","quantity":"2","timestamp":"1717405982"}]

OrderList orderListFromJson(String str) => OrderList.fromJson(json.decode(str));
String orderListToJson(OrderList data) => json.encode(data.toJson());
class OrderList {
  OrderList({
      String? id, 
      String? orderNumber, 
      String? subTotal, 
      String? grandTotal, 
      String? discount, 
      String? status, 
      String? isCancelled, 
      String? createdFor, 
      String? warehouse, 
      String? remarks, 
      String? timestamp, 
      List<Items>? items,}){
    _id = id;
    _orderNumber = orderNumber;
    _subTotal = subTotal;
    _grandTotal = grandTotal;
    _discount = discount;
    _status = status;
    _isCancelled = isCancelled;
    _createdFor = createdFor;
    _warehouse = warehouse;
    _remarks = remarks;
    _timestamp = timestamp;
    _items = items;
}

  OrderList.fromJson(dynamic json) {
    _id = json['id'];
    _orderNumber = json['order_number'];
    _subTotal = json['sub_total'];
    _grandTotal = json['grand_total'];
    _discount = json['discount'];
    _status = json['status'];
    _isCancelled = json['is_cancelled'];
    _createdFor = json['created_for'];
    _warehouse = json['warehouse'];
    _remarks = json['remarks'];
    _timestamp = json['timestamp'];
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(Items.fromJson(v));
      });
    }
  }
  String? _id;
  String? _orderNumber;
  String? _subTotal;
  String? _grandTotal;
  String? _discount;
  String? _status;
  String? _isCancelled;
  String? _createdFor;
  String? _warehouse;
  String? _remarks;
  String? _timestamp;
  List<Items>? _items;
OrderList copyWith({  String? id,
  String? orderNumber,
  String? subTotal,
  String? grandTotal,
  String? discount,
  String? status,
  String? isCancelled,
  String? createdFor,
  String? warehouse,
  String? remarks,
  String? timestamp,
  List<Items>? items,
}) => OrderList(  id: id ?? _id,
  orderNumber: orderNumber ?? _orderNumber,
  subTotal: subTotal ?? _subTotal,
  grandTotal: grandTotal ?? _grandTotal,
  discount: discount ?? _discount,
  status: status ?? _status,
  isCancelled: isCancelled ?? _isCancelled,
  createdFor: createdFor ?? _createdFor,
  warehouse: warehouse ?? _warehouse,
  remarks: remarks ?? _remarks,
  timestamp: timestamp ?? _timestamp,
  items: items ?? _items,
);
  String? get id => _id;
  String? get orderNumber => _orderNumber;
  String? get subTotal => _subTotal;
  String? get grandTotal => _grandTotal;
  String? get discount => _discount;
  String? get status => _status;
  String? get isCancelled => _isCancelled;
  String? get createdFor => _createdFor;
  String? get warehouse => _warehouse;
  String? get remarks => _remarks;
  String? get timestamp => _timestamp;
  List<Items>? get items => _items;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['order_number'] = _orderNumber;
    map['sub_total'] = _subTotal;
    map['grand_total'] = _grandTotal;
    map['discount'] = _discount;
    map['status'] = _status;
    map['is_cancelled'] = _isCancelled;
    map['created_for'] = _createdFor;
    map['warehouse'] = _warehouse;
    map['remarks'] = _remarks;
    map['timestamp'] = _timestamp;
    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "9"
/// order_id : "3"
/// item_id : "511"
/// item : "test-test 200"
/// category_id : "32"
/// category : "Chicken"
/// base_price : "50.5"
/// amount : "101"
/// sku_code : "852741"
/// unit : "kg"
/// quantity : "2"
/// timestamp : "1717405982"

Items itemsFromJson(String str) => Items.fromJson(json.decode(str));
String itemsToJson(Items data) => json.encode(data.toJson());
class Items {
  Items({
      String? id, 
      String? orderId, 
      String? itemId, 
      String? item, 
      String? categoryId, 
      String? category, 
      String? basePrice, 
      String? amount, 
      String? skuCode, 
      String? unit, 
      String? quantity, 
      String? timestamp,}){
    _id = id;
    _orderId = orderId;
    _itemId = itemId;
    _item = item;
    _categoryId = categoryId;
    _category = category;
    _basePrice = basePrice;
    _amount = amount;
    _skuCode = skuCode;
    _unit = unit;
    _quantity = quantity;
    _timestamp = timestamp;
}

  Items.fromJson(dynamic json) {
    _id = json['id'];
    _orderId = json['order_id'];
    _itemId = json['item_id'];
    _item = json['item'];
    _categoryId = json['category_id'];
    _category = json['category'];
    _basePrice = json['base_price'];
    _amount = json['amount'];
    _skuCode = json['sku_code'];
    _unit = json['unit'];
    _quantity = json['quantity'];
    _timestamp = json['timestamp'];
  }
  String? _id;
  String? _orderId;
  String? _itemId;
  String? _item;
  String? _categoryId;
  String? _category;
  String? _basePrice;
  String? _amount;
  String? _skuCode;
  String? _unit;
  String? _quantity;
  String? _timestamp;
Items copyWith({  String? id,
  String? orderId,
  String? itemId,
  String? item,
  String? categoryId,
  String? category,
  String? basePrice,
  String? amount,
  String? skuCode,
  String? unit,
  String? quantity,
  String? timestamp,
}) => Items(  id: id ?? _id,
  orderId: orderId ?? _orderId,
  itemId: itemId ?? _itemId,
  item: item ?? _item,
  categoryId: categoryId ?? _categoryId,
  category: category ?? _category,
  basePrice: basePrice ?? _basePrice,
  amount: amount ?? _amount,
  skuCode: skuCode ?? _skuCode,
  unit: unit ?? _unit,
  quantity: quantity ?? _quantity,
  timestamp: timestamp ?? _timestamp,
);
  String? get id => _id;
  String? get orderId => _orderId;
  String? get itemId => _itemId;
  String? get item => _item;
  String? get categoryId => _categoryId;
  String? get category => _category;
  String? get basePrice => _basePrice;
  String? get amount => _amount;
  String? get skuCode => _skuCode;
  String? get unit => _unit;
  String? get quantity => _quantity;
  String? get timestamp => _timestamp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['order_id'] = _orderId;
    map['item_id'] = _itemId;
    map['item'] = _item;
    map['category_id'] = _categoryId;
    map['category'] = _category;
    map['base_price'] = _basePrice;
    map['amount'] = _amount;
    map['sku_code'] = _skuCode;
    map['unit'] = _unit;
    map['quantity'] = _quantity;
    map['timestamp'] = _timestamp;
    return map;
  }

}