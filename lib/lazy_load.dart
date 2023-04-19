// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class LazyLoadd extends StatefulWidget {
//   @override
//   _LazyLoaddState createState() => _LazyLoaddState();
// }
//
// class _LazyLoaddState extends State<LazyLoadd> {
//   final _scrollController = ScrollController();
//   final _limit = 4;
//   List<DocumentSnapshot> _documents = [];
//   bool _isLoading = false;
//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         _fetchData();
//     }});
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _fetchData() async {
//     if (_isLoading) {
//       return;
//     }
//     setState(() {
//       _isLoading = true;
//     });
//     QuerySnapshot querySnapshot;
//     if (_documents.isEmpty) {
//       querySnapshot = await FirebaseFirestore.instance
//           .collection('Dynamic-Images')
//         //  .orderBy('timestamp', descending: true)
//           .limit(_limit)
//           .get();
//      }
//       else {
//       querySnapshot = await FirebaseFirestore.instance
//           .collection('Dynamic-Images')
//           //.orderBy('timestamp', descending: true)
//           .startAfterDocument(_documents.last)
//           .limit(_limit)
//           .get();
//       }
//     setState(() {
//       _documents.addAll(querySnapshot.docs);
//       _isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView.builder(
//         controller: _scrollController,
//         itemCount: _documents.length + 1,
//         itemBuilder: (BuildContext context, int index) {
//           if (index == _documents.length) {
//             return _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : const SizedBox.shrink();
//           }
//           final document = _documents[index];
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Ink.image(
//               image: NetworkImage(document['image']),
//               fit: BoxFit.cover,
//               width: double.infinity,
//               height: 200,
//          //   onTap: () => print('Image tapped'),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
//

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'internet_not_connected.dart';
import 'main.dart';

class LazyLoadd extends StatefulWidget {
  @override
  _LazyLoaddState createState() => _LazyLoaddState();
}

class _LazyLoaddState extends State<LazyLoadd> {

  final _scrollController = ScrollController();
  final _limit = 4;
  final List<DocumentSnapshot> _documents = [];
  bool _isLoading = false;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    if (_isLoading) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    isConnected = await checkInternetConnection();
    if (!isConnected) {
     // const CupertinoActivityIndicator();
      const InternetNotAvailable();
      setState(() {
        _isLoading = false;
      });
      return;
    }
    QuerySnapshot querySnapshot;
    if (_documents.isEmpty) {
      querySnapshot = await FirebaseFirestore.instance
          .collection('Dynamic-Images')
          //  .orderBy('timestamp', descending: true)
          .limit(_limit)
          .get();
    } else {
      querySnapshot = await FirebaseFirestore.instance
          .collection('Dynamic-Images')
          //.orderBy('timestamp', descending: true)
          .startAfterDocument(_documents.last)
          .limit(_limit)
          .get();
    }
    setState(() {
      _documents.addAll(querySnapshot.docs);
      _isLoading = false;
    });
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Lazy Loading'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Loginpage()));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // LazyLoadScrollView(
            //   scrollOffset: 100,
            //   onEndOfPage: () {
            //     _isLoading;
            //   },
            //  child:
        ListView.builder(
                controller: _scrollController,
                itemCount: _documents.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == _documents.length) {
                    return _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : const SizedBox.shrink();
                  }
                  final document = _documents[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Ink.image(
                      image: NetworkImage(document['image']),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                      //   onTap: () => print('Image tapped'),
                    ),
                  );
                },
              ),

            if (!isConnected)
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CircularProgressIndicator(),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: isConnected ? null : const InternetNotAvailable(),
            ),
          ],
        ),
      ),
    );
  }
}

