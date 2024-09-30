import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:n_air_qua/const/app_colors.dart';
import 'package:n_air_qua/src/view/screen/report_tab.dart';
import 'package:n_air_qua/src/view/screen/alarm_tab.dart';
import 'package:n_air_qua/src/view/screen/setting_tab.dart';
import 'package:n_air_qua/src/view/screen/home_tab.dart';
import 'package:n_air_qua/src/viewmodel/bottom_navigate_provider.dart';
import 'package:provider/provider.dart';

import 'home_tab.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  List<Widget> page = [
    HomeTab(),
    const AlarmTab(),
    const ReportTab(),
    SettingTab(),
    // PersonalTab(),
  ];

  @override
  Widget build(BuildContext context) {
    var bottomProvider =
        Provider.of<BottomNavigationProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      body: page[bottomProvider.currentIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(12),
          topLeft: Radius.circular(12),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: AppColors.primaryColorGray,
          selectedItemColor: AppColors.primaryColorpurple,
          currentIndex: bottomProvider.currentIndex,
          onTap: (int index) {
            bottomProvider.changePageTab = index;
          },
          items: [
            BottomNavigationBarItem(
              icon: bottomProvider.currentIndex != 0
                  ? SvgPicture.asset('assets/image/home_inactive.svg')
                  : SvgPicture.asset('assets/image/home_active.svg'),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: bottomProvider.currentIndex != 1
                  ? SvgPicture.asset('assets/image/alarms_inactive.svg')
                  : SvgPicture.asset('assets/image/alarms_active.svg'),
              label: 'Alarms',
            ),
            BottomNavigationBarItem(
              icon: bottomProvider.currentIndex != 2
                  ? SvgPicture.asset('assets/image/report_inactive.svg')
                  : SvgPicture.asset('assets/image/report_active.svg'),
              label: 'Reports',
            ),
            BottomNavigationBarItem(
              icon: bottomProvider.currentIndex != 3
                  ? SvgPicture.asset('assets/image/setting_inactive.svg')
                  : SvgPicture.asset('assets/image/setting_active.svg'),
              label: 'Setting',
            ),
          ],
        ),
      ),
    );
  }
}
