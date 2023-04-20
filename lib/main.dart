import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lazy_load_app/registration/tab1.dart';
import 'package:lazy_load_app/registration/tab2.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Loginpage(),
    ),
  );
}

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  getConnectivity() => subscription = Connectivity()
      .onConnectivityChanged
      .listen((ConnectivityResult result) async {
    isDeviceConnected = await InternetConnectionChecker().hasConnection;
    if (!isDeviceConnected && isAlertSet == false) {
      showDialogBox();
      setState(() => isAlertSet = true);
    }
  });

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    0,
                    150,
                    0,
                    0,
                  ),
                  // child: SizedBox(
                  //   width: 100,
                  //   height: 100,
                  //   child: Image(
                  //     image: AssetImage(
                  //       'images/infinity (1).png',
                  //     ),
                  //   ),
                  // ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children:  const [
                      TabBar(
                        labelStyle: TextStyle(fontSize: 20.0),
                        isScrollable: true,
                        labelColor: Colors.orange,
                        unselectedLabelColor: Colors.black,
                        labelPadding:
                        EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        indicatorColor: Colors.orange,
                        indicatorWeight: 2,
                        tabs: [
                          Tab(
                            text: 'Sign In',
                          ),
                          Tab(
                            text: 'Sign Up',
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(30.0),
                        child: SizedBox(
                          height: 400,
                          child: TabBarView(
                            children: [Tab1(), Tab2()],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDialogBox() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('No Connection'),
        content: const Text('Please check internet connectivity'),
        actions: [
          TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                isDeviceConnected =
                await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('Ok'))
        ],
      ),
    );
  }
}

