// import 'package:demandium_serviceman/utils/core_export.dart';
// import 'package:get/get.dart';
//
// class BottomNavScreen extends StatefulWidget {
//   final int pageIndex;
//   const BottomNavScreen({super.key, required this.pageIndex});
//
//   @override
//   BottomNavScreenState createState() => BottomNavScreenState();
// }
//
// class BottomNavScreenState extends State<BottomNavScreen> {
//
//   void _loadData() async {
//     await Get.find<DashboardController>().getDashboardData();
//     Get.find<DashboardController>().getMonthlyBookingsDataForChart(DateConverter.stringYear(DateTime.now()),DateTime.now().month.toString());
//     Get.find<DashboardController>().getYearlyBookingsDataForChart(DateConverter.stringYear(DateTime.now()));
//     Get.find<BookingRequestController>().updateBookingStatusState(BooingListStatus.completed);
//     Get.find<BookingRequestController>().getBookingHistory('all',1);
//     Get.find<BookingRequestController>().updateBookingHistorySelectedIndex(0);
//     Get.find<LocalizationController>().filterLanguage(shouldUpdate: false);
//     Get.find<ConversationController>().getChannelList(1, type: "customer");
//     Get.find<ConversationController>().getChannelList(1, type: "provider");
//     Get.find<AuthController>().updateToken();
//   }
//
//   PageController? _pageController;
//   int _pageIndex = 0;
//   List<Widget>? _screens;
//
//   bool _canExit = GetPlatform.isWeb ? true : false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     Future.delayed(const Duration(milliseconds: 200), (){
//       _loadData();
//     });
//
//     _pageIndex = widget.pageIndex;
//     _pageController = PageController(initialPage: widget.pageIndex);
//
//     _screens = [
//       const DashBoardScreen(),
//       // const BookingListScreen(),
//       const BookingHistoryScreen(),
//       const Text("More"),
//     ];
//
//     Future.delayed(const Duration(seconds: 1), () {
//       setState(() {});
//     });
//
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     final padding = MediaQuery.of(context).padding;
//
//     return CustomPopScopeWidget(
//       onPopInvoked: (){
//         if (_pageIndex != 0) {
//           _setPage(0);
//         } else {
//           if(_canExit) {
//             exit(0);
//           }else {
//             showCustomSnackBar('back_press_again_to_exit'.tr, type : ToasterMessageType.info);
//             _canExit = true;
//             Timer(const Duration(seconds: 2), () {
//               _canExit = false;
//             });
//           }
//         }
//       },
//       child: Scaffold(
//         bottomNavigationBar: Container(
//           padding: EdgeInsets.only(
//             top: Dimensions.paddingSizeDefault,
//             bottom: padding.bottom > 15 ? 0 : Dimensions.paddingSizeDefault,
//           ),
//           decoration: BoxDecoration(
//               color: Get.isDarkMode?Theme.of(context).colorScheme.surface:Theme.of(context).primaryColor,
//               boxShadow:[
//                 BoxShadow(
//                   offset: const Offset(0, 1),
//                   blurRadius: 5,
//                   color: Theme.of(context).primaryColor.withValues(alpha:0.5),
//                 )]
//           ),
//           child: SafeArea(
//             child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
//               child: Row(children: [
//                 _getBottomNavItem(0, Images.dashboard, 'dashboard'.tr),
//                 _getBottomNavItem(1, Images.requests, 'requests'.tr),
//                 _getBottomNavItem(2, Images.history, 'history'.tr),
//                 _getBottomNavItem(3, Images.moree, 'more'.tr),
//               ]),
//             ),
//           ),
//         ),
//         body: PageView.builder(
//           controller: _pageController,
//           itemCount: _screens!.length,
//           physics: const NeverScrollableScrollPhysics(),
//           itemBuilder: (context, index) {
//             return _screens![index];
//           },
//         ),
//       ),
//     );
//   }
//
//   void _setPage(int pageIndex) {
//     if(pageIndex == 3) {
//       Get.bottomSheet(const MenuScreen(), backgroundColor: Colors.transparent, isScrollControlled: true);
//     }else {
//       setState(() {
//         _pageController!.jumpToPage(pageIndex);
//         _pageIndex = pageIndex;
//       });
//     }
//   }
//
//   Widget _getBottomNavItem(int index, String icon, String title) {
//     return Expanded(child: InkWell(
//       onTap: () => _setPage(index),
//       child: Column(mainAxisSize: MainAxisSize.min, children: [
//
//         icon.isEmpty ? const SizedBox(width: 20, height: 20) : Image.asset(
//             icon, width: 17, height: 17,
//             color: _pageIndex == index ? Get.isDarkMode ? Theme.of(context).primaryColor : Colors.white : Colors.grey.shade400
//         ),
//         const SizedBox(height: Dimensions.paddingSizeExtraSmall),
//
//         Text(title, style: robotoRegular.copyWith(
//             fontSize: Dimensions.fontSizeSmall,
//             color: _pageIndex == index ? Get.isDarkMode ? Theme.of(context).primaryColor : Colors.white : Colors.grey.shade400
//         )),
//
//       ]),
//     ));
//   }
//
// }



