import 'dart:convert';
/// record : {"id":"2","order_number":"IN06240000002","sub_total":"5855","grand_total":"5930","status":"Cancelled","created_for":"5","created_by":"5","remarks":"","timestamp":"03-06-2024","payment_status":"Pending","order_stages":[{"status_id":"2","order_id":"2","status":"Accepted","remarks":null,"timestamp":"03-06-2024 ,11:12 AM"},{"status_id":"3","order_id":"2","status":"Processed","remarks":"","timestamp":"03-06-2024 ,11:16 AM"},{"status_id":"7","order_id":"2","status":"Cancelled","remarks":"","timestamp":"03-06-2024 ,04:13 PM"}],"franchise_name":"Portage Ave","address_line_1":"1855a Portage Ave","address_line_2":"MB R3J 0G8","address_line_3":"","address_line_4":"","warehouse_name":"Alberta","ware_address_line_1":"21 adam street","ware_address_line_2":"","ware_address_line_3":"","ware_address_line_4":"","items_list":[{"category":"Chicken","items":[{"id":"5","order_id":"2","item_id":"502","item":"chicken-24","category_id":"32","category":"Chicken","base_price":"77","amount":"385","sku_code":"741258","unit":"pieces","quantity":"5","timestamp":"1717393328","image_name":null,"image":"https://chickendelight.saltpixels.in/api/assets/upload/items/default.png"},{"id":"6","order_id":"2","item_id":"503","item":"test -Variation","category_id":"32","category":"Chicken","base_price":"110","amount":"1430","sku_code":"skucode","unit":"kg","quantity":"13","timestamp":"1717393328","image_name":null,"image":"https://chickendelight.saltpixels.in/api/assets/upload/items/default.png"}]},{"category":"Food","items_category":[{"id":"7","order_id":"2","item_id":"504","item":"test-variation material","category_id":"1","category":"Food","base_price":"1010","amount":"4040","sku_code":"sku","unit":"lt","quantity":"4","timestamp":"1717393328","image_name":null,"image":"https://chickendelight.saltpixels.in/api/assets/upload/items/default.png"}]}]}
/// message : "order details found"
/// success : 1

OrderDetailResponseModel orderDetailResponseModelFromJson(String str) => OrderDetailResponseModel.fromJson(json.decode(str));
String orderDetailResponseModelToJson(OrderDetailResponseModel data) => json.encode(data.toJson());
class OrderDetailResponseModel {
  OrderDetailResponseModel({
      Record? record, 
      String? message, 
      num? success,}){
    _record = record;
    _message = message;
    _success = success;
}

  OrderDetailResponseModel.fromJson(dynamic json) {
    _record = json['record'] != null ? Record.fromJson(json['record']) : null;
    _message = json['message'];
    _success = json['success'];
  }
  Record? _record;
  String? _message;
  num? _success;
OrderDetailResponseModel copyWith({  Record? record,
  String? message,
  num? success,
}) => OrderDetailResponseModel(  record: record ?? _record,
  message: message ?? _message,
  success: success ?? _success,
);
  Record? get record => _record;
  String? get message => _message;
  num? get success => _success;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_record != null) {
      map['record'] = _record?.toJson();
    }
    map['message'] = _message;
    map['success'] = _success;
    return map;
  }

}

