library navigator;

import 'package:flutter/material.dart';

class NavigatorView extends StatefulWidget {
  const NavigatorView(
      {required this.widgetOptions,
      this.selectedIndex = 1,
      this.navigatorKeys = const {},
      super.key});

  @override
  State<NavigatorView> createState() => _NavigatorViewState();
  final List<Widget> widgetOptions;
  final Map<int, GlobalKey<NavigatorState>> navigatorKeys;
  final int selectedIndex;
}

class _NavigatorViewState extends State<NavigatorView> {
  int _selectedIndex = 1;
  Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
  };

  void _onItemTapped(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_outlined),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border_outlined),
            label: 'Favorites',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      body: buildNavigator(),
    );
  }

  Navigator buildNavigator() {
    return Navigator(
      requestFocus: false,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        return true;
      },
      key: widget.navigatorKeys[_selectedIndex],
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (_) => widget.widgetOptions.elementAt(_selectedIndex),
        );
      },
    );
  }
}
