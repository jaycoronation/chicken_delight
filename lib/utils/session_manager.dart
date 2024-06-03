import 'dart:convert';

import 'app_utils.dart';
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
  final String userId = "user_id";
  final String firstName = "first_name";
  final String lastName = "last_name";
  final String email = "email";
  final String mobileNumber = "contact_no";
  final String isManagerLogin = "is_manager_login";
  final String userName = "username";
  final String dateOfBirth = "date_of_birth";
  final String token = "token";
  final String isManager = "isManager";
  final String isDeviceRegister = "isDeviceRegister";
  final String empId = "emp_id";
  final String userType = "userType";
  final String appVersion = "appVersion";
  final String isDataFatchedFromServer = "isDataFatchedFromServer";
  final String KEY_FIELD_WORK = "FieldWork";

  //For
  final String KEY_STK_DONE = "isSTKREntryDone";
  final String KEY_PERMISSION_SALES_UPDATE = "salesUpdate";
  final String KEY_PERMISSION_SALES_UPDATE_REPORT = "salesUpdateReport";
  final String KEY_PERMISSION_SAMPLE_UPDATE = "sampleUpdate";
  final String KEY_PERMISSION_SAMPLE_UPDATE_REPORT = "sampleUpdateReport";
  final String KEY_MAKE_STK = "canUserMakeSTKEntry";
  final String KEY_DAILYWORK = "keyDailyWork";
  final String KEY_DAY_END = "dayEnd";
  final String KEY_TERRITORY_CODE = "unisonTerritoryCode";
  final String KEY_TERRITORY_DATA = "unisonTerritoryData";
  final String ADD_AREA_TP = "addAreaForTP";
  final String ONLY_SALES_PRODUCT = "onlySalesProduct";


  //set data into shared preferences...
  Future createLoginSession(String apiUserId,String apiUserName,String apiFirstName,String apiLastName,
      String apiEmail,String apiMobileNumber,String apiDateOfBirth,String apiToken,bool apiIsManager,String apiUserType) async {
    await SessionManagerMethods.setBool(isLoggedIn, true);
    await SessionManagerMethods.setString(userId,apiUserId);
    await SessionManagerMethods.setString(userName,apiUserName);
    await SessionManagerMethods.setString(firstName,apiFirstName);
    await SessionManagerMethods.setString(lastName,apiLastName);
    await SessionManagerMethods.setString(email,apiEmail);
    await SessionManagerMethods.setString(mobileNumber, apiMobileNumber);
    await SessionManagerMethods.setString(dateOfBirth, apiDateOfBirth);
    await SessionManagerMethods.setString(token, apiToken);
    await SessionManagerMethods.setBool(isManager, apiIsManager);
    await SessionManagerMethods.setString(userType, apiUserType);

  }

  bool? checkIsLoggedIn() {
    return SessionManagerMethods.getBool(isLoggedIn);
  }

  Future<void> setIsLoggedIn(bool apiIsLoggedIn)
  async {
    await SessionManagerMethods.setBool(isLoggedIn, apiIsLoggedIn);
  }

  bool? isDataFetched() {
    return SessionManagerMethods.getBool(isDataFatchedFromServer);
  }

  Future<void> setIsDataFetched(bool apiIsDataFetched)
  async {
    await SessionManagerMethods.setBool(isDataFatchedFromServer, apiIsDataFetched);
  }

  Future<void> setAppVersion(String apiAppVersion)
  async {
    await SessionManagerMethods.setString(appVersion, apiAppVersion);
  }

  String? getAppVersion() {
    return SessionManagerMethods.getString(appVersion);
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

  Future<void> setLastName(String apiFirstName)
  async {
    await SessionManagerMethods.setString(lastName, apiFirstName);
  }

  String? getLastName() {
    return SessionManagerMethods.getString(lastName);
  }

  Future<void> setEmail(String apiEmail)
  async {
    await SessionManagerMethods.setString(email, apiEmail);
  }

  String? getEmail() {
    return SessionManagerMethods.getString(email);
  }

  Future<void> setPhone(String apiMobileNumber)
  async {
    await SessionManagerMethods.setString(mobileNumber, apiMobileNumber);
  }

  String? getPhone() {
    return SessionManagerMethods.getString(mobileNumber);
  }

  Future<void> setIsDeviceRegistered(bool apiIsDeviceRegistered)
  async {
    await SessionManagerMethods.setBool(isDeviceRegister, apiIsDeviceRegistered);
  }

  bool? getIsDeviceRegistered() {
    return SessionManagerMethods.getBool(isDeviceRegister);
  }


  Future<void> setAccessToken(String value)
  async {
    await SessionManagerMethods.setString(token, value);
  }

  String? getAccessToken() {
    return SessionManagerMethods.getString(token);
  }


  Future<void> setEmpId(String value)
  async {
    await SessionManagerMethods.setString(empId, value);
  }

  String? getEmpId() {
    return SessionManagerMethods.getString(empId);
  }

  Future<void> setUserType(String value)
  async {
    await SessionManagerMethods.setString(userType, value);
  }

  String? getUserType() {
    return SessionManagerMethods.getString(userType);
  }

  Future<void> setSalesPermission(String value)
  async {
    await SessionManagerMethods.setString(KEY_PERMISSION_SALES_UPDATE, value);
  }

  String? getSalesPermission() {
    return SessionManagerMethods.getString(KEY_PERMISSION_SALES_UPDATE);
  }

  Future<void> setSalesReportPermission(String value)
  async {
    await SessionManagerMethods.setString(KEY_PERMISSION_SALES_UPDATE_REPORT, value);
  }

  String? getSalesReportPermission() {
    return SessionManagerMethods.getString(KEY_PERMISSION_SALES_UPDATE_REPORT);
  }

  Future<void> setSamplePermission(String value)
  async {
    await SessionManagerMethods.setString(KEY_PERMISSION_SAMPLE_UPDATE, value);
  }

  String? getSamplePermission() {
    return SessionManagerMethods.getString(KEY_PERMISSION_SAMPLE_UPDATE);
  }

  Future<void> setSampleReportPermission(String value)
  async {
    await SessionManagerMethods.setString(KEY_PERMISSION_SAMPLE_UPDATE_REPORT, value);
  }

  String? getSampleReportPermission() {
    return SessionManagerMethods.getString(KEY_PERMISSION_SAMPLE_UPDATE_REPORT);
  }

  Future<void> setCanSTK(String value)
  async {
    await SessionManagerMethods.setString(KEY_MAKE_STK, value);
  }

  String? getCanSTK() {
    return SessionManagerMethods.getString(KEY_MAKE_STK);
  }

  Future<void> setOffDayOrAdminDay(String value)
  async {
    await SessionManagerMethods.setString(KEY_DAILYWORK, value);
  }

  String? getOffDayOrAdminDay() {
    return SessionManagerMethods.getString(KEY_DAILYWORK);
  }

  Future<void> setDayEnd(String value)
  async {
    await SessionManagerMethods.setString(KEY_DAY_END, value);
  }

  String? getDayEnd() {
    return SessionManagerMethods.getString(KEY_DAY_END);
  }

  Future<void> setTerritoryCode(String value)
  async {
    await SessionManagerMethods.setString(KEY_TERRITORY_CODE, value);
  }

  String? getTerritoryCode() {
    return SessionManagerMethods.getString(KEY_TERRITORY_CODE);
  }

  Future<void> setFieldWork(String value)
  async {
    await SessionManagerMethods.setString(KEY_FIELD_WORK, value);
  }

  String? getFieldWork() {
    return SessionManagerMethods.getString(KEY_FIELD_WORK);
  }

  bool? getIsSTKDone() {
    return SessionManagerMethods.getBool(KEY_STK_DONE);
  }


  Future<void> setIsSTKDone(bool apiIsLoggedIn)
  async {
    await SessionManagerMethods.setBool(KEY_STK_DONE, apiIsLoggedIn);
  }


}