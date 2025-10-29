// import 'package:get/get.dart';
// import 'package:demandium_serviceman/utils/core_export.dart';
//
//
// class BookingRequestController extends GetxController  implements GetxService{
//   final BookingRequestRepo bookingRequestRepo;
//   BookingRequestController({required this.bookingRequestRepo});
//
//   final ScrollController scrollController = ScrollController();
//   final ScrollController bookingHistoryScrollController = ScrollController();
//
//   List<String> bookingHistoryStatus = [ "All" , "Completed" , "Canceled"];
//   List<String> bookingRequestList = [ "accepted" , "ongoing" ];
//   //String selectedTimeSlot = 'All';
//   String selectedTimeSlot = '5 AM to 10 PM';
//   void updateTimeSlotFilter(String slot) {
//     selectedTimeSlot = slot;
//     // Add your filtering logic here
//     update();
//   }
//   bool _isLoading= false;
//   bool get isLoading => _isLoading;
//
//   bool _isFirst= true;
//   bool  get isFirst=> _isFirst;
//
//   bool _isPaginationLoading= false;
//   bool get isPaginationLoading => _isPaginationLoading;
//
//   int _bookingListPageSize = 1;
//   int _offset = 1;
//   int get offset => _offset;
//
//   List<BookingRequestModel> _bookingList =[];
//   List<BookingRequestModel> get bookingList => _bookingList;
//
//   List<BookingRequestModel> _bookingHistoryList =[];
//   List<BookingRequestModel> get bookingHistoryList => _bookingHistoryList;
//
//   int _bookingHistorySelectedIndex = 0;
//   int get bookingHistorySelectedIndex =>_bookingHistorySelectedIndex;
//
//   String ? requestType;
//   BooingListStatus get bookingStatusState => _bookingStatusState;
//
//   var _bookingStatusState = BooingListStatus.accepted;
//
//   void updateBookingStatusState(BooingListStatus booingListStatus){
//       _bookingStatusState=booingListStatus;
//       update();
//     getBookingList(_bookingStatusState.name.toLowerCase(),1);
//
//   }
//   @override
//   void onInit(){
//     _bookingStatusState = BooingListStatus.accepted;
//     super.onInit();
//     scrollController.addListener(() {
//       if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
//         if (_offset <= _bookingListPageSize) {
//           _isPaginationLoading=true;
//           bottomLoader();
//           update();
//           getBookingList( _bookingStatusState.name.toLowerCase(),_offset+1,isFromPagination: true);
//         }else{
//         }
//       }
//     });
//
//     bookingHistoryScrollController.addListener(() {
//       if (bookingHistoryScrollController.position.pixels == bookingHistoryScrollController.position.maxScrollExtent) {
//         if (_offset <= _bookingListPageSize) {
//           _isPaginationLoading=true;
//           update();
//           getBookingHistory(bookingHistoryStatus[_bookingHistorySelectedIndex],_offset+1,isFromPagination: true);
//         }else{
//         }
//       }
//     });
//
//   }
//
//
//   Future<void> getBookingList(String requestType, int offset, {bool isFromPagination = false, bool shouldUpdate = true})async{
//      _offset = offset;
//     if(!isFromPagination){
//       _bookingList=[];
//       _isFirst = true;
//     }
//      update();
//     Response response = await bookingRequestRepo.getBookingList(requestType.toLowerCase(), offset);
//     if(response.statusCode == 200){
//       _isLoading = false;
//       _isFirst = false;
//       response.body['content']['data'].forEach((item)=> _bookingList.add(BookingRequestModel.fromJson(item)));
//       _bookingListPageSize = response.body['content']['last_page'];
//     }else{
//       _isFirst = false;
//       _isLoading = false;
//       ApiChecker.checkApi(response);
//     }
//     update();
//   }
//
//
//   Future<void> getBookingHistory(String requestType, int offset, {bool isFromPagination = false})async{
//     _isLoading = true;
//     _isFirst = false;
//     _offset = offset;
//     if(!isFromPagination){
//       _isFirst = true;
//       _bookingHistoryList=[];
//     }
//     update();
//
//     Response response = await bookingRequestRepo.getBookingHistoryList(requestType.toLowerCase(),offset);
//     if(response.statusCode == 200){
//       if(!isFromPagination){
//         _bookingHistoryList=[];
//       }
//       List<dynamic> bookingList = response.body['content']['data'];
//       _bookingListPageSize = response.body['content']['last_page'];
//       for (var serviceman in bookingList) {
//         _bookingHistoryList.add(BookingRequestModel.fromJson(serviceman));
//       }
//       _isLoading = false;
//       _isFirst = false;
//       update();
//     } else{
//       ApiChecker.checkApi(response);
//       _isLoading = false;
//       _isFirst = false;
//       update();
//     }
//     update();
//   }
//
//   void updateBookingHistorySelectedIndex(int index){
//     _bookingHistorySelectedIndex = index;
//     update();
//   }
//
//   void bottomLoader(){
//     _isFirst = false;
//     _isLoading = true;
//     update();
//   }
//
// }