/// id : "2"
/// order_number : "IN06240000002"
/// sub_total : "5855"
/// grand_total : "5930"
/// status : "Cancelled"
/// created_for : "5"
/// created_by : "5"
/// remarks : ""
/// timestamp : "03-06-2024"
/// payment_status : "Pending"
/// order_stages : [{"status_id":"2","order_id":"2","status":"Accepted","remarks":null,"timestamp":"03-06-2024 ,11:12 AM"},{"status_id":"3","order_id":"2","status":"Processed","remarks":"","timestamp":"03-06-2024 ,11:16 AM"},{"status_id":"7","order_id":"2","status":"Cancelled","remarks":"","timestamp":"03-06-2024 ,04:13 PM"}]
/// franchise_name : "Portage Ave"
/// address_line_1 : "1855a Portage Ave"
/// address_line_2 : "MB R3J 0G8"
/// address_line_3 : ""
/// address_line_4 : ""
/// warehouse_name : "Alberta"
/// ware_address_line_1 : "21 adam street"
/// ware_address_line_2 : ""
/// ware_address_line_3 : ""
/// ware_address_line_4 : ""
/// items_list : [{"category":"Chicken","items":[{"id":"5","order_id":"2","item_id":"502","item":"chicken-24","category_id":"32","category":"Chicken","base_price":"77","amount":"385","sku_code":"741258","unit":"pieces","quantity":"5","timestamp":"1717393328","image_name":null,"image":"https://chickendelight.saltpixels.in/api/assets/upload/items/default.png"},{"id":"6","order_id":"2","item_id":"503","item":"test -Variation","category_id":"32","category":"Chicken","base_price":"110","amount":"1430","sku_code":"skucode","unit":"kg","quantity":"13","timestamp":"1717393328","image_name":null,"image":"https://chickendelight.saltpixels.in/api/assets/upload/items/default.png"}]},{"category":"Food","items_category":[{"id":"7","order_id":"2","item_id":"504","item":"test-variation material","category_id":"1","category":"Food","base_price":"1010","amount":"4040","sku_code":"sku","unit":"lt","quantity":"4","timestamp":"1717393328","image_name":null,"image":"https://chickendelight.saltpixels.in/api/assets/upload/items/default.png"}]}]

Record recordFromJson(String str) => Record.fromJson(json.decode(str));
String recordToJson(Record data) => json.encode(data.toJson());
class Record {
  Record({
      String? id, 
      String? orderNumber, 
      String? subTotal, 
      String? grandTotal, 
      String? status, 
      String? createdFor, 
      String? createdBy, 
      String? remarks, 
      String? timestamp, 
      String? paymentStatus, 
      List<OrderStages>? orderStages, 
      String? franchiseName, 
      String? addressLine1, 
      String? addressLine2, 
      String? addressLine3, 
      String? addressLine4, 
      String? warehouseName, 
      String? wareAddressLine1, 
      String? wareAddressLine2, 
      String? wareAddressLine3, 
      String? wareAddressLine4, 
      List<ItemsList>? itemsList,}){
    _id = id;
    _orderNumber = orderNumber;
    _subTotal = subTotal;
    _grandTotal = grandTotal;
    _status = status;
    _createdFor = createdFor;
    _createdBy = createdBy;
    _remarks = remarks;
    _timestamp = timestamp;
    _paymentStatus = paymentStatus;
    _orderStages = orderStages;
    _franchiseName = franchiseName;
    _addressLine1 = addressLine1;
    _addressLine2 = addressLine2;
    _addressLine3 = addressLine3;
    _addressLine4 = addressLine4;
    _warehouseName = warehouseName;
    _wareAddressLine1 = wareAddressLine1;
    _wareAddressLine2 = wareAddressLine2;
    _wareAddressLine3 = wareAddressLine3;
    _wareAddressLine4 = wareAddressLine4;
    _itemsList = itemsList;
}

