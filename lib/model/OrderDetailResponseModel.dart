import 'dart:convert';
/// order_detail_record : {"id":"41","order_number":"IN06240000041","sub_total":"55","grand_total":"55","status":"Processed","created_for":"12","created_by":"6","remarks":"","repeat_date":"","timestamp":"Jun 18, 2024 10:51 AM","date":"Jun 18, 2024","payment_status":"Pending","order_stages":[{"status_id":"77","order_id":"41","status":"Processed","remarks":"","timestamp":"Jun 18, 2024, 11:00 AM"}],"franchise_name":"Duo Enterprises Ltd.","address_line_1":"1329 MCPHILLIPS ST.","address_line_2":"WINNIPEG MB","address_line_3":"","address_line_4":"","shipping_charge":"1","franchise_email":"CDelight@shaw.ca","franchise_mobile":"2049821385","country":"Canada","state_id":"867","city_id":"17215","state":"Manitoba","city":"Winnipeg","warehouse_name":"Saskatchewan","ware_address_line_1":"Nipawin River Inn","ware_address_line_2":"101 Centre","ware_address_line_3":"St SK S0E 1E0","ware_address_line_4":"","selecteditems":[{"id":"90","item_id":"8","variation_id":"8","item":"chicken wings-24","base_price":"27.5","sale_price":"27.5","unit":"pieces","amount":"55","quantity":"2","sku_code":"4564561","category_id":"33","category":"Chicken","stock":131,"icon":"https://chickendelight.saltpixels.in/api/assets/upload/items/default.png"}],"total_items":"1","items_main_list":[{"category":"Chicken","items_inner_list":[{"id":"90","order_id":"41","item_id":"8","item":"chicken wings-24","category_id":"33","category":"Chicken","base_price":"27.5","amount":"55","sku_code":"4564561","unit":"pieces","quantity":"2","timestamp":"1718725898","stock":131,"image":"https://chickendelight.saltpixels.in/api/assets/upload/items/default.png"}]}]}
/// message : "order details found"
/// success : 1

OrderDetailResponseModel orderDetailResponseModelFromJson(String str) => OrderDetailResponseModel.fromJson(json.decode(str));
String orderDetailResponseModelToJson(OrderDetailResponseModel data) => json.encode(data.toJson());
class OrderDetailResponseModel {
  OrderDetailResponseModel({
      OrderDetailRecord? orderDetailRecord, 
      String? message, 
      num? success,}){
    _orderDetailRecord = orderDetailRecord;
    _message = message;
    _success = success;
}

  OrderDetailResponseModel.fromJson(dynamic json) {
    _orderDetailRecord = json['record'] != null ? OrderDetailRecord.fromJson(json['record']) : null;
    _message = json['message'];
    _success = json['success'];
  }
  OrderDetailRecord? _orderDetailRecord;
  String? _message;
  num? _success;
OrderDetailResponseModel copyWith({  OrderDetailRecord? orderDetailRecord,
  String? message,
  num? success,
}) => OrderDetailResponseModel(  orderDetailRecord: orderDetailRecord ?? _orderDetailRecord,
  message: message ?? _message,
  success: success ?? _success,
);
  OrderDetailRecord? get orderDetailRecord => _orderDetailRecord;
  String? get message => _message;
  num? get success => _success;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_orderDetailRecord != null) {
      map['record'] = _orderDetailRecord?.toJson();
    }
    map['message'] = _message;
    map['success'] = _success;
    return map;
  }

}

