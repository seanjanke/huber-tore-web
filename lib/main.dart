import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tore_huber_web/screens/dashboard_screen.dart';
import 'package:tore_huber_web/screens/employee_screen.dart';
import 'package:tore_huber_web/screens/onboarding_screen.dart';
import 'package:tore_huber_web/screens/protocol_screen.dart';
import 'package:tore_huber_web/screens/service_report_screen.dart';
import 'package:tore_huber_web/widgets/constants.dart';
import 'package:tore_huber_web/widgets/drawer_list_tile.dart';
import 'package:tore_huber_web/widgets/drawer_tabs_small.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyA3Jl-2ZOM4sx_uHECQOKOAu-QyYuHkNiM",
        appId: "1:78616173744:web:c9df6e3c242931179baf75",
        messagingSenderId: "78616173744",
        projectId: "hubertore-4f831",
        storageBucket: "hubertore-4f831.appspot.com",
      ),
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Huber Tore",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: backgroundColor),
      home: const OnboardingScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List pages = const [
    Dashboard(),
    EmployeesScreen(),
    ProtocolScreen(),
    ServiceReportScreen(),
  ];

  int selectedTile = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Drawer(
                backgroundColor: darkGreyColor,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          DrawerHeader(
                            margin: const EdgeInsets.only(bottom: 30.0),
                            child: Image.asset(
                              "assets/logo.png",
                            ),
                          ),
                          MediaQuery.of(context).size.width > 1400
                              ? DrawerListTile(
                                  title: 'Dashboard',
                                  icon: Icons.dashboard,
                                  onPress: () {
                                    setState(() {
                                      selectedTile = 0;
                                    });
                                  },
                                  isSelected: selectedTile == 0,
                                )
                              : DrawerTabSmall(
                                  icon: Icons.dashboard,
                                  onPress: () {
                                    setState(() {
                                      selectedTile = 0;
                                    });
                                  },
                                  isSelected: selectedTile == 0,
                                ),
                          MediaQuery.of(context).size.width > 1400
                              ? DrawerListTile(
                                  title: 'Mitarbeiter',
                                  icon: Icons.groups,
                                  onPress: () {
                                    setState(() {
                                      selectedTile = 1;
                                    });
                                  },
                                  isSelected: selectedTile == 1,
                                )
                              : DrawerTabSmall(
                                  icon: Icons.groups,
                                  onPress: () {
                                    setState(() {
                                      selectedTile = 1;
                                    });
                                  },
                                  isSelected: selectedTile == 1,
                                ),
                          MediaQuery.of(context).size.width > 1400
                              ? DrawerListTile(
                                  title: 'Protokolle',
                                  icon: Icons.ballot_rounded,
                                  onPress: () {
                                    setState(() {
                                      selectedTile = 2;
                                    });
                                  },
                                  isSelected: selectedTile == 2,
                                )
                              : DrawerTabSmall(
                                  icon: Icons.ballot_rounded,
                                  onPress: () {
                                    setState(() {
                                      selectedTile = 2;
                                    });
                                  },
                                  isSelected: selectedTile == 2,
                                ),
                          MediaQuery.of(context).size.width > 1400
                              ? DrawerListTile(
                                  title: 'Serviceberichte',
                                  icon: Icons.assignment,
                                  onPress: () {
                                    setState(() {
                                      selectedTile = 3;
                                    });
                                  },
                                  isSelected: selectedTile == 3,
                                )
                              : DrawerTabSmall(
                                  icon: Icons.assignment,
                                  onPress: () {
                                    setState(() {
                                      selectedTile = 3;
                                    });
                                  },
                                  isSelected: selectedTile == 3,
                                ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OnboardingScreen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: MediaQuery.of(context).size.width > 1400
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.logout,
                                    color: lightGreyColor,
                                    size: 20.0,
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    'Logout',
                                    style: GoogleFonts.montserrat(
                                      color: lightGreyColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              )
                            : const Icon(
                                Icons.logout,
                                color: lightGreyColor,
                                size: 30.0,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: MediaQuery.of(context).size.width > 1400 ? 6 : 12,
              child: pages[selectedTile],
            ),
          ],
        ),
      ),
    );
  }
}
