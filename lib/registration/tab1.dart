import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../lazy_new.dart';
import 'Auth.dart';

class Tab1 extends StatefulWidget {
  const Tab1({Key? key}) : super(key: key);

  @override
  State<Tab1> createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> {
  bool passwordVisibility = true;
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passWordTextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String email;
  final auth = FirebaseAuth.instance;
  var isDeviceConnected = false;
  StreamSubscription<ConnectivityResult>? subscription;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {});
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                controller: emailTextEditingController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Colors.red, width: 2.0),
                  ),
                  enabledBorder: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.orange, width: 2.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  // fillColor: Colors.white,
                  prefixIcon: const Icon(
                    Icons.account_circle_sharp,
                    color: Colors.orange,
                  ),
                  labelText: 'Email ',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              // controller: _emailController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },

              controller: passWordTextEditingController,
              obscureText: passwordVisibility,
              decoration: InputDecoration(
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.red, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                prefixIcon: const Icon(
                  Icons.lock,
                  color: Colors.orange,
                ),
                labelText: 'Password',
                labelStyle: const TextStyle(
                  color: Colors.black,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      passwordVisibility = !passwordVisibility;
                    });
                  },
                  icon: Icon(
                    passwordVisibility
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: passwordVisibility ? Colors.grey : Colors.orange,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 15,
                  backgroundColor: Colors.orange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 38, vertical: 12),
                  //  shape: StadiumBorder()
                ),
                onPressed: () {
                  Auth()
                      .signInWithEmailAndPassword(
                          emailTextEditingController.text, //parameter
                          passWordTextEditingController.text)
                      .then((value) async {
                    isConnected = await checkInternetConnection();
                    if (isConnected) {
                      if (value == null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Lazyy_New(title: 'Lazy Load',)),
                        );
                        // const snackbar = SnackBar(
                        //   content: Text("Login Success"),
                        //   backgroundColor: Colors.orange,
                        // );
                         //ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        Fluttertoast.showToast(
                          msg: 'Login Success',
                          toastLength: Toast.LENGTH_SHORT,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16,
                        );
                      } else {
                        const snackbar = SnackBar(
                          content: Text("Wrong email/password"),
                          backgroundColor: Colors.orange,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      }
                    } else {
                      final snackBar = const SnackBar(
                        content: Text('No internet connection'),
                        backgroundColor: Colors.red,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  });
                },
                child: const Text(
                  'Log in',
                  style: TextStyle(fontSize: 19),
                ),
              ),
            ),
            // TextButton(
            //   style: TextButton.styleFrom(
            //     foregroundColor: Colors.black,
            //     padding: const EdgeInsets.only(bottom: 20.0),
            //     textStyle: const TextStyle(fontSize: 19),
            //   ),
            //   onPressed: () {
            //     Auth().resetpassword(email);
            //     Navigator.pop(context);
            //   },
            //   child: const Text('Reset Password'),
            // ),
          ],
        ),
      ),
    );
  }
}