/// id : "41"
/// order_number : "IN06240000041"
/// sub_total : "55"
/// grand_total : "55"
/// status : "Processed"
/// created_for : "12"
/// created_by : "6"
/// remarks : ""
/// repeat_date : ""
/// timestamp : "Jun 18, 2024 10:51 AM"
/// date : "Jun 18, 2024"
/// payment_status : "Pending"
/// order_stages : [{"status_id":"77","order_id":"41","status":"Processed","remarks":"","timestamp":"Jun 18, 2024, 11:00 AM"}]
/// franchise_name : "Duo Enterprises Ltd."
/// address_line_1 : "1329 MCPHILLIPS ST."
/// address_line_2 : "WINNIPEG MB"
/// address_line_3 : ""
/// address_line_4 : ""
/// shipping_charge : "1"
/// franchise_email : "CDelight@shaw.ca"
/// franchise_mobile : "2049821385"
/// country : "Canada"
/// state_id : "867"
/// city_id : "17215"
/// state : "Manitoba"
/// city : "Winnipeg"
/// warehouse_name : "Saskatchewan"
/// ware_address_line_1 : "Nipawin River Inn"
/// ware_address_line_2 : "101 Centre"
/// ware_address_line_3 : "St SK S0E 1E0"
/// ware_address_line_4 : ""
/// selecteditems : [{"id":"90","item_id":"8","variation_id":"8","item":"chicken wings-24","base_price":"27.5","sale_price":"27.5","unit":"pieces","amount":"55","quantity":"2","sku_code":"4564561","category_id":"33","category":"Chicken","stock":131,"icon":"https://chickendelight.saltpixels.in/api/assets/upload/items/default.png"}]
/// total_items : "1"
/// items_main_list : [{"category":"Chicken","items_inner_list":[{"id":"90","order_id":"41","item_id":"8","item":"chicken wings-24","category_id":"33","category":"Chicken","base_price":"27.5","amount":"55","sku_code":"4564561","unit":"pieces","quantity":"2","timestamp":"1718725898","stock":131,"image":"https://chickendelight.saltpixels.in/api/assets/upload/items/default.png"}]}]

OrderDetailRecord orderDetailRecordFromJson(String str) => OrderDetailRecord.fromJson(json.decode(str));
String orderDetailRecordToJson(OrderDetailRecord data) => json.encode(data.toJson());
class OrderDetailRecord {
  OrderDetailRecord({
      String? id, 
      String? orderNumber, 
      String? subTotal, 
      String? grandTotal, 
      String? status, 
      String? createdFor, 
      String? createdBy, 
      String? remarks, 
      String? repeatDate, 
      String? timestamp, 
      String? date, 
      String? paymentStatus, 
      List<OrderStages>? orderStages, 
      String? franchiseName, 
      String? addressLine1, 
      String? addressLine2, 
      String? addressLine3, 
      String? addressLine4, 
      String? shippingCharge, 
      String? franchiseEmail, 
      String? franchiseMobile, 
      String? country, 
      String? stateId, 
      String? cityId, 
      String? state, 
      String? city, 
      String? warehouseName, 
      String? wareAddressLine1, 
      String? wareAddressLine2, 
      String? wareAddressLine3, 
      String? wareAddressLine4, 
      List<Selecteditems>? selecteditems, 
      String? totalItems, 
      List<ItemsMainList>? itemsMainList,}){
    _id = id;
    _orderNumber = orderNumber;
    _subTotal = subTotal;
    _grandTotal = grandTotal;
    _status = status;
    _createdFor = createdFor;
    _createdBy = createdBy;
    _remarks = remarks;
    _repeatDate = repeatDate;
    _timestamp = timestamp;
    _date = date;
    _paymentStatus = paymentStatus;
    _orderStages = orderStages;
    _franchiseName = franchiseName;
    _addressLine1 = addressLine1;
    _addressLine2 = addressLine2;
    _addressLine3 = addressLine3;
    _addressLine4 = addressLine4;
    _shippingCharge = shippingCharge;
    _franchiseEmail = franchiseEmail;
    _franchiseMobile = franchiseMobile;
    _country = country;
    _stateId = stateId;
    _cityId = cityId;
    _state = state;
    _city = city;
    _warehouseName = warehouseName;
    _wareAddressLine1 = wareAddressLine1;
    _wareAddressLine2 = wareAddressLine2;
    _wareAddressLine3 = wareAddressLine3;
    _wareAddressLine4 = wareAddressLine4;
    _selecteditems = selecteditems;
    _totalItems = totalItems;
    _itemsMainList = itemsMainList;
}