  Record.fromJson(dynamic json) {
    _id = json['id'];
    _orderNumber = json['order_number'];
    _subTotal = json['sub_total'];
    _grandTotal = json['grand_total'];
    _status = json['status'];
    _createdFor = json['created_for'];
    _createdBy = json['created_by'];
    _remarks = json['remarks'];
    _timestamp = json['timestamp'];
    _paymentStatus = json['payment_status'];
    if (json['order_stages'] != null) {
      _orderStages = [];
      json['order_stages'].forEach((v) {
        _orderStages?.add(OrderStages.fromJson(v));
      });
    }
    _franchiseName = json['franchise_name'];
    _addressLine1 = json['address_line_1'];
    _addressLine2 = json['address_line_2'];
    _addressLine3 = json['address_line_3'];
    _addressLine4 = json['address_line_4'];
    _warehouseName = json['warehouse_name'];
    _wareAddressLine1 = json['ware_address_line_1'];
    _wareAddressLine2 = json['ware_address_line_2'];
    _wareAddressLine3 = json['ware_address_line_3'];
    _wareAddressLine4 = json['ware_address_line_4'];
    if (json['items'] != null) {
      _itemsList = [];
      json['items'].forEach((v) {
        _itemsList?.add(ItemsList.fromJson(v));
      });
    }
  }
  String? _id;
  String? _orderNumber;
  String? _subTotal;
  String? _grandTotal;
  String? _status;
  String? _createdFor;
  String? _createdBy;
  String? _remarks;
  String? _timestamp;
  String? _paymentStatus;
  List<OrderStages>? _orderStages;
  String? _franchiseName;
  String? _addressLine1;
  String? _addressLine2;
  String? _addressLine3;
  String? _addressLine4;
  String? _warehouseName;
  String? _wareAddressLine1;
  String? _wareAddressLine2;
  String? _wareAddressLine3;
  String? _wareAddressLine4;
  List<ItemsList>? _itemsList;
Record copyWith({  String? id,
  String? orderNumber,
  String? subTotal,
  String? grandTotal,
  String? status,
  String? createdFor,
  String? createdBy,
  String? remarks,
  String? timestamp,
  String? paymentStatus,
  List<OrderStages>? orderStages,
  String? franchiseName,
  String? addressLine1,
  String? addressLine2,
  String? addressLine3,
  String? addressLine4,
  String? warehouseName,
  String? wareAddressLine1,
  String? wareAddressLine2,
  String? wareAddressLine3,
  String? wareAddressLine4,
  List<ItemsList>? itemsList,
}) => Record(  id: id ?? _id,
  orderNumber: orderNumber ?? _orderNumber,
  subTotal: subTotal ?? _subTotal,
  grandTotal: grandTotal ?? _grandTotal,
  status: status ?? _status,
  createdFor: createdFor ?? _createdFor,
  createdBy: createdBy ?? _createdBy,
  remarks: remarks ?? _remarks,
  timestamp: timestamp ?? _timestamp,
  paymentStatus: paymentStatus ?? _paymentStatus,
  orderStages: orderStages ?? _orderStages,
  franchiseName: franchiseName ?? _franchiseName,
  addressLine1: addressLine1 ?? _addressLine1,
  addressLine2: addressLine2 ?? _addressLine2,
  addressLine3: addressLine3 ?? _addressLine3,
  addressLine4: addressLine4 ?? _addressLine4,
  warehouseName: warehouseName ?? _warehouseName,
  wareAddressLine1: wareAddressLine1 ?? _wareAddressLine1,
  wareAddressLine2: wareAddressLine2 ?? _wareAddressLine2,
  wareAddressLine3: wareAddressLine3 ?? _wareAddressLine3,
  wareAddressLine4: wareAddressLine4 ?? _wareAddressLine4,
  itemsList: itemsList ?? _itemsList,
);
  String? get id => _id;
  String? get orderNumber => _orderNumber;
  String? get subTotal => _subTotal;
  String? get grandTotal => _grandTotal;
  String? get status => _status;
  String? get createdFor => _createdFor;
  String? get createdBy => _createdBy;
  String? get remarks => _remarks;
  String? get timestamp => _timestamp;
  String? get paymentStatus => _paymentStatus;
  List<OrderStages>? get orderStages => _orderStages;
  String? get franchiseName => _franchiseName;
  String? get addressLine1 => _addressLine1;
  String? get addressLine2 => _addressLine2;
  String? get addressLine3 => _addressLine3;
  String? get addressLine4 => _addressLine4;
  String? get warehouseName => _warehouseName;
  String? get wareAddressLine1 => _wareAddressLine1;
  String? get wareAddressLine2 => _wareAddressLine2;
  String? get wareAddressLine3 => _wareAddressLine3;
  String? get wareAddressLine4 => _wareAddressLine4;
  List<ItemsList>? get itemsList => _itemsList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['order_number'] = _orderNumber;
    map['sub_total'] = _subTotal;
    map['grand_total'] = _grandTotal;
    map['status'] = _status;
    map['created_for'] = _createdFor;
    map['created_by'] = _createdBy;
    map['remarks'] = _remarks;
    map['timestamp'] = _timestamp;
    map['payment_status'] = _paymentStatus;
    if (_orderStages != null) {
      map['order_stages'] = _orderStages?.map((v) => v.toJson()).toList();
    }
    map['franchise_name'] = _franchiseName;
    map['address_line_1'] = _addressLine1;
    map['address_line_2'] = _addressLine2;
    map['address_line_3'] = _addressLine3;
    map['address_line_4'] = _addressLine4;
    map['warehouse_name'] = _warehouseName;
    map['ware_address_line_1'] = _wareAddressLine1;
    map['ware_address_line_2'] = _wareAddressLine2;
    map['ware_address_line_3'] = _wareAddressLine3;
    map['ware_address_line_4'] = _wareAddressLine4;
    if (_itemsList != null) {
      map['items_list'] = _itemsList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// category : "Chicken"
/// items : [{"id":"5","order_id":"2","item_id":"502","item":"chicken-24","category_id":"32","category":"Chicken","base_price":"77","amount":"385","sku_code":"741258","unit":"pieces","quantity":"5","timestamp":"1717393328","image_name":null,"image":"https://chickendelight.saltpixels.in/api/assets/upload/items/default.png"},{"id":"6","order_id":"2","item_id":"503","item":"test -Variation","category_id":"32","category":"Chicken","base_price":"110","amount":"1430","sku_code":"skucode","unit":"kg","quantity":"13","timestamp":"1717393328","image_name":null,"image":"https://chickendelight.saltpixels.in/api/assets/upload/items/default.png"}]

ItemsList itemsListFromJson(String str) => ItemsList.fromJson(json.decode(str));
String itemsListToJson(ItemsList data) => json.encode(data.toJson());
class ItemsList {
  ItemsList({
      String? category, 
      List<Items>? items,}){
    _category = category;
    _items = items;
}

  ItemsList.fromJson(dynamic json) {
    _category = json['category'];
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(Items.fromJson(v));
      });
    }
  }
  String? _category;
  List<Items>? _items;
