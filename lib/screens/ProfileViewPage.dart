import 'dart:convert';
import 'dart:core';
import 'package:chicken_delight/utils/app_utils.dart';
import 'package:chicken_delight/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:url_launcher/url_launcher.dart';
import '../common_widget/common_widget.dart';
import '../constant/ApiService.dart';
import '../constant/api_end_point.dart';
import '../constant/colors.dart';
import '../model/GetProfileResponseModel.dart';
import '../model/common/CommonResponseModel.dart';
import '../utils/base_class.dart';
import 'MyProfileScreen.dart';


class ProfileViewPage extends StatefulWidget {
  const ProfileViewPage({Key? key}) : super(key: key);

  @override
  BaseState<ProfileViewPage> createState() => _ProfileViewPageState();
}

class _ProfileViewPageState extends BaseState<ProfileViewPage> {
  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  Profile profileData = Profile();

  String profilePic = "";
  String name = "";
  String userName = "";
  String email = "";
  String mobile = "";
  String businessName = "";
  String website = "";
  String address = "";


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

    _getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if(didPop) {
          return;
        }
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: appBG,
        appBar:AppBar(
          toolbarHeight: kToolbarHeight,
          automaticallyImplyLeading: false,
          title: getTitle("Profile"),
          elevation: 0,
          backgroundColor: chicken_bg,
          leading: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.pop(context);
              },
              child: getBackArrowBlack()
          ),
          actions: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                startActivity(context, const MyProfileScreen());
              },
              child: Image.asset('assets/images/ic_edit.png', height: 20, width: 22),
            ),
            const Gap(20)
          ],
        ),
        body: _isLoading
            ? const LoadingWidget()
            : Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      color: white,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kTextFieldCornerRadius),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10, top: 8, bottom: 8),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: Card(
                                  elevation: 5,
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(kTextFieldCornerRadius),
                                  ),
                                  child: sessionManager.getImagePic().toString().isNotEmpty
                                      ? FadeInImage.assetNetwork(
                                    image: sessionManager.getImagePic().toString(),
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                    placeholder: 'assets/images/ic_placeholder.png',
                                  ) : Image.asset('assets/images/ic_placeholder.png', width: 100, height: 100)
                              ),
                            ),
                            const Gap(6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Gap(10),
                                Text(name.isNotEmpty ? name : "Guest User",
                                    style: const TextStyle(fontWeight: FontWeight.w600, color: black,fontSize: 17)),
                                const Gap(6),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    launchPhoneURL("tel://$mobile");
                                  },
                                  child: Text(mobile,
                                      style: const TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 16)),
                                ),
                                const Gap(6),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    onOpenMailClicked(email);
                                  },
                                  child: Text(email,
                                      overflow: TextOverflow.clip,
                                      style: const TextStyle(overflow: TextOverflow.clip,
                                          fontWeight: FontWeight.w600, color: black, fontSize: 16)
                                  ),
                                ),
                                const Gap(10),
                              ],
                            ),
                            const Gap(4),
                          ],
                        ),
                      ),
                    ),
                    const Gap(10),
                    Card(
                      color: white,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kTextFieldCornerRadius),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset('assets/images/user.png', height: 24, width: 24, color: black,),
                                const Gap(10),
                                Text("@$userName",
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(overflow: TextOverflow.clip,
                                        fontWeight: FontWeight.w600, color: black, fontSize: 16)
                                ),
                              ],
                            ),
                            const Gap(12),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                launchUrl(Uri.parse(website));
                              },
                              child: Row(
                                children: [
                                  Image.asset('assets/images/website.png', height: 24, width: 24, color: black,),
                                  const Gap(10),
                                  Text(website,
                                      style: const TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 16)),
                                ],
                              ),
                            ),
                            const Gap(12),
                            Row(
                              children: [
                                Image.asset('assets/images/user.png', height: 24, width: 24, color: black,),
                                const Gap(10),
                                Text(businessName,
                                    style: const TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 16)),
                              ],
                            ),
                            const Gap(12),
                            Row(
                              children: [
                                Image.asset('assets/images/location.png', height: 24, width: 24, color: black,),
                                const Gap(10),
                                Expanded(
                                  child: Text(address,
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 16)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void castStatefulWidget() {
    widget is ProfileViewPage;
  }

  void setData() {
    setState(() {
      if (profileData.profilePicture != null)
      {
        if (profileData.profilePicture.toString().isNotEmpty)
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

      if (profileData.name != null)
      {
        if (profileData.name.toString().isNotEmpty)
        {
          name = profileData.name ?? "";
        }
        else
        {
          name = sessionManager.getName() ?? "";
        }
      }
      else
      {
        name = sessionManager.getName() ?? "";
      }

      userName = profileData.username ?? "";
      email = profileData.email ?? "";
      mobile = profileData.mobile ?? "";
      businessName = profileData.businessName ?? "";
      website = profileData.website ?? "";
      address = "${profileData.addressLine1?.toString() ?? " "}, ${profileData.addressLine2?.toString() ?? " "}, ${profileData.addressLine3?.toString() ?? " "}, ${profileData.addressLine4?.toString() ?? " "}";

    });

  }

  //API call function...
  _getProfile() async {
    setState(() {
      _isLoading = true;
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
        _isLoading = false;
      });

    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

}
