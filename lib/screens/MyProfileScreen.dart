import 'dart:convert';
import 'dart:io';

import 'package:chicken_delight/model/GetProfileResponseModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import '../common_widget/common_widget.dart';
import '../constant/ApiService.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/CityResponseModel.dart';
import '../model/CountryResponseModel.dart';
import '../model/StateResponseModel.dart';
import '../model/common/CommonResponseModel.dart';
import '../utils/app_utils.dart';
import '../utils/base_class.dart';
import '../widget/no_data_new.dart';
import 'package:http/http.dart' as http;


class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  BaseState<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends BaseState<MyProfileScreen> {
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController addressLine1Controller = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();
  TextEditingController addressLine3Controller = TextEditingController();
  TextEditingController addressLine4Controller = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController countrySearchController = TextEditingController();
  TextEditingController stateSearchController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController citySearchController = TextEditingController();
  List<Countries> listCountrySearch = [];
  List<States> listStateSearch = [];
  List<Cities> listCitySearch = [];
  List<Countries> _countryList = [];
  List<States> _stateList = [];
  List<Cities> _cityList = [];
  String countryId = "";
  String stateId = "";
  String cityId = "";
  String pickImgPath = "";
  File profilePicFile = File("");
  File logoFile = File("");
  String profilePic = "";
  String logoPic = "";

  Profile profileData = Profile();


  @override
  void initState() {
    ApiService.fetchData().then((response) {
      var data = response as CommonResponseModel;
      if (data.success == 1)
      {
      }
      else
      {
        invalidTokenRedirection(context);
      }
    });

    super.initState();
    _getProfile();
  }

