import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'video_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import '../provider/provider.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino widgets

class MainScreen extends ConsumerStatefulWidget {
  final ValueNotifier<bool> isVideoTabActive = ValueNotifier<bool>(true);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.isVideoTabActive.value = true; // Initially, the video tab is active
  }

  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('VMTok'),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          //VideoPlayerScreen(isVideoTabActive: widget.isVideoTabActive),
          ProfileScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            widget.isVideoTabActive.value = index == 0;
          });
        },
        items: [
          //BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.person)),
          BottomNavigationBarItem(icon: Icon(Icons.settings)),
        ],
      ),
    );
  }
}
