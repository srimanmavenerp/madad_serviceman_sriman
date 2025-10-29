// import 'package:get/get.dart';
// import 'package:demandium_serviceman/utils/core_export.dart';
//
//
// class BottomCard extends StatelessWidget {
//
//   const BottomCard({super.key, required this.name, required this.phone, required this.image, this.address});
//
//   final String name;
//   final String phone;
//   final String image;
//   final String? address;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color:Get.isDarkMode?Theme.of(context).cardColor.withValues(alpha:0.6):Theme.of(context).primaryColor.withValues(alpha:0.05),
//         //boxShadow: shadow
//       ),
//
//       child: Column(
//         children: [
//           const Row(),
//
//           const SizedBox(height: Dimensions.paddingSizeDefault,),
//           ClipRRect(
//               borderRadius: BorderRadius.circular(50),
//               child: CustomImage(
//                 height: 50,
//                 width: 50,
//                 image: image,
//                 placeholder: Images.userPlaceHolder,
//               )
//           ),
//
//           const SizedBox(height: Dimensions.paddingSizeSmall,),
//           Text(name, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault,),textAlign: TextAlign.center,),
//
//           const SizedBox(height: Dimensions.paddingSizeSmall,),
//           Text(phone, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
//               color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:0.7))),
//
//           const SizedBox(height: Dimensions.paddingSizeSmall,),
//           address != null ?
//           Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: RichText(
//                 text: TextSpan(text: '${'service_address'.tr} :',
//                   style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault,
//                     color: Theme.of(context).textTheme.bodyLarge!.color,
//                   ),
//                   children: [
//                     TextSpan(
//                       text: ' $address',
//                       style: robotoRegular.copyWith(
//                         fontSize: Dimensions.fontSizeDefault,
//                         color: Theme.of(context).textTheme.bodyLarge!.color!.withValues(alpha:0.7),
//                       ),
//                     ),
//                   ],
//                 ),
//                 textAlign: TextAlign.center),
//           ) : const SizedBox(),
//
//           const SizedBox(height:Dimensions.paddingSizeLarge),
//         ],
//       ),
//     );
//   }
// }



import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import
import 'package:demandium_serviceman/utils/core_export.dart';

class BottomCard extends StatelessWidget {
  const BottomCard({
    super.key,
    required this.name,
    required this.phone,
    required this.image,
    this.address,
  });

  final String name;
  final String phone;
  final String image;
  final String? address;

  void _launchDialer(String phone) async {
    final Uri uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // Optional: Show an error or fallback
      debugPrint('Could not launch phone dialer');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Get.isDarkMode
            ? Theme.of(context).cardColor.withValues(alpha: 0.6)
            : Theme.of(context).primaryColor.withValues(alpha: 0.05),
      ),
      child: Column(
        children: [
          const Row(),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CustomImage(
              height: 50,
              width: 50,
              image: image,
              placeholder: Images.userPlaceHolder,
            ),
          ),

          const SizedBox(height: Dimensions.paddingSizeSmall),

          Text(
            name,
            style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: Dimensions.paddingSizeSmall),

          GestureDetector(
            onTap: () => _launchDialer(phone),
            child: Text(
              phone,
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                color: Colors.blue,
                 decoration: TextDecoration.underline,
              ),
            ),
          ),

          const SizedBox(height: Dimensions.paddingSizeSmall),

          if (address != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: '${'service_address'.tr} :',
                  style: robotoBold.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                  children: [
                    TextSpan(
                      text: ' $address',
                      style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault,
                        color: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .color!
                            .withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: Dimensions.paddingSizeLarge),
        ],
      ),
    );
  }
}