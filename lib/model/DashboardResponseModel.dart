import 'dart:convert';
/// dashboard_records : {"id":"12","name":"John Doe","address_line_1":"1855a Portage Ave","address_line_2":"MB R3J 0G8","address_line_3":"New Road","address_line_4":"Near Highway","country_id":"39","state_id":"868","city_id":"16441","mobile":"9825589659","email":"john@chickendelight.com","business_name":"Portage Ave","website":"www.chickendelight.com","country_code":"1","total_overdue":14895,"upcoming_payments":1267,"due_today":1267,"today_order_count":"1","today_order_value":105,"last_seven_count":"49","last_seven_value":15414.979999999998,"last_thirty_count":"52","last_thirty_value":17413.379999999994,"order":[{"id":"64","order_number":"IN06240000064","grand_total":"105","sub_total":"30","discount":"","status":"Accepted","timestamp":"1718304957","is_cancelled":"","payment_status":"Pending","payment_date":"","created_for":"12","created_by":"12","warehouse":"0","remarks":""}],"total_orders":"52","total_value":17413.379999999997,"profile_picture":"https://chickendelight.saltpixels.in/api/assets/upload/admin/1717427821_100_3685.JPG","business_logo":"https://chickendelight.saltpixels.in/api/assets/upload/admin/user.png","total_notifications":30}
/// success : 1
/// message : "franchise details found"

DashboardResponseModel dashboardResponseModelFromJson(String str) => DashboardResponseModel.fromJson(json.decode(str));
String dashboardResponseModelToJson(DashboardResponseModel data) => json.encode(data.toJson());
class DashboardResponseModel {
  DashboardResponseModel({
      DashboardRecords? dashboardRecords, 
      num? success, 
      String? message,}){
    _dashboardRecords = dashboardRecords;
    _success = success;
    _message = message;
}

  DashboardResponseModel.fromJson(dynamic json) {
    _dashboardRecords = json['records'] != null ? DashboardRecords.fromJson(json['records']) : null;
    _success = json['success'];
    _message = json['message'];
  }
  DashboardRecords? _dashboardRecords;
  num? _success;
  String? _message;
DashboardResponseModel copyWith({  DashboardRecords? dashboardRecords,
  num? success,
  String? message,
}) => DashboardResponseModel(  dashboardRecords: dashboardRecords ?? _dashboardRecords,
  success: success ?? _success,
  message: message ?? _message,
);
  DashboardRecords? get dashboardRecords => _dashboardRecords;
  num? get success => _success;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_dashboardRecords != null) {
      map['records'] = _dashboardRecords?.toJson();
    }
    map['success'] = _success;
    map['message'] = _message;
    return map;
  }

}

/// id : "12"
/// name : "John Doe"
/// address_line_1 : "1855a Portage Ave"
/// address_line_2 : "MB R3J 0G8"
/// address_line_3 : "New Road"
/// address_line_4 : "Near Highway"
/// country_id : "39"
/// state_id : "868"
/// city_id : "16441"
/// mobile : "9825589659"
/// email : "john@chickendelight.com"
/// business_name : "Portage Ave"
/// website : "www.chickendelight.com"
/// country_code : "1"
/// total_overdue : 14895
/// upcoming_payments : 1267
/// due_today : 1267
/// today_order_count : "1"
/// today_order_value : 105
/// last_seven_count : "49"
/// last_seven_value : 15414.979999999998
/// last_thirty_count : "52"
/// last_thirty_value : 17413.379999999994
/// order : [{"id":"64","order_number":"IN06240000064","grand_total":"105","sub_total":"30","discount":"","status":"Accepted","timestamp":"1718304957","is_cancelled":"","payment_status":"Pending","payment_date":"","created_for":"12","created_by":"12","warehouse":"0","remarks":""}]
/// total_orders : "52"
/// total_value : 17413.379999999997
/// profile_picture : "https://chickendelight.saltpixels.in/api/assets/upload/admin/1717427821_100_3685.JPG"
/// business_logo : "https://chickendelight.saltpixels.in/api/assets/upload/admin/user.png"
/// total_notifications : 30

