
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hunt/auth/auth_view.dart';
import 'package:hunt/hunt_views/home_view.dart';
import 'package:hunt/hunt_views/map_view.dart';
import 'package:hunt/hunt_views/places_list_view.dart';
import 'package:hunt/hunt_views/profile_view.dart';
import 'package:hunt/hunt_views/leaderboard_view.dart';
import 'package:hunt/hunt_views/treasure_view.dart';
import 'package:hunt/views/login_view.dart';


class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const BottomNavBar();
          } else {
            return const AuthView();
          }
        },
      ),
    );
  }
}

//navigation drawer

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

   @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
             const UserAccountsDrawerHeader(
                accountName: Text('UserName'),
                accountEmail: Text('user@email.com'),
                currentAccountPicture: CircleAvatar(
                  child: FlutterLogo(size: 42),
                  backgroundColor: Colors.white,
                ),
              ),
              buildMenuItems(context),
            ],
          ),
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.home_outlined),
                title: Text('Home', style: TextStyle(fontSize: 18)),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const MainView(),
                  ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.update),
                title: Text('Updates', style: TextStyle(fontSize: 18)),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.notification_add),
                title: Text('Notifications', style: TextStyle(fontSize: 18)),
                onTap: () {},
              ),
              Divider(
                color: Colors.deepPurple,
                height: 20,
                thickness: 2,
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: Text('Settings', style: TextStyle(fontSize: 18)),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text('Logout', style: TextStyle(fontSize: 18)),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
              ),
            ],
          ),
        ),
      );
}

//bottom nav bar

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});
  

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  
  int _currentIndex = 0;
  final List<Widget> _views = [   
    const HomeView(), 
    PlacesListView(),  
    MapView(),     
    const ProfileView(),  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _views[_currentIndex],
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            gap: 2,
            padding: EdgeInsets.all(16),
            tabs: [
              GButton(
                icon: Icons.home,
                text: "Home",
                onPressed: () => _onTap(0),
              ),
              GButton(
                icon: Icons.location_city_outlined,
                text: "Locations",
                onPressed: () => _onTap(2),
              ),
              GButton(
                icon: Icons.map_rounded,
                text: "Map",
                onPressed: () => _onTap(1),
              ),
              
              GButton(
                icon: Icons.person,
                text: "Profile",
                onPressed: () => _onTap(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