  void setData() {
    if (profileData.profilePicture != null)
    {
      if (profileData.profilePicture!.isNotEmpty)
      {
        profilePic = profileData.profilePicture ?? "";
      }
      else
      {
        profilePic = sessionManager.getImagePic() ?? "";
      }
    }
    else
    {
      profilePic = sessionManager.getImagePic() ?? "";
    }

    nameController.text = profileData.name ?? "";
    userNameController.text = profileData.username ?? "";
    emailController.text = profileData.email ?? "";
    mobileController.text = profileData.mobile ?? "";
    businessNameController.text = profileData.businessName ?? "";
    websiteController.text = profileData.website ?? "";
    addressLine1Controller.text = profileData.addressLine1 ?? "";
    addressLine2Controller.text = profileData.addressLine2 ?? "";
    addressLine3Controller.text = profileData.addressLine3 ?? "";
    addressLine4Controller.text = profileData.addressLine4 ?? "";

    logoPic = profileData.businessLogo ?? "";

    countryId = profileData.countryId ?? "";
    stateId = profileData.stateId ?? "";
    cityId = profileData.cityId ?? "";

    _getCountry();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if(didPop){
          return;
        }
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: chicken_bg,
        appBar:AppBar(
          toolbarHeight: kToolbarHeight,
          automaticallyImplyLeading: false,
          title: getTitle("Profile"),
          leading: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pop(context);
              },
              child:getBackArrowBlack()
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: chicken_bg,
        ),
        body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kContainerCornerRadius),
                color: white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(22),
                  Center(
                    child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          _showBottomSheetForImagePicker("Profile Pic");
                        },
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            profilePicFile.path.isNotEmpty
                                ? Container(
                                width: 120,
                                height: 120,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(color: black, width: 1),
                                    shape: BoxShape.circle
                                ),
                                child: ClipOval(
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(120), // Image radius
                                    child: Image.file(profilePicFile, fit: BoxFit.cover,width: 120, height: 120,),
                                  ),
                                )
                            )
                                : Container(
                                width: 120,
                                height: 120,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(color: black, width: 1),
                                    shape: BoxShape.circle
                                ),
                                child: profilePic.isEmpty
                                    ? Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Image.asset('assets/images/ic_user.png',fit: BoxFit.cover,color: black,),
                                )
                                    : ClipOval(
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(120), // Image radius
                                    child: Image.network(profilePic, fit: BoxFit.cover,width: 120, height: 120,),
                                  ),
                                )
                            ),
                            Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.all(Radius.circular(16),),
                                ),
                                child: Image.asset('assets/images/ic_edit.png',height: 14,width: 14, fit: BoxFit.contain,)
                            ),
                          ],)),
                  ),
                  const Gap(22),
                  TextField(
                    readOnly: false,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    cursorColor: black,
                    controller: nameController,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: subTitle,
                      color: black,
                    ),
                    decoration: InputDecoration(
                      // fillColor: grayForDetail,
                      // filled: true,
                      labelText: 'Name',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 14 ),
                      counterText: "",
                      labelStyle:  TextStyle(fontSize: description, color:gray_dark),
                    ),
                  ),
                  const Gap(16),
                  TextField(
                    readOnly: true,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    cursorColor: black,
                    controller: userNameController,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: subTitle,
                      color: black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'User Name',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 14 ),
                      counterText: "",
                      labelStyle:  TextStyle(fontSize: description, color:gray_dark),
                    ),
                  ),
                  const Gap(16),
                  TextField(
                    readOnly: true,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    cursorColor: black,
                    controller:emailController,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: subTitle,
                      color: black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 14 ),
                      counterText: "",
                      labelStyle:  TextStyle(fontSize: description, color:gray_dark),
                    ),
                  ),
                  const Gap(16),
                  TextField(
                    readOnly: false,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    cursorColor: black,
                    maxLength: 10,
                    controller:mobileController,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: subTitle,
                      color: black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Mobile Number',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 14),
                      counterText: "",
                      labelStyle:  TextStyle(fontSize: description, color:gray_dark),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const Gap(16),
                  TextField(
                    readOnly: false,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    cursorColor: black,
                    maxLength: 10,
                    controller: businessNameController,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: subTitle,
                      color: black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Business Name',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 14 ),
                      counterText: "",
                      labelStyle:  TextStyle(fontSize: description, color:gray_dark),
                    ),
                  ),
                  const Gap(16),
                  TextField(
                    readOnly: false,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    cursorColor: black,
                    maxLength: 10,
                    controller: websiteController,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: subTitle,
                      color: black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Website',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 14 ),
                      counterText: "",
                      labelStyle:  TextStyle(fontSize: description, color:gray_dark),
                    ),
                  ),
                  const Gap(16),
                  TextField(
                    readOnly: false,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    cursorColor: black,
                    controller: addressLine1Controller,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: subTitle,
                      color: black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Address Line - 1 ',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 14 ),
                      counterText: "",
                      labelStyle:  TextStyle(fontSize: description, color:gray_dark),
                    ),
                  ),
                  const Gap(16),
                  TextField(
                    readOnly: false,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    cursorColor: black,
                    controller: addressLine2Controller,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: subTitle,
                      color: black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Address Line - 2 ',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 14 ),
                      counterText: "",
                      labelStyle:  TextStyle(fontSize: description, color:gray_dark),
                    ),
                  ),
                  const Gap(16),
                  TextField(
                    readOnly: false,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    cursorColor: black,
                    controller: addressLine3Controller,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: subTitle,
                      color: black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Address Line - 3 ',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 14 ),
                      counterText: "",
                      labelStyle:  TextStyle(fontSize: description, color:gray_dark),
                    ),
                  ),
                  const Gap(16),
                  TextField(
                    readOnly: false,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    cursorColor: black,
                    controller: addressLine4Controller,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: subTitle,
                      color: black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Address Line - 4 ',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 14 ),
                      counterText: "",
                      labelStyle:  TextStyle(fontSize: description, color:gray_dark),
                    ),
                  ),
                  const Gap(16),
                  TextField(
                    readOnly: true,
                    textInputAction: TextInputAction.next,
                    cursorColor: black,
                    controller: countryController,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: subTitle,
                      color: black,
                    ),
                    onTap: (){
                      openCountryBottomSheet();
                    },
                    decoration: InputDecoration(
                      labelText: 'Country',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 14 ),
                      counterText: "",
                      labelStyle:  TextStyle(fontSize: description, color:gray_dark),
                    ),
                  ),
                  const Gap(16),
                  TextField(
                    readOnly: true,
                    keyboardType: TextInputType.text,
                    cursorColor: black,
                    controller: stateController,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: subTitle,
                      color: black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'State',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 14 ),
                      counterText: "",
                      labelStyle:  TextStyle(fontSize: description, color:gray_dark),
                    ),
                    onTap: () {
                      if(countryId.isEmpty){
                        showSnackBar("Please select country", context);
                      }
                      else{
                        openSateBottomSheet();
                      }
                    },
                  ),
                  const Gap(16),
                  TextField(
                    readOnly: true,
                    keyboardType: TextInputType.text,
                    cursorColor: black,
                    controller: cityController,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: subTitle,
                      color: black,
                    ),
                    decoration: InputDecoration(
                      labelText: 'City',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 14 ),
                      counterText: "",
                      labelStyle:  TextStyle(fontSize: description, color:gray_dark),
                    ),
                    onTap: () {
                      if(stateId.isEmpty) {
                        showSnackBar("Please Select State", context);
                      }
                      else if(_cityList.isEmpty) {
                        showSnackBar("No Cities Found", context);
                      }
                      else{
                        openCityBottomSheet();
                      }
                    },
                  ),
                  const Gap(16),
                  Text('Upload Business Logo',
                    style: TextStyle(fontSize: subTitle, color: black,fontWeight: FontWeight.w600),
                  ),
                  const Gap(16),
                  GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        _showBottomSheetForImagePicker("Upload Logo");
                      },
                      child: logoFile.path.isNotEmpty
                          ? Container(
                          width: 120,
                          height: 120,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: grayDividerDetail,
                                  width: 1
                              ),
                              shape: BoxShape.rectangle
                          ),
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(50), // Image radius
                            child: Image.file(logoFile, fit: BoxFit.cover,width: 70, height: 70,),
                          )
                      )
                          : Container(
                          width: 120,
                          height: 120,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12), // if you need this
                              border: Border.all(
                                  color: grayDividerDetail,
                                  width: 1
                              ),
                              shape: BoxShape.rectangle
                          ),
                          child: logoPic.isEmpty
                              ? Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Image.asset('assets/images/ic_user.png',fit: BoxFit.cover, color: grayDividerDetail, width: 70, height: 70,),
                          )
                              : SizedBox.fromSize(
                            size: const Size.fromRadius(50), // Image radius
                            child: Image.network(logoPic, fit: BoxFit.cover,width: 70, height: 70,),
                          )
                      )
                  ),
                  const Gap(16),
                  Container(
                    margin: const EdgeInsets.only(top: 30, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: getCommonButtonLoad("Save", isLoading,  () {
                      {
                        if (nameController.text.isEmpty)
                        {
                          showSnackBar("Please enter your name", context);
                        }
                        else if(emailController.text.isEmpty)
                        {
                          showSnackBar("Please enter your email address", context);
                        }
                        else if (!isValidEmail(emailController.text))
                        {
                          showSnackBar("Please enter valid email address", context);
                        }
                        else if(mobileController.text.isEmpty)
                        {
                          showSnackBar("Please enter your mobile number", context);
                        }
                        else if (mobileController.text.length != 10) {
                          showSnackBar('Please enter valid phone number',context);
                        }
                        else if(businessNameController.text.isEmpty)
                        {
                          showSnackBar("Please enter your business name", context);
                        }
                        else if(countryController.text.isEmpty)
                        {
                          showSnackBar("Please select country", context);
                        }
                        else if(stateController.text.isEmpty)
                        {
                          showSnackBar("Please select state", context);
                        }
                        else if(cityController.text.isEmpty)
                        {
                          showSnackBar("Please select city", context);
                        }
                        else
                        {
                          _profileSaveApi();
                        }
                      }
                    }),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }

  @override
  void castStatefulWidget() {
    widget is MyProfileScreen;
  }

  _getCountry() async {
    setState(() {
      isLoading = true;
    });

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(MAIN_URL + countryList);

    Map<String, String> jsonBody = {
      
    };
    final response = await http.post(url, body: jsonBody, headers: {
      "Authorization": sessionManager.getToken() ?? "",
    });
    final statusCode = response.statusCode;

    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = CountryResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      _countryList = dataResponse.countries ?? [];

      if (countryId.isNotEmpty)
        {
          for (int i = 0; i < _countryList.length; i ++)
          {
            if (_countryList[i].id == countryId)
            {
              countryController.text = _countryList[i].name ?? "";
            }
          }
          _getState();
        }


      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  openCountryBottomSheet() {
    countrySearchController = TextEditingController();
    listCountrySearch = [];
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
        builder: (context){
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: StatefulBuilder(builder: (BuildContext context, StateSetter updateState) {
              return ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 2,
                                width: 50,
                                alignment: Alignment.center,
                                color: black,
                                margin: const EdgeInsets.only(top: 10, bottom: 12),
                              ),
                              const Text("Select Country", style: TextStyle(fontSize: 18, color: black,fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14,top: 18),
                          child: TextField(
                            keyboardType: TextInputType.text,
                            controller: countrySearchController,
                            cursorColor: black,
                            style: const TextStyle (
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: black,
                            ),
                            decoration: InputDecoration(
                              // fillColor: grayForDetail,
                              // filled: true,
                              labelText: 'Search Country',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 14 ),
                              counterText: "",
                              labelStyle:  TextStyle(fontSize: description, color:gray_dark),
                              prefixIcon: InkWell(
                                onTap: () {},
                                child: const Icon(Icons.search_rounded, size: 26, color: black,
                                ),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: (){
                                  countrySearchController.clear();
                                },
                                child: const Icon(
                                  Icons.clear,
                                  color: black,
                                ),
                              ),
                            ),
                            onChanged: (text) {
                              if(text.isNotEmpty)
                              {
                                listCountrySearch = [];
                                updateState(() {
                                  for (int i = 0; i < _countryList.length; i++)
                                  {
                                    String name = _countryList[i].name.toString().trim();
                                    if (name.toLowerCase().contains(text.toLowerCase()))
                                    {
                                      listCountrySearch.add(_countryList[i]);
                                    }
                                    print("listCountrySearch === ${listCountrySearch.length}");
                                  }
                                });
                              }
                              else
                              {
                                updateState(() {
                                  countrySearchController.clear();
                                  listCountrySearch.clear();
                                });
                              }
                            },
                          ),
                        ),
                        Column(
                          children: [
                            _countryList.isEmpty
                                ? Container(
                                margin: const EdgeInsets.only(top: 200),
                                child: const MyNoDataNewWidget(msg: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. ', icon: 'assets/images/ic_placeholder.png', titleMSG: 'No Data found',)
                            )
                                : ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: listCountrySearch.isEmpty ? _countryList.length : listCountrySearch.length,
                                itemBuilder: (BuildContext context, int i) {
                                  return InkWell(
                                    onTap: (){
                                      setState((){
                                        if(listCountrySearch.isEmpty)
                                        {
                                          countryController.text = _countryList[i].name.toString();
                                          countryId = "";
                                          countryId = _countryList[i].id.toString();
                                        }
                                        else
                                        {
                                          countryController.text = listCountrySearch[i].name.toString();
                                          countryId = "";
                                          countryId = listCountrySearch[i].id.toString();
                                        }
                                      });
                                      _getState();
                                      Navigator.pop(context);
                                    },
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(14),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(child: Text(listCountrySearch.isEmpty ? _countryList[i].name.toString() : listCountrySearch[i].name.toString(),
                                                style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: black), textAlign: TextAlign.start,)),
                                            ],
                                          ),
                                        ),
                                        const Divider(height: 1,color: grayDividerDetail,)
                                      ],
                                    ),
                                  );
                                }
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        }
    );
  }

  _getState() async {
    setState(() {
      isLoading = true;
    });

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(MAIN_URL + stateList);

    Map<String, String> jsonBody = {
      'country_id': countryId,
    };

    final response = await http.post(url, body: jsonBody, headers: {
      "Authorization": sessionManager.getToken() ?? "",
    });

    final statusCode = response.statusCode;
    print(response);
    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = StateResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      _stateList = dataResponse.states ?? [];
      if (stateId.isNotEmpty)
      {
        for (int i = 0; i < _stateList.length; i ++)
        {
          if (_stateList[i].id == stateId)
          {
            stateController.text = _stateList[i].name ?? "";
          }
        }
        _getCity();
      }
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  openSateBottomSheet() {
    stateSearchController = TextEditingController();
    listStateSearch = [];
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12)
        )),
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
        builder: (context){
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: StatefulBuilder(builder: (BuildContext context, StateSetter updateState) {
              return ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 2,
                                width: 50,
                                alignment: Alignment.center,
                                color: black,
                                margin: const EdgeInsets.only(top: 10, bottom: 12),
                              ),
                              const Text("Select State", style: TextStyle(fontSize: 18, color: black,fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14,top: 18),
                          child: TextField(
                            keyboardType: TextInputType.text,
                            controller: stateSearchController,
                            cursorColor: black,
                            style: const TextStyle (
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: black,
                            ),
                            decoration: InputDecoration(
                              // fillColor: grayForDetail,
                              // filled: true,
                              labelText: 'Search State',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 14 ),
                              counterText: "",
                              labelStyle:  TextStyle(fontSize: description, color:gray_dark),
                              prefixIcon: InkWell(
                                onTap: () {},
                                child: const Icon(Icons.search_rounded, size: 26, color: black,
                                ),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: (){
                                  countrySearchController.clear();
                                },
                                child: const Icon(
                                  Icons.clear,
                                  color: black,
                                ),
                              ),
                            ),
                            onChanged: (text) {
                              if(text.isNotEmpty)
                              {
                                listStateSearch = [];
                                updateState(() {
                                  for (int i = 0; i < _stateList.length; i++)
                                  {
                                    String name = _stateList[i].name.toString().trim();
                                    if (name.toLowerCase().contains(text.toLowerCase()))
                                    {
                                      listStateSearch.add(_stateList[i]);
                                    }
                                    print("list State search === ${listStateSearch.length}");
                                  }
                                });
                              }
                              else
                              {
                                updateState(() {
                                  stateSearchController.clear();
                                  listStateSearch.clear();
                                });
                              }
                            },
                          ),
                        ),
                        Column(
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: listStateSearch.isEmpty ? _stateList.length : listStateSearch.length,
                                itemBuilder: (BuildContext context, int i) {
                                  return InkWell(
                                    onTap: (){
                                      setState((){
                                        if(listStateSearch.isEmpty)
                                        {
                                          stateController.text = _stateList[i].name.toString();
                                          stateId = "";
                                          stateId = _stateList[i].id.toString();
                                        }
                                        else
                                        {
                                          stateController.text = listStateSearch[i].name.toString();
                                          stateId = "";
                                          stateId = listStateSearch[i].id.toString();
                                        }
                                      });
                                      _getCity();
                                      Navigator.pop(context);
                                    },
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(14),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(child: Text( listStateSearch.isEmpty  ? _stateList[i].name.toString() : listStateSearch[i].name.toString(),style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: black), textAlign: TextAlign.start,)),
                                            ],
                                          ),
                                        ),
                                        const Divider(height: 1,color: grayDividerDetail,)
                                      ],
                                    ),
                                  );
                                }
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        }
    );
  }

  _getCity() async {
    setState(() {
      isLoading = true;
    });

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(MAIN_URL + cities);

    Map<String, String> jsonBody = {
      'state_id': stateId,
    };

    final response = await http.post(url, body: jsonBody, headers: {
      "Authorization": sessionManager.getToken() ?? "",
    });

    final statusCode = response.statusCode;
    print(response);
    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = CityResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      _cityList = dataResponse.cities ?? [];
      if (cityId.isNotEmpty)
      {
        for (int i = 0; i < _cityList.length; i ++)
        {
          if (_cityList[i].id == cityId)
          {
            cityController.text = _cityList[i].name ?? "";
          }
        }

      }

      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  openCityBottomSheet() {
    citySearchController = TextEditingController();
    listCitySearch = [];
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
        builder: (context){
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: StatefulBuilder(builder: (BuildContext context, StateSetter updateState) {
              return ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 2,
                                width: 50,
                                alignment: Alignment.center,
                                color: black,
                                margin: const EdgeInsets.only(top: 10, bottom: 12),
                              ),
                              const Text("Select City", style: TextStyle(fontSize: 18, color: black,fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14,top: 18),
                          child: TextField(
                            keyboardType: TextInputType.text,
                            controller: citySearchController,
                            cursorColor: black,
                            style: const TextStyle (
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                              color: black,
                            ),
                            decoration: InputDecoration(
                              // fillColor: grayForDetail,
                              // filled: true,
                              labelText: 'Search City',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 14 ),
                              counterText: "",
                              labelStyle:  TextStyle(fontSize: description, color:gray_dark),
                              prefixIcon: InkWell(
                                onTap: () {},
                                child: const Icon(Icons.search_rounded, size: 26, color: black,
                                ),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: (){
                                  countrySearchController.clear();
                                },
                                child: const Icon(
                                  Icons.clear,
                                  color: black,
                                ),
                              ),
                            ),
                            onChanged: (text) {
                              if(text.isNotEmpty)
                              {
                                listCitySearch = [];
                                updateState(() {
                                  for (int i = 0; i < _cityList.length; i++)
                                  {
                                    String name = _cityList[i].name.toString().trim();
                                    if (name.toLowerCase().contains(text.toLowerCase()))
                                    {
                                      listCitySearch.add(_cityList[i]);
                                    }
                                    print("listCitySearch === ${listCitySearch.length}");
                                  }
                                });
                              }
                              else
                              {
                                updateState (() {
                                  citySearchController.clear();
                                  listCitySearch.clear();
                                });
                              }
                            },
                          ),
                        ),
                        Column(
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: listCitySearch.isEmpty ? _cityList.length : listCitySearch.length,
                                itemBuilder: (BuildContext context, int i) {
                                  return InkWell(
                                    onTap: (){

                                      setState((){
                                        if(listCitySearch.isEmpty)
                                        {
                                          cityController.text = _cityList[i].name.toString();
                                          cityId = "";
                                          cityId = _cityList[i].id.toString();
                                        }
                                        else
                                        {
                                          cityController.text = listCitySearch[i].name.toString();
                                          cityId = "";
                                          cityId = listCitySearch[i].id.toString();
                                        }
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(14),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(child: Text( listCitySearch.isEmpty  ? _cityList[i].name.toString() : listCitySearch[i].name.toString(),style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: black), textAlign: TextAlign.start,)),
                                            ],
                                          ),
                                        ),
                                        const Divider(height: 1,color: grayDividerDetail,)
                                      ],
                                    ),
                                  );
                                }
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        }
    );
  }

  _showBottomSheetForImagePicker(String isFor) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kContainerCornerRadius),
          topRight: Radius.circular(kContainerCornerRadius)
      )),
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 2,
                  width: 50,
                  alignment: Alignment.center,
                  color: black,
                  margin: const EdgeInsets.only(top: 10, bottom: 12),
                ),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 14,bottom: 8),
                  child: Text('Select Image From?', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Image.asset("assets/images/ic_camera.png",width: 24,height: 24,),
                        Container(
                            margin: const EdgeInsets.only(left: 8),
                            child: const Text('Camera', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),textAlign: TextAlign.start,)),
                      ],
                    ),
                  ),
                  onTap: (){
                    Navigator.pop(context);
                    pickImageFromCamera(isFor);
                  },
                ),
                const Divider(thickness: 0.5,color: Colors.black,),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        Image.asset("assets/images/ic_gallery.png",width: 24,height: 24,),
                        Container(
                            margin: const EdgeInsets.only(left: 8),
                            child: const Text('Gallery', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),)),
                      ],
                    ),
                  ),
                  onTap: (){
                    Navigator.pop(context);
                    pickImageFromGallery(isFor);
                  },
                ),
                Container(height: 12)
              ],
            )

          ],
        );
      },
    );
  }

  File fileNew = File("");
  dynamic fileBytes;

  Future<void> _cropImage(filePath, String isFor) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath
    );
    if (croppedFile != null) {
      setState(() {
        if (isFor == "Upload Logo")
          {
            logoFile = File(croppedFile.path);
            logoPic = croppedFile.path;
            print("_pickImage logoPic crop ====>$logoPic");
          }
        else
          {
            profilePicFile = File(croppedFile.path);
            pickImgPath = croppedFile.path;
            print("_pickImage picImgPath crop ====>$pickImgPath");
          }

      });
    }
  }

  Future<void> pickImageFromCamera(String isFor) async {
    try {
      var pickedFiles =
      await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50);
      if (pickedFiles != null) {
        final filePath = pickedFiles.path;
        File tempFile = File(filePath);
        _cropImage(filePath, isFor);
        print("_pickImage picImgPath ====>$pickImgPath");
      } else {
        print("No image is selected.");
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> pickImageFromGallery(String isFor) async {
    try {
      var pickedFiles = await ImagePicker().pickImage(source: ImageSource.gallery,  imageQuality: 50);
      if (pickedFiles != null) {
        final filePath = pickedFiles.path;
        File tempFile = File(filePath);
        _cropImage(filePath,isFor);


      } else {
        print("No image is selected.");
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  _profileSaveApi() async {
    setState(() {
      isLoading = true;
    });

    Map<String, String> jsonBody = {
    'from_app': 'true',
    'name': nameController.value.text,
    'email': emailController.value.text,
    'username': userNameController.value.text,
    'id': sessionManager.getUserId() ?? "",
    'address_line_1': addressLine1Controller.value.text,
    'address_line_2': addressLine2Controller.value.text,
    'address_line_3': addressLine3Controller.value.text,
    'address_line_4': addressLine4Controller.value.text,
    'country_id': countryId,
    'state_id': stateId,
    'city_id': cityId,
    'mobile': mobileController.value.text,
    'type': sessionManager.getType() ?? "",
    'website': websiteController.value.text,
    'business_name': businessNameController.value.text,
    'country_code': "1",
    };
    print("city id-----"+cityId.toString());

    final url = Uri.parse(MAIN_URL + updateProfile);

    Map<String, String> headers = {"Authorization": sessionManager.getToken() ?? ""};

    http.MultipartRequest request = http.MultipartRequest('POST', url,);
    request.headers.addAll(headers);

    if (profilePicFile.path.isNotEmpty)
    {
      request.files.add(await http.MultipartFile.fromPath('profile_pic', profilePicFile.path));
    }
    //request.headers.("Access-Token": sessionManager.getAccessToken().toString().trim())
    request.fields.addAll(jsonBody);

    http.StreamedResponse response = await request.send();
    var responseBytes = await response.stream.toBytes();
    var responseString = utf8.decode(responseBytes);

    final statusCode = response.statusCode;
    Map<String, dynamic> user = jsonDecode(responseString);
    print("User ===== $user");
    var dataResponse = CommonResponseModel.fromJson(user);

    print(dataResponse);

    if (statusCode == 200 && dataResponse.success == 1) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(dataResponse.message, context);
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(dataResponse.message, context);
    }
  }

  _getProfile() async {
    setState(() {
      isLoading = true;
    });

    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);

    final url = Uri.parse(MAIN_URL + userProfile);

    Map<String, String> jsonBody = {
    };

    final response = await http.post(url, body: jsonBody, headers: {
      "Authorization": sessionManager.getToken() ?? "",
    });

    final statusCode = response.statusCode;
    final body = response.body;
    Map<String, dynamic> user = jsonDecode(body);
    var dataResponse = GetProfileResponseModel.fromJson(user);

    if (statusCode == 200 && dataResponse.success == 1) {
      profileData = dataResponse.profile ?? Profile();

      setData();

      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }


}