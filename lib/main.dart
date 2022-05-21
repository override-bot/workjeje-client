import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:workjeje/core/services/location.dart';
import 'package:workjeje/core/services/notification_helper.dart';
import 'package:workjeje/core/viewmodels/bids_view_model.dart';
import 'package:workjeje/core/viewmodels/client_view_model.dart';
import 'package:workjeje/core/viewmodels/contract_view_model.dart';
import 'package:workjeje/core/viewmodels/gallery_view_model.dart';
import 'package:workjeje/core/viewmodels/jobs_view_models.dart';
import 'package:workjeje/core/viewmodels/providers_view_model.dart';
import 'package:workjeje/core/viewmodels/rate_card_view_model.dart';
import 'package:workjeje/core/viewmodels/review_view_model.dart';
import 'package:workjeje/core/viewmodels/schedule_view_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/double_mode_implementation/theme_provider.dart';
import 'core/services/authentication.dart';
import 'core/services/messaging_service.dart';
import 'ui/views/intro_view.dart';

MessagingService _messagingService = MessagingService();
NotificationHelper _helper = NotificationHelper();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await _messagingService.init();
  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print(message.notification!.title);
  }
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeProvider themeProvider = ThemeProvider();
  JobViewModel jobViewModel = JobViewModel();
  ContractViewModel contractViewModel = ContractViewModel();
  ReviewViewModel reviewViewModel = ReviewViewModel();
  ProviderViewModel providerViewModel = ProviderViewModel();
  ClientViewModel clientViewModel = ClientViewModel();
  BidsViewModel bidsViewModel = BidsViewModel();
  ScheduleViewModel scheduleViewModel = ScheduleViewModel();
  RateCardViewModel rateCardViewModel = RateCardViewModel();
  GalleryViewModel galleryViewModel = GalleryViewModel();
  LocationService locationService = LocationService();
  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    getLocation();
    _helper.updateToken(_messagingService.token);
  }

  void getCurrentAppTheme() async {
    themeProvider.darkTheme = await themeProvider.themePreference.getTheme();
  }

  void getLocation() async {
    final User? user = auth.currentUser;
    Position position = await locationService.getPosition();
    locationService.userLat = position.latitude;
    locationService.userLong = position.longitude;
    List<Placemark> addresses =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    var first = addresses.first;
    locationService.location = first.locality;
    FirebaseFirestore.instance.collection("clients").doc(user!.uid).update({
      "userLat": position.latitude,
      "userLong": position.longitude,
      "location": first.locality
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return ThemeProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return jobViewModel;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return contractViewModel;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return reviewViewModel;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return providerViewModel;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return locationService;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return clientViewModel;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return bidsViewModel;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return galleryViewModel;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return scheduleViewModel;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return rateCardViewModel;
          },
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'workjeje',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: IntroScreen(),
      ),
    );
  }
}