ItemsList copyWith({  String? category,
  List<Items>? items,
}) => ItemsList(  category: category ?? _category,
  items: items ?? _items,
);
  String? get category => _category;
  List<Items>? get items => _items;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['category'] = _category;
    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "5"
/// order_id : "2"
/// item_id : "502"
/// item : "chicken-24"
/// category_id : "32"
/// category : "Chicken"
/// base_price : "77"
/// amount : "385"
/// sku_code : "741258"
/// unit : "pieces"
/// quantity : "5"
/// timestamp : "1717393328"
/// image_name : null
/// image : "https://chickendelight.saltpixels.in/api/assets/upload/items/default.png"

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
      String? timestamp, 
      dynamic imageName, 
      String? image,}){
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
    _imageName = imageName;
    _image = image;
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
    _imageName = json['image_name'];
    _image = json['image'];
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
  dynamic _imageName;
  String? _image;
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
  dynamic imageName,
  String? image,
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
  imageName: imageName ?? _imageName,
  image: image ?? _image,
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
  dynamic get imageName => _imageName;
  String? get image => _image;

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
    map['image_name'] = _imageName;
    map['image'] = _image;
    return map;
  }

}

/// status_id : "2"
/// order_id : "2"
/// status : "Accepted"
/// remarks : null
/// timestamp : "03-06-2024 ,11:12 AM"

OrderStages orderStagesFromJson(String str) => OrderStages.fromJson(json.decode(str));
String orderStagesToJson(OrderStages data) => json.encode(data.toJson());
class OrderStages {
  OrderStages({
      String? statusId, 
      String? orderId, 
      String? status, 
      dynamic remarks, 
      String? timestamp,}){
    _statusId = statusId;
    _orderId = orderId;
    _status = status;
    _remarks = remarks;
    _timestamp = timestamp;
}

  OrderStages.fromJson(dynamic json) {
    _statusId = json['status_id'];
    _orderId = json['order_id'];
    _status = json['status'];
    _remarks = json['remarks'];
    _timestamp = json['timestamp'];
  }
  String? _statusId;
  String? _orderId;
  String? _status;
  dynamic _remarks;
  String? _timestamp;
OrderStages copyWith({  String? statusId,
  String? orderId,
  String? status,
  dynamic remarks,
  String? timestamp,
}) => OrderStages(  statusId: statusId ?? _statusId,
  orderId: orderId ?? _orderId,
  status: status ?? _status,
  remarks: remarks ?? _remarks,
  timestamp: timestamp ?? _timestamp,
);
  String? get statusId => _statusId;
  String? get orderId => _orderId;
  String? get status => _status;
  dynamic get remarks => _remarks;
  String? get timestamp => _timestamp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status_id'] = _statusId;
    map['order_id'] = _orderId;
    map['status'] = _status;
    map['remarks'] = _remarks;
    map['timestamp'] = _timestamp;
    return map;
  }

}