  OrderDetailRecord.fromJson(dynamic json) {
    _id = json['id'];
    _orderNumber = json['order_number'];
    _subTotal = json['sub_total'];
    _grandTotal = json['grand_total'];
    _status = json['status'];
    _createdFor = json['created_for'];
    _createdBy = json['created_by'];
    _remarks = json['remarks'];
    _repeatDate = json['repeat_date'];
    _timestamp = json['timestamp'];
    _date = json['date'];
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
    _shippingCharge = json['shipping_charge'];
    _franchiseEmail = json['franchise_email'];
    _franchiseMobile = json['franchise_mobile'];
    _country = json['country'];
    _stateId = json['state_id'];
    _cityId = json['city_id'];
    _state = json['state'];
    _city = json['city'];
    _warehouseName = json['warehouse_name'];
    _wareAddressLine1 = json['ware_address_line_1'];
    _wareAddressLine2 = json['ware_address_line_2'];
    _wareAddressLine3 = json['ware_address_line_3'];
    _wareAddressLine4 = json['ware_address_line_4'];
    if (json['selecteditems'] != null) {
      _selecteditems = [];
      json['selecteditems'].forEach((v) {
        _selecteditems?.add(Selecteditems.fromJson(v));
      });
    }
    _totalItems = json['total_items'];
    if (json['items'] != null) {
      _itemsMainList = [];
      json['items'].forEach((v) {
        _itemsMainList?.add(ItemsMainList.fromJson(v));
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
  String? _repeatDate;
  String? _timestamp;
  String? _date;
  String? _paymentStatus;
  List<OrderStages>? _orderStages;
  String? _franchiseName;
  String? _addressLine1;
  String? _addressLine2;
  String? _addressLine3;
  String? _addressLine4;
  String? _shippingCharge;
  String? _franchiseEmail;
  String? _franchiseMobile;
  String? _country;
  String? _stateId;
  String? _cityId;
  String? _state;
  String? _city;
  String? _warehouseName;
  String? _wareAddressLine1;
  String? _wareAddressLine2;
  String? _wareAddressLine3;
  String? _wareAddressLine4;
  List<Selecteditems>? _selecteditems;
  String? _totalItems;
  List<ItemsMainList>? _itemsMainList;
OrderDetailRecord copyWith({  String? id,
  String? orderNumber,
  String? subTotal,
  String? grandTotal,
  String? status,
  String? createdFor,
  String? createdBy,
  String? remarks,
  String? repeatDate,
  String? timestamp,
  String? date,
  String? paymentStatus,
  List<OrderStages>? orderStages,
  String? franchiseName,
  String? addressLine1,
  String? addressLine2,
  String? addressLine3,
  String? addressLine4,
  String? shippingCharge,
  String? franchiseEmail,
  String? franchiseMobile,
  String? country,
  String? stateId,
  String? cityId,
  String? state,
  String? city,
  String? warehouseName,
  String? wareAddressLine1,
  String? wareAddressLine2,
  String? wareAddressLine3,
  String? wareAddressLine4,
  List<Selecteditems>? selecteditems,
  String? totalItems,
  List<ItemsMainList>? itemsMainList,
}) => OrderDetailRecord(  id: id ?? _id,
  orderNumber: orderNumber ?? _orderNumber,
  subTotal: subTotal ?? _subTotal,
  grandTotal: grandTotal ?? _grandTotal,
  status: status ?? _status,
  createdFor: createdFor ?? _createdFor,
  createdBy: createdBy ?? _createdBy,
  remarks: remarks ?? _remarks,
  repeatDate: repeatDate ?? _repeatDate,
  timestamp: timestamp ?? _timestamp,
  date: date ?? _date,
  paymentStatus: paymentStatus ?? _paymentStatus,
  orderStages: orderStages ?? _orderStages,
  franchiseName: franchiseName ?? _franchiseName,
  addressLine1: addressLine1 ?? _addressLine1,
  addressLine2: addressLine2 ?? _addressLine2,
  addressLine3: addressLine3 ?? _addressLine3,
  addressLine4: addressLine4 ?? _addressLine4,
  shippingCharge: shippingCharge ?? _shippingCharge,
  franchiseEmail: franchiseEmail ?? _franchiseEmail,
  franchiseMobile: franchiseMobile ?? _franchiseMobile,
  country: country ?? _country,
  stateId: stateId ?? _stateId,
  cityId: cityId ?? _cityId,
  state: state ?? _state,
  city: city ?? _city,
  warehouseName: warehouseName ?? _warehouseName,
  wareAddressLine1: wareAddressLine1 ?? _wareAddressLine1,
  wareAddressLine2: wareAddressLine2 ?? _wareAddressLine2,
  wareAddressLine3: wareAddressLine3 ?? _wareAddressLine3,
  wareAddressLine4: wareAddressLine4 ?? _wareAddressLine4,
  selecteditems: selecteditems ?? _selecteditems,
  totalItems: totalItems ?? _totalItems,
  itemsMainList: itemsMainList ?? _itemsMainList,
);
  String? get id => _id;
  String? get orderNumber => _orderNumber;
  String? get subTotal => _subTotal;
  String? get grandTotal => _grandTotal;
  String? get status => _status;
  String? get createdFor => _createdFor;
  String? get createdBy => _createdBy;
  String? get remarks => _remarks;
  String? get repeatDate => _repeatDate;
  String? get timestamp => _timestamp;
  String? get date => _date;
  String? get paymentStatus => _paymentStatus;
  List<OrderStages>? get orderStages => _orderStages;
  String? get franchiseName => _franchiseName;
  String? get addressLine1 => _addressLine1;
  String? get addressLine2 => _addressLine2;
  String? get addressLine3 => _addressLine3;
  String? get addressLine4 => _addressLine4;
  String? get shippingCharge => _shippingCharge;
  String? get franchiseEmail => _franchiseEmail;
  String? get franchiseMobile => _franchiseMobile;
  String? get country => _country;
  String? get stateId => _stateId;
  String? get cityId => _cityId;
  String? get state => _state;
  String? get city => _city;
  String? get warehouseName => _warehouseName;
  String? get wareAddressLine1 => _wareAddressLine1;
  String? get wareAddressLine2 => _wareAddressLine2;
  String? get wareAddressLine3 => _wareAddressLine3;
  String? get wareAddressLine4 => _wareAddressLine4;
  List<Selecteditems>? get selecteditems => _selecteditems;
  String? get totalItems => _totalItems;
  List<ItemsMainList>? get itemsMainList => _itemsMainList;

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
    map['repeat_date'] = _repeatDate;
    map['timestamp'] = _timestamp;
    map['date'] = _date;
    map['payment_status'] = _paymentStatus;
    if (_orderStages != null) {
      map['order_stages'] = _orderStages?.map((v) => v.toJson()).toList();
    }
    map['franchise_name'] = _franchiseName;
    map['address_line_1'] = _addressLine1;
    map['address_line_2'] = _addressLine2;
    map['address_line_3'] = _addressLine3;
    map['address_line_4'] = _addressLine4;
    map['shipping_charge'] = _shippingCharge;
    map['franchise_email'] = _franchiseEmail;
    map['franchise_mobile'] = _franchiseMobile;
    map['country'] = _country;
    map['state_id'] = _stateId;
    map['city_id'] = _cityId;
    map['state'] = _state;
    map['city'] = _city;
    map['warehouse_name'] = _warehouseName;
    map['ware_address_line_1'] = _wareAddressLine1;
    map['ware_address_line_2'] = _wareAddressLine2;
    map['ware_address_line_3'] = _wareAddressLine3;
    map['ware_address_line_4'] = _wareAddressLine4;
    if (_selecteditems != null) {
      map['selecteditems'] = _selecteditems?.map((v) => v.toJson()).toList();
    }
    map['total_items'] = _totalItems;
    if (_itemsMainList != null) {
      map['items'] = _itemsMainList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// category : "Chicken"
/// items_inner_list : [{"id":"90","order_id":"41","item_id":"8","item":"chicken wings-24","category_id":"33","category":"Chicken","base_price":"27.5","amount":"55","sku_code":"4564561","unit":"pieces","quantity":"2","timestamp":"1718725898","stock":131,"image":"https://chickendelight.saltpixels.in/api/assets/upload/items/default.png"}]

ItemsMainList itemsMainListFromJson(String str) => ItemsMainList.fromJson(json.decode(str));
String itemsMainListToJson(ItemsMainList data) => json.encode(data.toJson());
class ItemsMainList {
  ItemsMainList({
      String? category, 
      List<ItemsInnerList>? itemsInnerList,}){
    _category = category;
    _itemsInnerList = itemsInnerList;
}

  ItemsMainList.fromJson(dynamic json) {
    _category = json['category'];
    if (json['items'] != null) {
      _itemsInnerList = [];
      json['items'].forEach((v) {
        _itemsInnerList?.add(ItemsInnerList.fromJson(v));
      });
    }
  }
  String? _category;
  List<ItemsInnerList>? _itemsInnerList;
ItemsMainList copyWith({  String? category,
  List<ItemsInnerList>? itemsInnerList,
}) => ItemsMainList(  category: category ?? _category,
  itemsInnerList: itemsInnerList ?? _itemsInnerList,
);
  String? get category => _category;
  List<ItemsInnerList>? get itemsInnerList => _itemsInnerList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['category'] = _category;
    if (_itemsInnerList != null) {
      map['items'] = _itemsInnerList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "90"
/// order_id : "41"
/// item_id : "8"
/// item : "chicken wings-24"
/// category_id : "33"
/// category : "Chicken"
/// base_price : "27.5"
/// amount : "55"
/// sku_code : "4564561"
/// unit : "pieces"
/// quantity : "2"
/// timestamp : "1718725898"
/// stock : 131
/// image : "https://chickendelight.saltpixels.in/api/assets/upload/items/default.png"

ItemsInnerList itemsInnerListFromJson(String str) => ItemsInnerList.fromJson(json.decode(str));
String itemsInnerListToJson(ItemsInnerList data) => json.encode(data.toJson());
class ItemsInnerList {
  ItemsInnerList({
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
      num? stock, 
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
    _stock = stock;
    _image = image;
}

  ItemsInnerList.fromJson(dynamic json) {
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
    _stock = json['stock'];
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
  num? _stock;
  String? _image;
ItemsInnerList copyWith({  String? id,
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
  num? stock,
  String? image,
}) => ItemsInnerList(  id: id ?? _id,
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
  stock: stock ?? _stock,
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
  num? get stock => _stock;
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
    map['stock'] = _stock;
    map['image'] = _image;
    return map;
  }

}

/// id : "90"
/// item_id : "8"
/// variation_id : "8"
/// item : "chicken wings-24"
/// base_price : "27.5"
/// sale_price : "27.5"
/// unit : "pieces"
/// amount : "55"
/// quantity : "2"
/// sku_code : "4564561"
/// category_id : "33"
/// category : "Chicken"
/// stock : 131
/// icon : "https://chickendelight.saltpixels.in/api/assets/upload/items/default.png"

Selecteditems selecteditemsFromJson(String str) => Selecteditems.fromJson(json.decode(str));
String selecteditemsToJson(Selecteditems data) => json.encode(data.toJson());
class Selecteditems {
  Selecteditems({
      String? id, 
      String? itemId, 
      String? variationId, 
      String? item, 
      String? basePrice, 
      String? salePrice, 
      String? unit, 
      String? amount, 
      String? quantity, 
      String? skuCode, 
      String? categoryId, 
      String? category, 
      num? stock, 
      String? icon,}){
    _id = id;
    _itemId = itemId;
    _variationId = variationId;
    _item = item;
    _basePrice = basePrice;
    _salePrice = salePrice;
    _unit = unit;
    _amount = amount;
    _quantity = quantity;
    _skuCode = skuCode;
    _categoryId = categoryId;
    _category = category;
    _stock = stock;
    _icon = icon;
}

  Selecteditems.fromJson(dynamic json) {
    _id = json['id'];
    _itemId = json['item_id'];
    _variationId = json['variation_id'];
    _item = json['item'];
    _basePrice = json['base_price'];
    _salePrice = json['sale_price'];
    _unit = json['unit'];
    _amount = json['amount'];
    _quantity = json['quantity'];
    _skuCode = json['sku_code'];
    _categoryId = json['category_id'];
    _category = json['category'];
    _stock = json['stock'];
    _icon = json['icon'];
  }
  String? _id;
  String? _itemId;
  String? _variationId;
  String? _item;
  String? _basePrice;
  String? _salePrice;
  String? _unit;
  String? _amount;
  String? _quantity;
  String? _skuCode;
  String? _categoryId;
  String? _category;
  num? _stock;
  String? _icon;
Selecteditems copyWith({  String? id,
  String? itemId,
  String? variationId,
  String? item,
  String? basePrice,
  String? salePrice,
  String? unit,
  String? amount,
  String? quantity,
  String? skuCode,
  String? categoryId,
  String? category,
  num? stock,
  String? icon,
}) => Selecteditems(  id: id ?? _id,
  itemId: itemId ?? _itemId,
  variationId: variationId ?? _variationId,
  item: item ?? _item,
  basePrice: basePrice ?? _basePrice,
  salePrice: salePrice ?? _salePrice,
  unit: unit ?? _unit,
  amount: amount ?? _amount,
  quantity: quantity ?? _quantity,
  skuCode: skuCode ?? _skuCode,
  categoryId: categoryId ?? _categoryId,
  category: category ?? _category,
  stock: stock ?? _stock,
  icon: icon ?? _icon,
);
  String? get id => _id;
  String? get itemId => _itemId;
  String? get variationId => _variationId;
  String? get item => _item;
  String? get basePrice => _basePrice;
  String? get salePrice => _salePrice;
  String? get unit => _unit;
  String? get amount => _amount;
  String? get quantity => _quantity;
  String? get skuCode => _skuCode;
  String? get categoryId => _categoryId;
  String? get category => _category;
  num? get stock => _stock;
  String? get icon => _icon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['item_id'] = _itemId;
    map['variation_id'] = _variationId;
    map['item'] = _item;
    map['base_price'] = _basePrice;
    map['sale_price'] = _salePrice;
    map['unit'] = _unit;
    map['amount'] = _amount;
    map['quantity'] = _quantity;
    map['sku_code'] = _skuCode;
    map['category_id'] = _categoryId;
    map['category'] = _category;
    map['stock'] = _stock;
    map['icon'] = _icon;
    return map;
  }

}

/// status_id : "77"
/// order_id : "41"
/// status : "Processed"
/// remarks : ""
/// timestamp : "Jun 18, 2024, 11:00 AM"

OrderStages orderStagesFromJson(String str) => OrderStages.fromJson(json.decode(str));
String orderStagesToJson(OrderStages data) => json.encode(data.toJson());
class OrderStages {
  OrderStages({
      String? statusId, 
      String? orderId, 
      String? status, 
      String? remarks, 
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
  String? _remarks;
  String? _timestamp;
OrderStages copyWith({  String? statusId,
  String? orderId,
  String? status,
  String? remarks,
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
  String? get remarks => _remarks;
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