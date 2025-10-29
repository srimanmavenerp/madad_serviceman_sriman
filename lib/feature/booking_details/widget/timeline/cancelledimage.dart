import 'dart:io';
import 'package:demandium_serviceman/utils/core_export.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CameraButtonSheetCancelledimage extends StatefulWidget {
  final String bookingId;
  final bool isSubBooking;

  const CameraButtonSheetCancelledimage({
    super.key,
    required this.bookingId,
    required this.isSubBooking,
  });

  @override
  State<CameraButtonSheetCancelledimage> createState() =>
      _CameraButtonSheetCancelledimageState();
}

class _CameraButtonSheetCancelledimageState
    extends State<CameraButtonSheetCancelledimage> {
  final List<XFile> _pickedImages = [];
  int _totalFileSize = 0; // in bytes
  static const int maxSingleFileSize = 2 * 1024 * 1024; // 2 MB per image
  static const int maxTotalFileSize = 10 * 1024 * 1024; // 10 MB total

  /// Pick image from camera or gallery
  Future<void> _pickImage({required bool isCamera}) async {
    if (_pickedImages.length >= 5) {
      Get.snackbar('Info', 'You can select up to 5 images only',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final XFile? pickedFile = await ImagePicker().pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 60,
    );

    if (pickedFile == null) return;

    final File file = File(pickedFile.path);
    final int fileSize = await file.length();

    // Check per image size
    if (fileSize > maxSingleFileSize) {
      Get.snackbar(
        'File too large',
        'Each image must be smaller than 2 MB.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Check total file size
    if (_totalFileSize + fileSize > maxTotalFileSize) {
      Get.snackbar(
        'Total size exceeded',
        'Total selected images cannot exceed 10 MB.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() {
      _pickedImages.add(pickedFile);
      _totalFileSize += fileSize;
    });
  }

  /// Format file size
  String _formatBytes(int bytes) {
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(1)} KB";
    return "${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(Dimensions.radiusExtraLarge)),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Handle
        Container(
          height: 5,
          width: 60,
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[400],
          ),
        ),

        // Title
        Text(
          "Cancellation Images",
          style: robotoBold.copyWith(
            fontSize: 20,
            color:
                Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.85),
          ),
        ),
        const SizedBox(height: 8),

        // Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            "Select up to 5 images related to cancellation.\n"
            "Each image must be below 2 MB, total < 10 MB.",
            style: robotoRegular.copyWith(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 15),

        // Total size display
        if (_pickedImages.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Total size: ${_formatBytes(_totalFileSize)}",
                style: robotoMedium.copyWith(
                  color: Colors.grey[700],
                  fontSize: 13,
                ),
              ),
            ),
          ),

        // Picked images preview
        _pickedImages.isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Icon(
                  Icons.photo_library_outlined,
                  size: 80,
                  color: Colors.grey[300],
                ),
              )
            : SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _pickedImages.length,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              )
                            ],
                            image: DecorationImage(
                              image: FileImage(File(_pickedImages[index].path)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () async {
                              final fileSize =
                                  await File(_pickedImages[index].path)
                                      .length();
                              setState(() {
                                _totalFileSize -= fileSize;
                                _pickedImages.removeAt(index);
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                  )
                                ],
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

        const SizedBox(height: 20),

        // Camera + Gallery buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildPickButton(
              icon: Image.asset(Images.upload, width: 35),
              label: 'Upload',
              isCamera: false,
            ),
            _buildPickButton(
              icon: Icon(Icons.camera_alt_outlined,
                  size: 35, color: Theme.of(context).primaryColor),
              label: 'Camera',
              isCamera: true,
            ),
          ],
        ),

        const SizedBox(height: 30),

        // Save & Continue
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                if (_pickedImages.isEmpty) {
                  Get.snackbar(
                    'Info',
                    'Please select at least one image.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  return;
                }

                final List<File> selectedFiles = await Future.wait(
                  _pickedImages.map((xfile) async => File(xfile.path)),
                );

                Get.back(result: selectedFiles);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              child: Text(
                'Save & Continue',
                style: robotoBold.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ]),
    );
  }

  Widget _buildPickButton(
      {required Widget icon, required String label, required bool isCamera}) {
    return InkWell(
      onTap: () => _pickImage(isCamera: isCamera),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: icon,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: robotoMedium.copyWith(
              color: Theme.of(context).primaryColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
