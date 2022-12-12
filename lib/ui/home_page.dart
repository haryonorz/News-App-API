import 'dart:io';

import '../common/styles.dart';
import '../data/api/api_service.dart';
import '../provider/news_provider.dart';
import '../ui/article_list_page.dart';
import '../ui/settings_page.dart';
import '../widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;
  static const String _headlineText = 'Headline';

  // Jika kita bandingkan pada codelab News API, terdapat perbedaan pada kelas
  // HomePage. Di sini sebelum kita mengakses kelas ArticleListPage, kita harus
  // membungkusnya terlebih dahulu menggunakan kelas ChangeNotifierProvider yang
  // disediakan oleh package provider.
  // Kenapa demikian? Guna mengambil data dari API kita menggunakan state
  // management Provider. Kemudian kita bisa mengakses kelas HomePage
  // dengan memanggilnya pada parameter child. Perlu Anda ingat bahwa Anda
  // perlu menambahkan parameter create yang bertipekan Function. P
  // ada properti create Anda memanggil kelas NewsProvider dengan nilai
  // dari parameternya adalah kelas ApiService().
  final List<Widget> _listWidget = [
    ChangeNotifierProvider<NewsProvider>(
      create: (_) => NewsProvider(apiService: ApiService()),
      child: const ArticleListPage(),
    ),
    const SettingsPage(),
  ];

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.news : Icons.public),
      label: _headlineText,
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.settings : Icons.settings),
      label: SettingsPage.settingsTitle,
    ),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: secondaryColor,
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: _onBottomNavTapped,
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: _bottomNavBarItems,
        activeColor: secondaryColor,
      ),
      tabBuilder: (context, index) {
        return _listWidget[index];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
