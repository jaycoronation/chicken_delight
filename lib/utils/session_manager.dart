

import 'session_manager_methods.dart';

class SessionManager {
  /*
  "id": "12",
        "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjEyIiwiQVBJX1RJTUUiOjE3MTc0ODY0ODN9.GHA_QmyuE9K-s2LI8oMMIUWeZ7cMpafzZtHPteps_T0",
        "type": "2",
        "name": "John Doe",
        "profile_picture": "http://192.168.1.91/chicken_delight/api/assets/upload/admin/1717427821_100_3685.JPG"
*/
  final String isLoggedIn = "isLoggedIn";
  final String userId = "id";
  final String token = "token";
  final String type = "type";
  final String name = "name";
  final String profilePicture = "profile_picture";


  bool? checkIsLoggedIn() {
    return SessionManagerMethods.getBool(isLoggedIn);
  }
  Future<void> setIsLoggedIn(bool apiIsLoggedIn)
  async {
    await SessionManagerMethods.setBool(isLoggedIn, apiIsLoggedIn);
  }

  //set data into shared preferences...
  Future createLoginSession(String apiUserId, String apiToken, String apiType, String apiName, String apiProfilePicture) async {
    await SessionManagerMethods.setBool(isLoggedIn, true);
    await SessionManagerMethods.setString(userId,apiUserId);
    await SessionManagerMethods.setString(token,apiToken);
    await SessionManagerMethods.setString(type,apiType);
    await SessionManagerMethods.setString(name, apiName);
    await SessionManagerMethods.setString(profilePicture, apiProfilePicture);
  }

  Future<void> setUserId(String apiUserId)
  async {
    await SessionManagerMethods.setString(userId, apiUserId);
  }

  String? getUserId() {
    return SessionManagerMethods.getString(userId);
  }

  Future<void> setToken(String apiToken)
  async {
    await SessionManagerMethods.setString(token, apiToken);
  }

  String? getToken() {
    return SessionManagerMethods.getString(token);
  }

  Future<void> setType(String apiType)
  async {
    await SessionManagerMethods.setString(type, apiType);
  }

  String? getType() {
    return SessionManagerMethods.getString(type);
  }

  Future<void> setName(String apiName)
  async {
    await SessionManagerMethods.setString(name, apiName);
  }

  String? getName() {
    return SessionManagerMethods.getString(name);
  }

  Future<void> setProfilePicture(String apiProfilePicture)
  async {
    await SessionManagerMethods.setString(profilePicture, apiProfilePicture);
  }

  String? getImagePic() {
    return SessionManagerMethods.getString(profilePicture);
  }

  final String unreadNotificationCount = "unread_notification_count";
  Future<void> setUnreadNotificationCount(int apiUnreadNotificationCount)
  async {
    await SessionManagerMethods.setInt(unreadNotificationCount, apiUnreadNotificationCount);
  }

  int? getUnreadNotificationCount() {
    return SessionManagerMethods.getInt(unreadNotificationCount);
  }


}