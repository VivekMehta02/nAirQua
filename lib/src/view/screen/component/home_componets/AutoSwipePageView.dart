import 'dart:async';
import 'package:flutter/material.dart';
import 'package:n_air_qua/src/view/screen/component/home_componets/body_item.dart';

class AutoSwipePageView extends StatefulWidget {
  @override
  _AutoSwipePageViewState createState() => _AutoSwipePageViewState();
}

class _AutoSwipePageViewState extends State<AutoSwipePageView> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  final int _totalPages = 2; // Number of pages/cards

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _startAutoSwipe();
  }

  void _startAutoSwipe() {
    _timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      if (_currentPage < _totalPages - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: _totalPages,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(10),
          // child: BodyItem(), // Replace with your HeaderPage or content
        );
      },
    );
  }
}
