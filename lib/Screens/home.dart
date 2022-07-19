import 'package:blog_app/Screens/feed.dart';
import 'package:blog_app/Screens/profile.dart';
import 'package:blog_app/Screens/upload_blog.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int currentIndex = 0;
  final screens = [
    FeedScreen(),
    UploadBlogScreen(),
    ProfileScreen()
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Blog App'),
        backgroundColor: Colors.green[400],
        centerTitle: true,
      ),

      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index){
          setState(() {
          currentIndex = index;
        });} ,
        selectedItemColor: Colors.blue,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.timeline),
          label: 'Feed'
          ),
          BottomNavigationBarItem(icon: Icon(Icons.camera),
          label: 'Upload Post'
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person),
          label: 'Profile'
          )
        ],
      ),
    );
  }
}
