import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:raskara_boutique/screens/dashboard_screen.dart';
import 'package:raskara_boutique/screens/history_screen.dart';
import 'package:raskara_boutique/screens/transaction_screen.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'services/auth_service.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: RaskaraApp(),
    ),
  );
}

class RaskaraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raskara Boutique',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: SplashScreen(), 
    );
  }
}

class MyRaskaraNavigation extends StatefulWidget {
  @override
  _MyRaskaraNavigationState createState() => _MyRaskaraNavigationState();
}

class _MyRaskaraNavigationState extends State<MyRaskaraNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(),
    TransactionScreen(),
    HistoryScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: SafeArea(
        bottom: false,
        child: Container(
          height: 70 + MediaQuery.of(context).viewPadding.bottom,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: [
              _buildNavItem('assets/images/nav_home.svg', "Dashboard", 0),
              _buildNavItem('assets/images/nav_transaction.svg', "Transaksi", 1),
              _buildNavItem('assets/images/nav_history.svg', "Histori", 2),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      String iconPath, String label, int index) {
    bool isSelected = _currentIndex == index;
    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple.shade100 : Colors.transparent,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SvgPicture.asset(
          iconPath,
          width: 24,
          height: 24,
          color: Colors.black,
        ),
      ),
      label: label,
    );
  }
}