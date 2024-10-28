// ignore_for_file: deprecated_member_use

import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timetable_generation_application/constants/app_colors.dart';
import 'package:timetable_generation_application/screens/cource_screen.dart';
import 'package:timetable_generation_application/screens/staff_screen.dart';
import 'package:timetable_generation_application/screens/subject_screen.dart';
import 'package:timetable_generation_application/screens/timetable_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    const CourseScreen(),
    const SubjectScreen(),
    const StaffScreen(),
    const TimetableScreen()
  ];

  void _onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        physics: const PageScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: FlashyTabBar(
        items: [
          FlashyTabBarItem(
            icon: const FaIcon(
              FontAwesomeIcons.graduationCap, // Course icon
              color: AppColors.primary
            ),
            title: const Text(
              'Course',
              style: TextStyle(color: AppColors.primaryDark),
            ),
          ),
          FlashyTabBarItem(
            icon: const FaIcon(
              FontAwesomeIcons.book, // Subject icon
              color: AppColors.primary,
            ),
            title: const Text(
              'Subject',
              style: TextStyle(color: AppColors.primaryDark),
            ),
          ),
          FlashyTabBarItem(
            icon: const FaIcon(
              FontAwesomeIcons.chalkboardTeacher, // Staff icon
              color: AppColors.primary,
            ),
            title: const Text(
              'Staff',
              style: TextStyle(color: AppColors.primaryDark),
            ),
          ),
          FlashyTabBarItem(
            icon: const FaIcon(
              FontAwesomeIcons.calendarAlt, // Timetable icon
              color: AppColors.primary,
            ),
            title: const Text(
              'Timetable',
              style: TextStyle(color: AppColors.primaryDark),
            ),
          ),
        ],
        onItemSelected: (value) {
          _onTapped(value);
        },
        selectedIndex: _selectedIndex,
        showElevation: true,
      ),
    );
  }
}
