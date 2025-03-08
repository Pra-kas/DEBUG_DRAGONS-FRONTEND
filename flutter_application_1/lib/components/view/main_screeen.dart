import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/view/analytics/analytics_view.dart';
import 'package:flutter_application_1/components/view/expenses/expenses_view.dart';
import 'package:flutter_application_1/components/view/settings/settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../service/notification_service.dart';
import '../../theme/colors.dart';
import '../bloc/main_screen_bloc/main_screen_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  List<Widget> mainScreens = [
    ExpensesView(),
    AnalyticsView(),
    ProfilePage(),
  ];
  MainScreenBloc mainScreenBloc = MainScreenBloc();
  int selectedIndex = 0;

  void _onTap(int index) {
    mainScreenBloc.add(MainScreenBottomNavigationBarSwitchingEvent(index));
  }

  @override
  void initState() {
    // TODO: implement initState
    getFirebaseNotification();
    super.initState();
  }

  Future<void> getFirebaseNotification() async {
    await NotificationService.instance.initialize(context);
    NotificationSettings settings =
    await FirebaseMessaging.instance.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
      settings = await FirebaseMessaging.instance.requestPermission();
    }

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Has permission");
      // do api call to backend to create FCM
    } else {

    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainScreenBloc, MainScreenState>(
      bloc: mainScreenBloc,
      listener: (context, state) {
        if (state is MainScreenBottomNavigationBarSwitchingState) {
          selectedIndex = state.index;
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: bgColor,
          body: mainScreens[selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white, // Light theme background
            currentIndex: selectedIndex,
            onTap: _onTap,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blueAccent, // Active item color
            unselectedItemColor: Colors.grey, // Inactive item color
            showSelectedLabels: true,
            showUnselectedLabels: false,
            elevation: 8, // Adds a floating effect
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  selectedIndex == 0 ? Icons.money : Icons.money_off,
                  size: selectedIndex == 0 ? 30 : 24, // Scale effect
                ),
                label: "Expenses",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  selectedIndex == 1 ? Icons.analytics : Icons.analytics_outlined,
                  size: selectedIndex == 1 ? 30 : 24,
                ),
                label: "Analytics",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  selectedIndex == 2 ? Icons.settings : Icons.settings_outlined,
                  size: selectedIndex == 2 ? 30 : 24,
                ),
                label: "Settings",
              ),
            ],
          ),
        );
      },
    );
  }
}
