import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/HalamanProfil.dart';
import 'package:flutter_application_1/hal_utama_admin.dart';
import 'package:flutter_application_1/halamanlogin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'halamanutama.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int currentTab = 0;
  final List<Widget> screens = [
    const DesainHalamanUtama(),
    const HalamanUtamaAdmin(),
    const Profil()
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HalamanUtamaAdmin();

  @override
  void initState() {
    initLogin();
    super.initState();
  }

  String sesiLogin = '';

  Future initLogin() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      sesiLogin = sp.getString('sesi')!;
      if (sesiLogin == 'admin') {
        currentScreen = const HalamanUtamaAdmin();
      } else {
        currentScreen = const DesainHalamanUtama();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: () {},
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  minWidth: 40,
                  onPressed: () async {
                    setState(() {
                      if (sesiLogin == 'admin') {
                        currentScreen = const HalamanUtamaAdmin();
                      } else {
                        currentScreen = const DesainHalamanUtama();
                      }
                      currentTab = 0;
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.home,
                        size: 40,
                        color: currentTab == 0 ? Colors.red : Colors.blue,
                        shadows: [
                          currentTab == 0
                              ? const Shadow(
                                  offset: Offset(3.0, 3.0),
                                  blurRadius: 8.0,
                                  color: Colors.black,
                                )
                              : const Shadow(
                                  offset: Offset(3.0, 3.0),
                                  blurRadius: 3.0,
                                  color: Color(0xff007251),
                                ),
                        ],
                      ),
                      const Text('Home', style: TextStyle(color: Colors.black))
                    ],
                  ),
                ),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currentScreen = const Profil();
                      currentTab = 2;
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.person,
                        size: 40,
                        color: currentTab == 2 ? Colors.red : Colors.blue,
                        shadows: [
                          currentTab == 2
                              ? const Shadow(
                                  offset: Offset(3.0, 3.0),
                                  blurRadius: 8.0,
                                  color: Colors.black,
                                )
                              : const Shadow(
                                  offset: Offset(3.0, 3.0),
                                  blurRadius: 3.0,
                                  color: Color(0xff007251),
                                ),
                        ],
                      ),
                      const Text(
                        'Profile',
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