// import 'package:get/get.dart';
// import 'package:demandium_serviceman/utils/core_export.dart';
//
// class BookingRequestController extends GetxController implements GetxService {
//   final BookingRequestRepo bookingRequestRepo;
//   BookingRequestController({required this.bookingRequestRepo});
//
//   final ScrollController scrollController = ScrollController();
//   final ScrollController bookingHistoryScrollController = ScrollController();
//
//   List<String> bookingHistoryStatus = ["All", "Completed", "Canceled"];
//   List<String> bookingRequestList = ["accepted", "ongoing"];
//
//   // Time Slot Filtering
//   List<String> timeSlots = ['all','5am to 10am', '5pm to 10pm'];
//   String selectedTimeSlot = 'all';
//
//   void updateTimeSlotFilter(String slot) {
//     selectedTimeSlot = slot;
//     print('Selected time slot: $slot');
//
//     final filtered = filteredRepeatBookingList;
//     print('Filtered count: ${filtered.length}');
//     filtered.forEach((b) => print('→ ${b.id}, slot=${b.slot}'));
//
//     update();
//   }
//
//
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//
//   bool _isFirst = true;
//   bool get isFirst => _isFirst;
//
//   bool _isPaginationLoading = false;
//   bool get isPaginationLoading => _isPaginationLoading;
//
//   int _bookingListPageSize = 1;
//   int _offset = 1;
//   int get offset => _offset;
//
//   // Use this instead of BookingRequestModel
//   List<RepeatBooking> _repeatBookingList = [];
//
//   List<RepeatBooking> get filteredRepeatBookingList {
//     String normalize(String s) => s.toLowerCase().replaceAll(' ', '');
//
//     return _repeatBookingList.where((booking) {
//       final slot = booking.slot?.trim() ?? '';
//
//       if (normalize(selectedTimeSlot) == 'all') {
//         return true;
//       }
//
//       return normalize(slot) == normalize(selectedTimeSlot);
//     }).toList();
//   }
//
//
//   // List<String> timeSlots = ['all', '5am to 10pm', '5pm to 10pm'];
//   // String selectedTimeSlot = '5am to 10pm';    List<RepeatBooking> get filteredRepeatBookingList {
//   //   String normalize(String s) => s.toLowerCase().replaceAll(' ', '');
//   //
//   //   return _repeatBookingList.where((booking) {
//   //     final bSlot = booking.slot?.trim() ?? '';
//   //     if (bSlot.isEmpty) return false; // or return true to include empty
//   //
//   //     return normalize(bSlot) == normalize(selectedTimeSlot);
//   //   }).toList();
//   // }     /////with out all
//
//
//
//   List<BookingRequestModel> _bookingHistoryList = [];
//   List<BookingRequestModel> get bookingHistoryList => _bookingHistoryList;
//
//   int _bookingHistorySelectedIndex = 0;
//   int get bookingHistorySelectedIndex => _bookingHistorySelectedIndex;
//
//   String? requestType;
//   BooingListStatus get bookingStatusState => _bookingStatusState;
//
//   var _bookingStatusState = BooingListStatus.accepted;
//
//   void updateBookingStatusState(BooingListStatus booingListStatus) {
//     _bookingStatusState = booingListStatus;
//     update();
//     getBookingList(_bookingStatusState.name.toLowerCase(), 1);
//   }
//
//   @override
//   void onInit() {
//     _bookingStatusState = BooingListStatus.accepted;
//     super.onInit();
//
//     scrollController.addListener(() {
//       if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
//         if (_offset <= _bookingListPageSize) {
//           _isPaginationLoading = true;
//           bottomLoader();
//           update();
//           getBookingList(_bookingStatusState.name.toLowerCase(), _offset + 1, isFromPagination: true);
//         }
//       }
//     });
//
//     bookingHistoryScrollController.addListener(() {
//       if (bookingHistoryScrollController.position.pixels == bookingHistoryScrollController.position.maxScrollExtent) {
//         if (_offset <= _bookingListPageSize) {
//           _isPaginationLoading = true;
//           update();
//           getBookingHistory(bookingHistoryStatus[_bookingHistorySelectedIndex], _offset + 1, isFromPagination: true);
//         }
//       }
//     });
//   }
//
//   Future<void> getBookingList(String requestType, int offset,
//       {bool isFromPagination = false, bool shouldUpdate = true}) async {
//     _offset = offset;
//     if (!isFromPagination) {
//       _repeatBookingList = [];
//       _isFirst = true;
//     }
//     update();
//
//     Response response = await bookingRequestRepo.getBookingList(requestType.toLowerCase(), offset,);
//     if (response.statusCode == 200) {
//       _isLoading = false;
//       _isFirst = false;
//       List<dynamic> data = response.body['content']['data'];
//       for (var item in data) {
//         _repeatBookingList.add(RepeatBooking.fromJson(item));
//       }
//       _bookingListPageSize = response.body['content']['last_page'];
//     } else {
//       _isFirst = false;
//       _isLoading = false;
//       ApiChecker.checkApi(response);
//     }
//     update();
//   }
//
//   Future<void> getBookingHistory(String requestType, int offset, {bool isFromPagination = false}) async {
//     _isLoading = true;
//     _isFirst = false;
//     _offset = offset;
//
//     if (!isFromPagination) {
//       _isFirst = true;
//       _bookingHistoryList = [];
//     }
//     update();
//
//     Response response = await bookingRequestRepo.getBookingHistoryList(requestType.toLowerCase(), offset);
//     if (response.statusCode == 200) {
//       if (!isFromPagination) {
//         _bookingHistoryList = [];
//       }
//       List<dynamic> bookingList = response.body['content']['data'];
//       _bookingListPageSize = response.body['content']['last_page'];
//       for (var serviceman in bookingList) {
//         _bookingHistoryList.add(BookingRequestModel.fromJson(serviceman));
//       }
//       _isLoading = false;
//       _isFirst = false;
//     } else {
//       ApiChecker.checkApi(response);
//       _isLoading = false;
//       _isFirst = false;
//     }
//     update();
//   }
//
//   void updateBookingHistorySelectedIndex(int index) {
//     _bookingHistorySelectedIndex = index;
//     update();
//   }
//
//   void bottomLoader() {
//     _isFirst = false;
//     _isLoading = true;
//     update();
//   }
// }



