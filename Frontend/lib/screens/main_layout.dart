import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'discover_screen.dart';
import 'community_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';
import 'mentor_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  final Color primaryGreen = const Color(0xFF2E5A40);

  final List<Widget> _pages = [
    const HomeScreen(),
    const DiscoverScreen(),
    const CommunityScreen(),
    const ChatScreen(),
    const ProfileScreen(),
    const MentorScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryGreen,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Discover'),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Komunitas'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.workspace_premium), label: 'Mentor'),
        ],
      ),
    );
  }
}