DashboardRecords dashboardRecordsFromJson(String str) => DashboardRecords.fromJson(json.decode(str));
String dashboardRecordsToJson(DashboardRecords data) => json.encode(data.toJson());
class DashboardRecords {
  DashboardRecords({
      String? id, 
      String? name, 
      String? addressLine1, 
      String? addressLine2, 
      String? addressLine3, 
      String? addressLine4, 
      String? countryId, 
      String? stateId, 
      String? cityId, 
      String? mobile, 
      String? email, 
      String? businessName, 
      String? website, 
      String? countryCode, 
      num? totalOverdue, 
      num? upcomingPayments, 
      num? dueToday, 
      String? todayOrderCount, 
      num? todayOrderValue, 
      String? lastSevenCount, 
      num? lastSevenValue, 
      String? lastThirtyCount, 
      num? lastThirtyValue, 
      List<Order>? order, 
      String? totalOrders, 
      num? totalValue, 
      String? profilePicture, 
      String? businessLogo, 
      num? totalNotifications,}){
    _id = id;
    _name = name;
    _addressLine1 = addressLine1;
    _addressLine2 = addressLine2;
    _addressLine3 = addressLine3;
    _addressLine4 = addressLine4;
    _countryId = countryId;
    _stateId = stateId;
    _cityId = cityId;
    _mobile = mobile;
    _email = email;
    _businessName = businessName;
    _website = website;
    _countryCode = countryCode;
    _totalOverdue = totalOverdue;
    _upcomingPayments = upcomingPayments;
    _dueToday = dueToday;
    _todayOrderCount = todayOrderCount;
    _todayOrderValue = todayOrderValue;
    _lastSevenCount = lastSevenCount;
    _lastSevenValue = lastSevenValue;
    _lastThirtyCount = lastThirtyCount;
    _lastThirtyValue = lastThirtyValue;
    _order = order;
    _totalOrders = totalOrders;
    _totalValue = totalValue;
    _profilePicture = profilePicture;
    _businessLogo = businessLogo;
    _totalNotifications = totalNotifications;
}

  DashboardRecords.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _addressLine1 = json['address_line_1'];
    _addressLine2 = json['address_line_2'];
    _addressLine3 = json['address_line_3'];
    _addressLine4 = json['address_line_4'];
    _countryId = json['country_id'];
    _stateId = json['state_id'];
    _cityId = json['city_id'];
    _mobile = json['mobile'];
    _email = json['email'];
    _businessName = json['business_name'];
    _website = json['website'];
    _countryCode = json['country_code'];
    _totalOverdue = json['total_overdue'];
    _upcomingPayments = json['upcoming_payments'];
    _dueToday = json['due_today'];
    _todayOrderCount = json['today_order_count'];
    _todayOrderValue = json['today_order_value'];
    _lastSevenCount = json['last_seven_count'];
    _lastSevenValue = json['last_seven_value'];
    _lastThirtyCount = json['last_thirty_count'];
    _lastThirtyValue = json['last_thirty_value'];
    if (json['order'] != null) {
      _order = [];
      json['order'].forEach((v) {
        _order?.add(Order.fromJson(v));
      });
    }
    _totalOrders = json['total_orders'];
    _totalValue = json['total_value'];
    _profilePicture = json['profile_picture'];
    _businessLogo = json['business_logo'];
    _totalNotifications = json['total_notifications'];
  }
  String? _id;
  String? _name;
  String? _addressLine1;
  String? _addressLine2;
  String? _addressLine3;
  String? _addressLine4;
  String? _countryId;
  String? _stateId;
  String? _cityId;
  String? _mobile;
  String? _email;
  String? _businessName;
  String? _website;
  String? _countryCode;
  num? _totalOverdue;
  num? _upcomingPayments;
  num? _dueToday;
  String? _todayOrderCount;
  num? _todayOrderValue;
  String? _lastSevenCount;
  num? _lastSevenValue;
  String? _lastThirtyCount;
  num? _lastThirtyValue;
  List<Order>? _order;
  String? _totalOrders;
  num? _totalValue;
  String? _profilePicture;
  String? _businessLogo;
  num? _totalNotifications;