///////////////////////////



import 'package:get/get.dart';
import 'package:demandium_serviceman/utils/core_export.dart';
import 'package:intl/intl.dart';

class BookingRequestController extends GetxController implements GetxService {
  final BookingRequestRepo bookingRequestRepo;
  BookingRequestController({required this.bookingRequestRepo});

  final ScrollController scrollController = ScrollController();
  final ScrollController bookingHistoryScrollController = ScrollController();

  List<String> bookingHistoryStatus = ["All", "Completed", "Pending", "Canceled"];
  List<String> bookingRequestList = ["accepted", "ongoing"];

  // Filters
  List<String> timeSlots = ['all', '5am to 10pm', '5pm to 10pm'];
  List<String> serviceTypes = ['all', 'On Demand', 'Car Maintenance', 'Daily Car Wash'];

  String selectedTimeSlot = 'all';
  String selectedServiceType = 'all';
  String selectedStatus = 'All';

  // Date Filter
  DateTime? selectedDate;
  String get formattedSelectedDate => selectedDate != null
      ? DateFormat('yyyy-MM-dd').format(selectedDate!)
      : '';

  // Pagination and State
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isFirst = true;
  bool get isFirst => _isFirst;

  bool _isPaginationLoading = false;
  bool get isPaginationLoading => _isPaginationLoading;

  int _bookingListPageSize = 1;
  int offset = 1; // Made public

  List<RepeatBooking> _repeatBookingList = [];
  List<RepeatBooking> get repeatBookingList => _repeatBookingList;

  List<BookingRequestModel> _bookingHistoryList = [];
  List<BookingRequestModel> get bookingHistoryList => _bookingHistoryList;

  int _bookingHistorySelectedIndex = 0;
  int get bookingHistorySelectedIndex => _bookingHistorySelectedIndex;

