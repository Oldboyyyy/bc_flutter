import 'package:bc_flutter/navigator/navigator.dart';
import 'package:bc_flutter/pages/home_page.dart';
import 'package:bc_flutter/pages/profile_page.dart';
import 'package:flutter/material.dart';

class BottomNavigator extends StatefulWidget {
  BottomNavigator({Key? key}) : super(key: key);

  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = Colors.blue;
  int _currentIndex = 0;
  static int initialPage = 0;

  final PageController pageController =
      PageController(initialPage: initialPage);

  late List<Widget> _pages;
  bool _hasBuild = false;

  @override
  Widget build(BuildContext context) {
    _pages = [HomePage(), ProfilePage()];
    if (!_hasBuild) {
      // 页面第一次打开时是哪一个tab
      BCNavigator.getInstance()
          .onBottomTabChange(initialPage, _pages[initialPage]);
      _hasBuild = true;
    }
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: _pages,
        onPageChanged: (index) => _onJumpTo(index, pageChange: true),
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          _bottomItem('首页', Icons.home, 0),
          _bottomItem('我的', Icons.account_box, 1)
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onJumpTo,
        selectedItemColor: _activeColor,
      ),
    );
  }

  _bottomItem(String title, IconData icon, int i) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _defaultColor,
      ),
      activeIcon: Icon(
        icon,
        color: _activeColor,
      ),
      label: title,
    );
  }

  void _onJumpTo(int index, {pageChange = false}) {
    if (!pageChange) {
      pageController.jumpToPage(index);
    } else {
      BCNavigator.getInstance().onBottomTabChange(index, _pages[index]);
    }
    setState(() {
      _currentIndex = index;
    });
  }
}