DashboardRecords copyWith({  String? id,
  String? name,
  String? addressLine1,
  String? addressLine2,
  String? addressLine3,
  String? addressLine4,
  String? countryId,
  String? stateId,
  String? cityId,
  String? mobile,
  String? email,
  String? businessName,
  String? website,
  String? countryCode,
  num? totalOverdue,
  num? upcomingPayments,
  num? dueToday,
  String? todayOrderCount,
  num? todayOrderValue,
  String? lastSevenCount,
  num? lastSevenValue,
  String? lastThirtyCount,
  num? lastThirtyValue,
  List<Order>? order,
  String? totalOrders,
  num? totalValue,
  String? profilePicture,
  String? businessLogo,
  num? totalNotifications,
}) => DashboardRecords(  id: id ?? _id,
  name: name ?? _name,
  addressLine1: addressLine1 ?? _addressLine1,
  addressLine2: addressLine2 ?? _addressLine2,
  addressLine3: addressLine3 ?? _addressLine3,
  addressLine4: addressLine4 ?? _addressLine4,
  countryId: countryId ?? _countryId,
  stateId: stateId ?? _stateId,
  cityId: cityId ?? _cityId,
  mobile: mobile ?? _mobile,
  email: email ?? _email,
  businessName: businessName ?? _businessName,
  website: website ?? _website,
  countryCode: countryCode ?? _countryCode,
  totalOverdue: totalOverdue ?? _totalOverdue,
  upcomingPayments: upcomingPayments ?? _upcomingPayments,
  dueToday: dueToday ?? _dueToday,
  todayOrderCount: todayOrderCount ?? _todayOrderCount,
  todayOrderValue: todayOrderValue ?? _todayOrderValue,
  lastSevenCount: lastSevenCount ?? _lastSevenCount,
  lastSevenValue: lastSevenValue ?? _lastSevenValue,
  lastThirtyCount: lastThirtyCount ?? _lastThirtyCount,
  lastThirtyValue: lastThirtyValue ?? _lastThirtyValue,
  order: order ?? _order,
  totalOrders: totalOrders ?? _totalOrders,
  totalValue: totalValue ?? _totalValue,
  profilePicture: profilePicture ?? _profilePicture,
  businessLogo: businessLogo ?? _businessLogo,
  totalNotifications: totalNotifications ?? _totalNotifications,
);
  String? get id => _id;
  String? get name => _name;
  String? get addressLine1 => _addressLine1;
  String? get addressLine2 => _addressLine2;
  String? get addressLine3 => _addressLine3;
  String? get addressLine4 => _addressLine4;
  String? get countryId => _countryId;
  String? get stateId => _stateId;
  String? get cityId => _cityId;
  String? get mobile => _mobile;
  String? get email => _email;
  String? get businessName => _businessName;
  String? get website => _website;
  String? get countryCode => _countryCode;
  num? get totalOverdue => _totalOverdue;
  num? get upcomingPayments => _upcomingPayments;
  num? get dueToday => _dueToday;
  String? get todayOrderCount => _todayOrderCount;
  num? get todayOrderValue => _todayOrderValue;
  String? get lastSevenCount => _lastSevenCount;
  num? get lastSevenValue => _lastSevenValue;
  String? get lastThirtyCount => _lastThirtyCount;
  num? get lastThirtyValue => _lastThirtyValue;
  List<Order>? get order => _order;
  String? get totalOrders => _totalOrders;
  num? get totalValue => _totalValue;
  String? get profilePicture => _profilePicture;
  String? get businessLogo => _businessLogo;
  num? get totalNotifications => _totalNotifications;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['address_line_1'] = _addressLine1;
    map['address_line_2'] = _addressLine2;
    map['address_line_3'] = _addressLine3;
    map['address_line_4'] = _addressLine4;
    map['country_id'] = _countryId;
    map['state_id'] = _stateId;
    map['city_id'] = _cityId;
    map['mobile'] = _mobile;
    map['email'] = _email;
    map['business_name'] = _businessName;
    map['website'] = _website;
    map['country_code'] = _countryCode;
    map['total_overdue'] = _totalOverdue;
    map['upcoming_payments'] = _upcomingPayments;
    map['due_today'] = _dueToday;
    map['today_order_count'] = _todayOrderCount;
    map['today_order_value'] = _todayOrderValue;
    map['last_seven_count'] = _lastSevenCount;
    map['last_seven_value'] = _lastSevenValue;
    map['last_thirty_count'] = _lastThirtyCount;
    map['last_thirty_value'] = _lastThirtyValue;
    if (_order != null) {
      map['order'] = _order?.map((v) => v.toJson()).toList();
    }
    map['total_orders'] = _totalOrders;
    map['total_value'] = _totalValue;
    map['profile_picture'] = _profilePicture;
    map['business_logo'] = _businessLogo;
    map['total_notifications'] = _totalNotifications;
    return map;
  }

}

