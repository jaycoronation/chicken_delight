import 'dart:convert';
/// notification_records : [{"id":"3","title":"Order Update","message":"Good news! Your order #IN06240000024 has been processed successfully. We are preparing it for shipment.","link":"24","timestamp":"09:06 PM"},{"id":"4","title":"Order Delivered","message":"Your order #IN06240000024 has been delivered. We hope you enjoy your purchase!","link":"24","timestamp":"09:07 PM"}]
/// message : "notifications found"
/// success : 1
/// total_records : "2"

NotificationsResponseModel notificationsResponseModelFromJson(String str) => NotificationsResponseModel.fromJson(json.decode(str));
String notificationsResponseModelToJson(NotificationsResponseModel data) => json.encode(data.toJson());
class NotificationsResponseModel {
  NotificationsResponseModel({
      List<NotificationRecords>? notificationRecords, 
      String? message, 
      num? success, 
      String? totalRecords,}){
    _notificationRecords = notificationRecords;
    _message = message;
    _success = success;
    _totalRecords = totalRecords;
}

  NotificationsResponseModel.fromJson(dynamic json) {
    if (json['records'] != null) {
      _notificationRecords = [];
      json['records'].forEach((v) {
        _notificationRecords?.add(NotificationRecords.fromJson(v));
      });
    }
    _message = json['message'];
    _success = json['success'];
    _totalRecords = json['total_records'];
  }
  List<NotificationRecords>? _notificationRecords;
  String? _message;
  num? _success;
  String? _totalRecords;
NotificationsResponseModel copyWith({  List<NotificationRecords>? notificationRecords,
  String? message,
  num? success,
  String? totalRecords,
}) => NotificationsResponseModel(  notificationRecords: notificationRecords ?? _notificationRecords,
  message: message ?? _message,
  success: success ?? _success,
  totalRecords: totalRecords ?? _totalRecords,
);
  List<NotificationRecords>? get notificationRecords => _notificationRecords;
  String? get message => _message;
  num? get success => _success;
  String? get totalRecords => _totalRecords;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_notificationRecords != null) {
      map['records'] = _notificationRecords?.map((v) => v.toJson()).toList();
    }
    map['message'] = _message;
    map['success'] = _success;
    map['total_records'] = _totalRecords;
    return map;
  }

}

/// id : "3"
/// title : "Order Update"
/// message : "Good news! Your order #IN06240000024 has been processed successfully. We are preparing it for shipment."
/// link : "24"
/// timestamp : "09:06 PM"

NotificationRecords notificationRecordsFromJson(String str) => NotificationRecords.fromJson(json.decode(str));
String notificationRecordsToJson(NotificationRecords data) => json.encode(data.toJson());
class NotificationRecords {
  NotificationRecords({
      String? id, 
      String? title, 
      String? message, 
      String? link, 
      String? timestamp,
    String? readTimestamp,}){
    _id = id;
    _title = title;
    _message = message;
    _link = link;
    _timestamp = timestamp;
    _readTimestamp = readTimestamp;
}

  NotificationRecords.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _message = json['message'];
    _link = json['link'];
    _timestamp = json['timestamp'];
    _readTimestamp = json['read_timestamp'];
  }
  String? _id;
  String? _title;
  String? _message;
  String? _link;
  String? _timestamp;
  String? _readTimestamp;
NotificationRecords copyWith({  String? id,
  String? title,
  String? message,
  String? link,
  String? timestamp,
  String? readTimestamp,
}) => NotificationRecords(  id: id ?? _id,
  title: title ?? _title,
  message: message ?? _message,
  link: link ?? _link,
  timestamp: timestamp ?? _timestamp,
  readTimestamp: readTimestamp ?? _readTimestamp,
);
  String? get id => _id;
  String? get title => _title;
  String? get message => _message;
  String? get link => _link;
  String? get timestamp => _timestamp;
  String? get readTimestamp => _readTimestamp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['message'] = _message;
    map['link'] = _link;
    map['timestamp'] = _timestamp;
    map['read_timestamp'] = _readTimestamp;
    return map;
  }

}