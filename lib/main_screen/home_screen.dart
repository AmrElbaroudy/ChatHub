import 'package:chat_hub/main_screen/chats_screen.dart';
import 'package:chat_hub/main_screen/people_screen.dart';
import 'package:chat_hub/utilites/assets_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'groups_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final pageController = PageController(initialPage: 0);
int currentIndex = 0;
final List<Widget> pages = const [
 ChatsScreen(),
  GroupsScreen(),
  PeopleScreen(),
];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatHub'),
        actions:const [
          Padding(
            padding: EdgeInsets.all(8.0),

            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              backgroundImage: AssetImage(AssetsManager.userImage),
            ),
          )
        ],
      ),
      body: PageView(

        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
          children: pages
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_2_fill),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_3_fill),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.globe),
            label: 'People',
          ),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          setState(() {
            currentIndex = index;
          });
          print('currentIndex: $currentIndex');
        },
      )
    );
  }
}