/// id : "64"
/// order_number : "IN06240000064"
/// grand_total : "105"
/// sub_total : "30"
/// discount : ""
/// status : "Accepted"
/// timestamp : "1718304957"
/// is_cancelled : ""
/// payment_status : "Pending"
/// payment_date : ""
/// created_for : "12"
/// created_by : "12"
/// warehouse : "0"
/// remarks : ""

Order orderFromJson(String str) => Order.fromJson(json.decode(str));
String orderToJson(Order data) => json.encode(data.toJson());
class Order {
  Order({
      String? id, 
      String? orderNumber, 
      String? grandTotal, 
      String? subTotal, 
      String? discount, 
      String? status, 
      String? timestamp, 
      String? isCancelled, 
      String? paymentStatus, 
      String? paymentDate, 
      String? createdFor, 
      String? createdBy, 
      String? warehouse, 
      String? remarks,}){
    _id = id;
    _orderNumber = orderNumber;
    _grandTotal = grandTotal;
    _subTotal = subTotal;
    _discount = discount;
    _status = status;
    _timestamp = timestamp;
    _isCancelled = isCancelled;
    _paymentStatus = paymentStatus;
    _paymentDate = paymentDate;
    _createdFor = createdFor;
    _createdBy = createdBy;
    _warehouse = warehouse;
    _remarks = remarks;
}

  Order.fromJson(dynamic json) {
    _id = json['id'];
    _orderNumber = json['order_number'];
    _grandTotal = json['grand_total'];
    _subTotal = json['sub_total'];
    _discount = json['discount'];
    _status = json['status'];
    _timestamp = json['timestamp'];
    _isCancelled = json['is_cancelled'];
    _paymentStatus = json['payment_status'];
    _paymentDate = json['payment_date'];
    _createdFor = json['created_for'];
    _createdBy = json['created_by'];
    _warehouse = json['warehouse'];
    _remarks = json['remarks'];
  }
  String? _id;
  String? _orderNumber;
  String? _grandTotal;
  String? _subTotal;
  String? _discount;
  String? _status;
  String? _timestamp;
  String? _isCancelled;
  String? _paymentStatus;
  String? _paymentDate;
  String? _createdFor;
  String? _createdBy;
  String? _warehouse;
  String? _remarks;
Order copyWith({  String? id,
  String? orderNumber,
  String? grandTotal,
  String? subTotal,
  String? discount,
  String? status,
  String? timestamp,
  String? isCancelled,
  String? paymentStatus,
  String? paymentDate,
  String? createdFor,
  String? createdBy,
  String? warehouse,
  String? remarks,
}) => Order(  id: id ?? _id,
  orderNumber: orderNumber ?? _orderNumber,
  grandTotal: grandTotal ?? _grandTotal,
  subTotal: subTotal ?? _subTotal,
  discount: discount ?? _discount,
  status: status ?? _status,
  timestamp: timestamp ?? _timestamp,
  isCancelled: isCancelled ?? _isCancelled,
  paymentStatus: paymentStatus ?? _paymentStatus,
  paymentDate: paymentDate ?? _paymentDate,
  createdFor: createdFor ?? _createdFor,
  createdBy: createdBy ?? _createdBy,
  warehouse: warehouse ?? _warehouse,
  remarks: remarks ?? _remarks,
);
  String? get id => _id;
  String? get orderNumber => _orderNumber;
  String? get grandTotal => _grandTotal;
  String? get subTotal => _subTotal;
  String? get discount => _discount;
  String? get status => _status;
  String? get timestamp => _timestamp;
  String? get isCancelled => _isCancelled;
  String? get paymentStatus => _paymentStatus;
  String? get paymentDate => _paymentDate;
  String? get createdFor => _createdFor;
  String? get createdBy => _createdBy;
  String? get warehouse => _warehouse;
  String? get remarks => _remarks;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['order_number'] = _orderNumber;
    map['grand_total'] = _grandTotal;
    map['sub_total'] = _subTotal;
    map['discount'] = _discount;
    map['status'] = _status;
    map['timestamp'] = _timestamp;
    map['is_cancelled'] = _isCancelled;
    map['payment_status'] = _paymentStatus;
    map['payment_date'] = _paymentDate;
    map['created_for'] = _createdFor;
    map['created_by'] = _createdBy;
    map['warehouse'] = _warehouse;
    map['remarks'] = _remarks;
    return map;
  }

}