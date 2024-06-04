/// success : 1
/// message : "Your account has been created. Will be verify and active."

class CommonResponseModel {
  CommonResponseModel({
    int? success,
    String? message,
    bool? isSelected,
  }){
    _success = success;
    _message = message;
    _isSelected = isSelected;

  }

  CommonResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _isSelected = json['isSelected'];

  }
  int? _success = 0;
  String? _message = "";
  bool? _isSelected = false;

  CommonResponseModel copyWith({  int? success,
    String? message,
    bool? isSelected,
  }) => CommonResponseModel(  success: success ?? _success,
    message: message ?? _message,
    isSelected: isSelected ?? _isSelected,
  );
  int? get success => _success;
  String? get message => _message;

  set success(int? value) {
    _success = value;
  }

  bool? get isSelected => _isSelected;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    map['isSelected'] = _isSelected;

    return map;
  }

  set message(String? value) {
    _message = value;
  }

  set isSelected(bool? value) {
    _isSelected = value;
  }
}