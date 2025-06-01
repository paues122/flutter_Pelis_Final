import 'package:flutter/material.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:tap2025/utils/global_values.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SidebarX(
        headerBuilder: (context, extended) {
          return UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.blueGrey[700]),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
            ),
            accountName: Text('Paulina Escalantes', style: TextStyle(color: Colors.grey[100])),
            accountEmail: Text('pauesc122@gmail.com', style: TextStyle(color: Colors.grey[100])),
          );
        },
        extendedTheme: SidebarXTheme(
          width: 250,
          selectedIconTheme: IconThemeData(color: Colors.white),
          selectedTextStyle: TextStyle(color: Colors.white),
          textStyle: TextStyle(color: Colors.teal[300]),
          iconTheme: IconThemeData(color: Colors.teal[300]),
        ),
        controller: SidebarXController(selectedIndex: 0, extended: true),
        items: [
          SidebarXItem(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/reto');
            },
            icon: Icons.home,
            label: 'Challenge Pelis',
          ),
          SidebarXItem(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/api');
            },
            icon: Icons.movie,
            label: 'Pelis populares',
          ),
          SidebarXItem(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/favorites');
            },
            iconWidget: Icon(Icons.favorite, color: Colors.pink[300]),
            label: 'Favoritas',
          ),
        ],
      ),
      appBar: AppBar(
        title: Text('Panel principal'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: HawkFabMenu(
        icon: AnimatedIcons.menu_arrow,
        body: Center(
          child: Text('LOGIN', style: TextStyle(color: Colors.teal[700])),
        ),
        items: [
          HawkFabMenuItem(
            label: 'Theme Light',
            ontap: () => GlobalValues.themeMode.value = 1,
            icon: const Icon(Icons.light_mode),
          ),
          HawkFabMenuItem(
            label: 'Theme Dark',
            ontap: () => GlobalValues.themeMode.value = 0,
            icon: const Icon(Icons.dark_mode),
          ),
          HawkFabMenuItem(
            label: 'Theme Warm',
            ontap: () => GlobalValues.themeMode.value = 2,
            icon: const Icon(Icons.hot_tub),
          ),
        ],
      ),
    );
  }
}