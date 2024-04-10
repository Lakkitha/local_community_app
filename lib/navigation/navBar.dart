import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/createEventPage.dart';
import '../pages/eventPage.dart';
import '../pages/profilePage.dart';
import '../pages/addEventsPage.dart';


class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
            () =>
            NavigationBar(
              height: 80,
              elevation: 0,
              selectedIndex: controller.selectedIndex.value,
              onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
              // Add the Icons and Labels for the Navigation Bar
              destinations: const [
                NavigationDestination(icon: Icon(Icons.event), label: 'Events'),
                NavigationDestination(icon: Icon(Icons.create), label: 'Add Event'),
                NavigationDestination(icon: Icon(Icons.account_circle), label: 'Profile')
              ],

            ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
  //set the pages here
    const EventPage(),
    AddEventPage(),
    const ProfilePage()
  ];
}