import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../constant/colors.dart';
import '../screens/DashboardPage.dart';
import '../screens/OrderListPage.dart';
import '../screens/ProductListScreen.dart';
import '../screens/ProfileScreen.dart';
import '../utils/app_utils.dart';
import '../utils/session_manager.dart';

class TabNavigation extends StatefulWidget {
  final int passIndex;
  const TabNavigation(this.passIndex,{Key? key}) : super(key: key);

  @override
  State<TabNavigation> createState() => _TabNavigationPageState();

}

class _TabNavigationPageState extends State<TabNavigation> {
  late int _currentIndex;
  DateTime preBackPressTime = DateTime.now();
  static final List<Widget> _pages = <Widget>[
    const DashboardPage(),
    const ProductListScreen(),
    const OrderListPage(),
    const ProfileScreen()
  ];

  SessionManager sessionManager = SessionManager();
  bool canPop = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvoked: (didPop) async {
          if (_currentIndex != 0)
          {
            print("Is running if condition");
            setState(() {
              _currentIndex = 0;
            });
            //return Future.value(false);
          }
          else
          {
            print("Is running else condition");
            final timeGap = DateTime.now().difference(preBackPressTime);
            final cantExit = timeGap >= const Duration(seconds: 2);
            preBackPressTime = DateTime.now();
            if (cantExit)
            {
              setState(() {
                canPop = true;
              });
              showSnackBar('Press back button again to exit', context);
              // return Future.value(false);
            }
            else
            {
              SystemNavigator.pop();
              // return Future.value(true);
            }
          }
        },
        child: Scaffold(
          backgroundColor: appBG,
          resizeToAvoidBottomInset: true,
          body: IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          bottomNavigationBar: SizedBox(
            height: kIsWeb ? 65 : Platform.isAndroid ? 94 : 94,
            child: Stack(
              children: [
                SizedBox(
                  height: kIsWeb ? 65 : Platform.isAndroid ? 94 : 94,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: Container(
                            height: 2,
                            color: _currentIndex == 0 ? primaryColor : white,
                          )),
                          Expanded(child: Container(
                            height: 2,
                            color: _currentIndex == 1 ? primaryColor : white,
                          )),
                          Expanded(child: Container(
                            height: 2,
                            color: _currentIndex == 2 ? primaryColor : white,
                          )),
                          Expanded(child: Container(
                            height: 2,
                            color: _currentIndex == 3 ? primaryColor : white,
                          )),
                        ],
                      ),
                      SizedBox(
                        height: 92,
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          margin: EdgeInsets.zero,
                          semanticContainer: true,
                          elevation: 8,
                          child: BottomNavigationBar(
                            key: bottomWidgetKey,
                            type: BottomNavigationBarType.fixed,
                            currentIndex: _currentIndex,
                            backgroundColor: white,
                            selectedItemColor: primaryColor,
                            unselectedItemColor: hintDark,
                            iconSize: 24,
                            onTap: (value) {
                              FocusScopeNode currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }

                              if (value == 0 && isHomeLoad) {
                                setState(() {
                                  isOrderListSearch = false;
                                  _pages.removeAt(0);
                                  _pages.insert(0, const DashboardPage());
                                });
                              }
                              else if (value == 1 && isListReLoad)
                              {
                                setState(() {
                                  isOrderListSearch = false;
                                  _pages.removeAt(1);
                                  _pages.insert(1, const ProductListScreen());
                                });
                              }
                              // else if (value == 2)//&& isAddProductPage)
                              //     {
                              //       if(NavigationService.listItemsTmp.isNotEmpty)
                              //       {
                              //         print("AddProductPage------------------------>");
                              //         Navigator.push(context, MaterialPageRoute(builder: (context) => AddOrderScreen()));
                              //
                              //         setState(() {
                              //           isOrderListSearch = false;
                              //           _currentIndex = 0;
                              //           _pages.removeAt(2);
                              //           _pages.insert(2, AddOrderScreen());
                              //         });
                              //       }
                              //       else
                              //         {
                              //           showSnackBar("Please select product first", context);
                              //         }
                              //
                              // }
                              else if (value == 2) //isOrderListLoad
                              {
                                setState(() {
                                  _pages.removeAt(2);
                                  _pages.insert(2, const OrderListPage());
                                });
                              }
                              else if (value == 3)
                              {
                                setState(() {
                                  _pages.removeAt(3);
                                  _pages.insert(3, const ProfileScreen());
                                });
                              }

                              setState(() {
                                _currentIndex = value;
                              });
                            },
                            items:  const [
                              BottomNavigationBarItem(
                                label: 'Home',
                                icon: ImageIcon(
                                  AssetImage("assets/images/ic_home_unselected.png"),
                                ),
                              ),
                              BottomNavigationBarItem(
                                label: 'Items',
                                icon: ImageIcon(
                                  AssetImage("assets/images/product_gray.png"),
                                ),
                              ),
                              BottomNavigationBarItem(
                                label: 'Orders',
                                icon: ImageIcon(
                                  AssetImage("assets/images/ic_orders_gray.png"),
                                ),
                              ),
                              /*  sessionManager.getProfilePic().toString().isNotEmpty ? BottomNavigationBarItem(
                                  label: 'Store',
                                  icon:ClipOval(
                                    child: FadeInImage.assetNetwork(
                                      image: sessionManager.getProfilePic().toString(),
                                      fit: BoxFit.cover,
                                      width: 24,
                                      height: 24,
                                      placeholder: 'assets/images/ic_profile_gray.png',
                                    ),
                                  ),
                                //const ImageIcon(AssetImage("assets/images/ic_profile_orange.png"),),
                              ) : */
                              BottomNavigationBarItem(
                                label: 'Profile',
                                icon:ImageIcon(AssetImage("assets/images/profile_gray.png"),),
                                //const ImageIcon(AssetImage("assets/images/ic_profile_orange.png"),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = (widget as TabNavigation).passIndex;
  }

}
