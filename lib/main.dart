import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', 'High Importance Notifications',
    importance: Importance.max,
    showBadge: true,
    enableLights: true,
    playSound: true,
    ledColor: Colors.blue);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _messagingService.init(channel);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
  runApp(MyApp());
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
  NotificationHelper _helper = NotificationHelper();
  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    getLocation();
    getToken(_messagingService.token);
  }

  void getCurrentAppTheme() async {
    themeProvider.darkTheme = await themeProvider.themePreference.getTheme();
  }

  void getToken(token) {
    _helper.token = token;
    _helper.updateToken(token);
  }

  void getLocation() async {
    final User? user = auth.currentUser;
    LocationPermission perm = await locationService.getPerm();
    if (perm == LocationPermission.always ||
        perm == LocationPermission.whileInUse) {
      var position = await locationService.getPosition();

      locationService.userLat = position.latitude;
      locationService.userLong = position.longitude;
      List<Placemark> addresses =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      var first = addresses.first;
      locationService.location = first.locality ?? " ";
      if (user?.uid != null) {
        FirebaseFirestore.instance.collection("clients").doc(user?.uid).update({
          "userLat": position.latitude,
          "userLong": position.longitude,
          "location": first.locality
        });
      }
    } else {
      locationService.userLat = 0.0;
      locationService.userLong = 0.0;
      locationService.location = "please enable location permission";
      if (user?.uid != null) {
        FirebaseFirestore.instance.collection("clients").doc(user?.uid).update({
          "userLat": 0.0,
          "userLong": 0.0,
          "location": "Please enable location permission"
        });
      }
      print('denied');
    }
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
        Provider(
          create: (_) {
            return _helper;
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
