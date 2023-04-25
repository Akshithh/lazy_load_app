import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lazy_load_app/lazy_new.dart';
import 'Auth.dart';

class Tab2 extends StatefulWidget {
  const Tab2({Key? key}) : super(key: key);

  @override
  State<Tab2> createState() => _Tab2State();
}

class _Tab2State extends State<Tab2> {
  bool passwordVisibility = true;
  bool confirmpasswordVisibility = true;
  bool isConnected = true;

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passWordTextEditingController = TextEditingController();
  TextEditingController confirmPassWordTextEditingController =
      TextEditingController();

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
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: TextFormField(
            controller: emailTextEditingController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 2.0),
                borderRadius: BorderRadius.circular(12.0),
              ),
              prefixIcon: const Icon(
                Icons.account_circle_sharp,
                color: Colors.orange,
              ),
              labelText: 'Email ',
              labelStyle: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
          controller: passWordTextEditingController,
          obscureText: passwordVisibility,
          decoration: InputDecoration(
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
                passwordVisibility ? Icons.visibility_off : Icons.visibility,
                color: passwordVisibility ? Colors.grey : Colors.orange,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            return null;
          },
          controller: confirmPassWordTextEditingController,
          obscureText: confirmpasswordVisibility,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 2.0),
              borderRadius: BorderRadius.circular(12.0),
            ),
            prefixIcon: const Icon(
              Icons.lock,
              color: Colors.orange,
            ),
            labelText: 'Confirm Password',
            labelStyle: const TextStyle(
              color: Colors.black,
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(
                  () {
                    confirmpasswordVisibility = !confirmpasswordVisibility;
                  },
                );
              },
              icon: Icon(
                confirmpasswordVisibility
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: confirmpasswordVisibility ? Colors.grey : Colors.orange,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 20,
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              //  shape: StadiumBorder()
            ),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const FirstPage()),
              // );
              if (passWordTextEditingController.text ==
                  confirmPassWordTextEditingController.text) {
                Auth()
                    .signUpWithEmailAndPassword(
                        emailTextEditingController.text, //parameter
                        passWordTextEditingController.text)
                    .then((value) async {
                  isConnected = await checkInternetConnection();
                  if (isConnected) {
                    if (value == null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Lazyy_New(
                                    title: 'Lazy Load ',
                                  )));
                      Fluttertoast.showToast(
                        msg: 'Account Created',
                        toastLength: Toast.LENGTH_SHORT,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16,
                      );
                    } else {
                      final snackbar = SnackBar(
                          content: Text("Wrong email/password"),
                          backgroundColor: Colors.orange);
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
              } else {
                (passWordTextEditingController.text !=
                    confirmPassWordTextEditingController.text);
                final snackbar = SnackBar(
                    content: Text("Wrong confirm password"),
                    backgroundColor: Colors.orange);
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
            },
            child: const Text(
              'Create account',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}