  BooingListStatus _bookingStatusState = BooingListStatus.pending;
  BooingListStatus get bookingStatusState => _bookingStatusState;

  // --- Filter updaters ---
  void updateTimeSlotFilter(String slot) {
    selectedTimeSlot = slot;
    update();
  }

  void updateServiceTypeFilter(String type) {
    selectedServiceType = type;
    update();
  }

  void updateStatusFilter(String status) {
    selectedStatus = status;
    update();
    getBookingList(
      _getFilteredStatus(),
      1,
    );
  }

  void updateSelectedDate(DateTime? date) {
    selectedDate = date;
    update();
    getBookingList(
      _getFilteredStatus(),
      1,
    );
  }

  void updateBookingStatusState(BooingListStatus status) {
    _bookingStatusState = status;
    update();
    getBookingList(_bookingStatusState.name.toLowerCase(), 1);
  }

  void updateBookingHistorySelectedIndex(int index) {
    _bookingHistorySelectedIndex = index;
    update();
  }

  // --- Controller lifecycle ---
  @override
  void onInit() {
    super.onInit();
    _bookingStatusState = BooingListStatus.pending;

    if (_normalize(selectedServiceType) == 'all') {
      selectedDate = null;
    } else {
      selectedDate = DateTime.now();
    }

    getBookingList(_bookingStatusState.name.toLowerCase(), 1);

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (offset <= _bookingListPageSize) {
          _isPaginationLoading = true;
          bottomLoader();
          update();
          getBookingList(_getFilteredStatus(), offset + 1, isFromPagination: true);
        }
      }
    });

    bookingHistoryScrollController.addListener(() {
      if (bookingHistoryScrollController.position.pixels == bookingHistoryScrollController.position.maxScrollExtent) {
        if (offset <= _bookingListPageSize) {
          _isPaginationLoading = true;
          update();
          getBookingHistory(bookingHistoryStatus[_bookingHistorySelectedIndex], offset + 1, isFromPagination: true);
        }
      }
    });
  }

  void resetFiltersForAllService() {
    selectedServiceType = 'all';
    selectedDate = null;
    selectedStatus = 'All';
    offset = 1;
    update();
    getBookingList(_bookingStatusState.name.toLowerCase(), 1);
  }

  // --- API Call ---
  Future<void> getBookingList(String requestType, int newOffset,
      {bool isFromPagination = false}) async {
    offset = newOffset;
    if (!isFromPagination) {
      _repeatBookingList = [];
      _isFirst = true;
    }

    update();

    Response response = await bookingRequestRepo.getBookingList(
      requestType.toLowerCase(),
      offset,
    );

    if (response.statusCode == 200) {
      _isLoading = false;
      _isFirst = false;

      List<dynamic> data = response.body['content']['data'];
      for (var item in data) {
        _repeatBookingList.add(RepeatBooking.fromJson(item));
      }

      _bookingListPageSize = response.body['content']['last_page'];
    } else {
      _isLoading = false;
      _isFirst = false;
      ApiChecker.checkApi(response);
    }

    update();
  }

  Future<void> getBookingHistory(String requestType, int newOffset, {bool isFromPagination = false}) async {
    offset = newOffset;
    _isLoading = true;
    _isFirst = !isFromPagination;

    if (!isFromPagination) {
      _bookingHistoryList = [];
    }

    update();

    Response response = await bookingRequestRepo.getBookingHistoryList(requestType.toLowerCase(), offset);

    if (response.statusCode == 200) {
      List<dynamic> bookingList = response.body['content']['data'];
      _bookingListPageSize = response.body['content']['last_page'];

      if (!isFromPagination) {
        _bookingHistoryList = [];
      }

      for (var serviceman in bookingList) {
        _bookingHistoryList.add(BookingRequestModel.fromJson(serviceman));
      }

      _isLoading = false;
      _isFirst = false;
    } else {
      _isLoading = false;
      _isFirst = false;
      ApiChecker.checkApi(response);
    }

    update();
  }

  void bottomLoader() {
    _isFirst = false;
    _isLoading = true;
    update();
  }

  // --- Utility ---
  String _normalize(String s) => s.toLowerCase().replaceAll(' ', '');

  String _getFilteredStatus() {
    final normalized = selectedStatus.toLowerCase();
    if (normalized == 'all') return _bookingStatusState.name.toLowerCase();
    if (normalized == 'pending') return 'accepted';
    return normalized;
  }
}



