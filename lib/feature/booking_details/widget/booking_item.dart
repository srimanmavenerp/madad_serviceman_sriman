//
// import 'package:get/get.dart';
// import 'package:demandium_serviceman/utils/core_export.dart';
// import 'package:flutter/material.dart';
//
// class BookingItem extends StatelessWidget {
//   const BookingItem({
//     super.key,
//     this.icon,
//     this.subTitle,
//     this.img,
//     required this.title,
//     this.date,
//   });
//
//   final IconData? icon;
//   final String? img;
//   final String title;
//   final String? date;
//   final String? subTitle;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         if (icon != null)
//           Icon(icon, size: 18, color: Theme.of(context).primaryColor)
//         else if (img != null && img!.isNotEmpty)
//           Image(image: AssetImage(img!), height: 15, width: 15)
//         else
//           const SizedBox(width: 18),
//         const SizedBox(width: Dimensions.paddingSizeSmall),
//         Expanded(
//           child: Row(
//             children: [
//               Flexible(
//                 child: Text(
//                   title.tr,
//                   style: robotoRegular.copyWith(
//                     fontSize: Dimensions.fontSizeSmall,
//                     color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.6),
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               Text(
//                 subTitle ?? date ?? '',
//                 style: robotoRegular.copyWith(
//                   fontSize: Dimensions.fontSizeSmall,
//                   color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.6),
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 textDirection: TextDirection.ltr,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:demandium_serviceman/utils/core_export.dart';

class BookingItem extends StatelessWidget {
  const BookingItem({
    super.key,
    this.icon,

    this.subTitle,
    this.img,
    required this.title,
    this.date,
  });

  final IconData? icon;
  final String? img;
  final String title;
  final String? date;
  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    final String displayValue = subTitle ?? date ?? '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null)
          Icon(icon, size: 18, color: Theme.of(context).primaryColor)
        else if (img != null && img!.isNotEmpty)
          Image(image: AssetImage(img!), height: 15, width: 15)
        else
          const SizedBox(width: 18),

        const SizedBox(width: Dimensions.paddingSizeSmall),

        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Flexible(
                flex: 2,
                child: Text(
                  '${title.tr} : ',
                  style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Clickable number
              Flexible(
                flex: 3,
                child: GestureDetector(
                  onTap: () async {
                    final Uri url = Uri(scheme: 'tel', path: displayValue);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not launch dialer')),
                      );
                    }
                  },
                  child: Text(
                    displayValue,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Colors.black,
                      // decoration: TextDecoration.underline,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.ltr,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}