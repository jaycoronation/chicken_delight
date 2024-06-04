

import 'session_manager_methods.dart';

class SessionManager {
  /*
  "user_id": "18",
  "name": "Jay Mistry",
  "email": "jay.m@coronation.in",
  "phone": "7433036724",
  "dob": "04 Jun 2018",
  "referral_code": "YQB427",
  "has_login_pin": true,
  "image": "https://apis.roboadviso.com/assets/uploads/profiles/profile_1626788768_98.jpg"
*/
  final String isLoggedIn = "isLoggedIn";
  final String userId = "id";
  final String firstName = "name";
  final String profile_pic = "profile";
  final String token = "token";


  bool? checkIsLoggedIn() {
    return SessionManagerMethods.getBool(isLoggedIn);
  }
  Future<void> setIsLoggedIn(bool apiIsLoggedIn)
  async {
    await SessionManagerMethods.setBool(isLoggedIn, apiIsLoggedIn);
  }

  //set data into shared preferences...
  Future createLoginSession(String apiUserId,String apiFirstName , String apiProfile_pic, String apiToken, ) async {
    await SessionManagerMethods.setBool(isLoggedIn, true);
    await SessionManagerMethods.setString(userId,apiUserId);
    await SessionManagerMethods.setString(firstName,apiFirstName);
    await SessionManagerMethods.setString(profile_pic, apiProfile_pic);
    await SessionManagerMethods.setString(token, apiToken);
  }


  Future<void> setToken(String apiToken)
  async {
    await SessionManagerMethods.setString(token, apiToken);
  }

  String? getToken() {
    return SessionManagerMethods.getString(token);
  }


  Future<void> setUserId(String apiUserId)
  async {
    await SessionManagerMethods.setString(userId, apiUserId);
  }

  String? getUserId() {
    return SessionManagerMethods.getString(userId);
  }

  Future<void> setName(String apiFirstName)
  async {
    await SessionManagerMethods.setString(firstName, apiFirstName);
  }

  String? getName() {
    return SessionManagerMethods.getString(firstName);
  }

  Future<void> setImage(String apiImage)
  async {
    await SessionManagerMethods.setString(profile_pic, apiImage);
  }

  String? getImagePic() {
    return SessionManagerMethods.getString(profile_pic);
  }


}