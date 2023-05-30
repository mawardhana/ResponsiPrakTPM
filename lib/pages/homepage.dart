import 'package:flutter/material.dart';
import 'package:responsitpm/pages/katalogpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    KatalogPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    // TODO: Implement your logout logic here
    // Example: Clear user session, navigate to login page, etc.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Valorant Agents'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
