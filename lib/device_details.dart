import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:batteryplus/screens/DeviceInfo.dart';
import 'package:batteryplus/screens/BatteryInfo.dart';

class DeviceDetails extends StatefulWidget {
  const DeviceDetails({Key? key}) : super(key: key);

  @override
  State<DeviceDetails> createState() => _DeviceDetailsState();
}

class _DeviceDetailsState extends State<DeviceDetails> {
  int _selectedIndex = 0;

  final List<Widget> _children = [
    const BatteryInfoList(),
    const DeviceInfoList(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.bolt),
            label: 'Battery Info',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.mobile),
            label: 'Device Info',
          ),
        ],
        currentIndex: _selectedIndex,
        // selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
