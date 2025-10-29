import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorResources {

  static Color getRightBubbleColor() {
    return  Theme.of(Get.context!).primaryColor;
  }
  static Color getLeftBubbleColor() {
    return Get.isDarkMode ? const Color(0xA2B7B7BB): Theme.of(Get.context!).colorScheme.onSecondary.withValues(alpha:0.1);
  }


  static const Map<String, Color> buttonBackgroundColorMap ={
    'pending': Color(0xFFEDE7F6),   // Light Purple
    'accepted': Color(0xFFEDE7F6),  // Light Purple
    'ongoing': Color(0xFFEDE7F6),   // Light Purple
    'completed': Color(0xFFFFF8E1), // Light Gold
    'canceled': Color(0xFFFFEBEB),  // Light Red
    'approved': Color(0xFFFFF8E1),  // Light Gold
    'denied': Color(0xFFFFEBEB),    // Light Red
  };

  static const Map<String, Color> buttonTextColorMap ={
    'pending': Color(0xFF5D2E95),    // Purple
    'accepted': Color(0xFF5D2E95),   // Purple
    'ongoing': Color(0xFF5D2E95),    // Purple
    'completed': Color(0xFFB38937),  // Gold
    'canceled': Color(0xFFFF3737),   // Red
    'approved': Color(0xFFB38937),   // Gold
    'denied':  Color(0xFFFF3737),    // Red
  };
}