//////////////


import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demandium_serviceman/utils/core_export.dart' hide BooingListStatus;
import 'package:demandium_serviceman/common/enums/enums.dart' hide BooingListStatus;

import '../booking_request/view/new_booking_list_screen.dart';

class BottomNavScreen extends StatefulWidget {
  final int pageIndex;

  const BottomNavScreen({super.key, required this.pageIndex});

  @override
  BottomNavScreenState createState() => BottomNavScreenState();
}

class BottomNavScreenState extends State<BottomNavScreen> {
  late PageController _pageController;
  late int _pageIndex;
  late List<Widget?> _screens;
  bool _canExit = GetPlatform.isWeb ? true : false;
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex;
    _pageController = PageController(initialPage: _pageIndex);

    // Lazy-load screen placeholders
    _screens = List<Widget?>.filled(4, null);

    // Load data after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (_dataLoaded) return;
    _dataLoaded = true;

    final dashboardController = Get.find<DashboardController>();
    final bookingController = Get.find<BookingController>();
    final localizationController = Get.find<LocalizationController>();
    final conversationController = Get.find<ConversationController>();
    final authController = Get.find<AuthController>();

    await dashboardController.getDashboardData();

    dashboardController.getMonthlyBookingsDataForChart(
      DateConverter.stringYear(DateTime.now()),
      DateTime.now().month.toString(),
    );
    dashboardController.getYearlyBookingsDataForChart(
      DateConverter.stringYear(DateTime.now()),
    );

    bookingController.updateBookingStatusState(BooingListStatus.pending);

    localizationController.filterLanguage(shouldUpdate: false);
    conversationController.getChannelList(1, type: "customer");
    conversationController.getChannelList(1, type: "provider");

    authController.updateToken();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return CustomPopScopeWidget(
      onPopInvoked: () {
        if (_pageIndex != 0) {
          _setPage(0);
        } else {
          if (_canExit) {
            exit(0);
          } else {
            showCustomSnackBar('back_press_again_to_exit'.tr, type: ToasterMessageType.info);
            _canExit = true;
            Timer(const Duration(seconds: 2), () => _canExit = false);
          }
        }
      },
      child: Scaffold(
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => _getScreen(index),
        ),
        bottomNavigationBar: _buildBottomBar(padding),
      ),
    );
  }

  Widget _buildBottomBar(EdgeInsets padding) {
    return Container(
      padding: EdgeInsets.only(
        top: Dimensions.paddingSizeDefault,
        bottom: padding.bottom > 15 ? 0 : Dimensions.paddingSizeDefault,
      ),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Theme.of(context).colorScheme.surface : Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 5,
            color: Theme.of(context).primaryColor.withOpacity(0.5),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
          child: Row(
            children: [
              _buildBottomNavItem(0, Images.dashboard, 'dashboard'.tr),
              _buildBottomNavItem(1, Images.requests, 'requests'.tr),
              // _buildBottomNavItem(2, Images.history, 'history'.tr),
              _buildBottomNavItem(3, Images.moree, 'more'.tr),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(int index, String icon, String title) {
    final isSelected = _pageIndex == index;
    final color = isSelected
        ? (Get.isDarkMode ? Theme.of(context).primaryColor : Colors.white)
        : Colors.grey.shade400;

    return Expanded(
      child: InkWell(
        onTap: () => _setPage(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon.isEmpty
                ? const SizedBox(width: 20, height: 20)
                : Image.asset(icon, width: 17, height: 17, color: color),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            Text(
              title,
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: color),
            ),
          ],
        ),
      ),
    );
  }

  void _setPage(int index) {
    if (index == 3) {
      Get.bottomSheet(const MenuScreen(), backgroundColor: Colors.transparent, isScrollControlled: true);
    } else {
      setState(() {
        _pageController.jumpToPage(index);
        _pageIndex = index;
      });
    }
  }

  Widget _getScreen(int index) {
    if (_screens[index] == null) {
      switch (index) {
        case 0:
          _screens[index] = const DashBoardScreen();
          break;
        case 1:
          _screens[index] = BookingScreen(token: '');
          break;
        case 2:
          _screens[index] = const BookingHistoryScreen();
          break;
        case 3:
          _screens[index] = const Text("More");
          break;
      }
    }
    return _screens[index]!;
  }
}

