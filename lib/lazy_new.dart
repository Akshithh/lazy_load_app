import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'internet_not_connected.dart';
import 'main.dart';

class Lazyy_New extends StatefulWidget {
  const Lazyy_New({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _Lazyy_NewState createState() => _Lazyy_NewState();
}

class _Lazyy_NewState extends State<Lazyy_New> {
  List<int> verticalData = [];
  bool isConnected = true;
  bool isLoadingVertical = false;
  final int increment = 5;

  List<DocumentSnapshot> imageDocuments = [];
  final _scrollController = ScrollController();
  final _limit = 4;
  bool _isLoading = false;

  @override
  void initState() {
    _fetchData();
    _loadMoreVertical();
    //  _loadMoreHorizontal();

    super.initState();
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
    if (imageDocuments.isEmpty) {
      querySnapshot = await FirebaseFirestore.instance
          .collection('Dynamic-Images')
          //  .orderBy('timestamp', descending: true)
          .limit(_limit)
          .get();
    } else {
      querySnapshot = await FirebaseFirestore.instance
          .collection('Dynamic-Images')
          //.orderBy('timestamp', descending: true)
          .startAfterDocument(imageDocuments.last)
          .limit(_limit)
          .get();
      if (querySnapshot.docs.isEmpty) {
        // All images have been fetched, start over again
        imageDocuments.length;
        querySnapshot = await FirebaseFirestore.instance
            .collection('Dynamic-Images')
            .limit(_limit)
            .get();
      }
    }
    setState(() {
      imageDocuments.addAll(querySnapshot.docs);
      _isLoading = false;
    });
  }

  Future _loadMoreVertical() async {
    setState(() {
      isLoadingVertical = true;
    });
    isConnected = await checkInternetConnection();
    if (!isConnected) {
      const InternetNotAvailable();
      setState(() {
        isLoadingVertical = false;
      });
      return;
    }

    // Add in an artificial delay
    await Future.delayed(const Duration(seconds: 1));

    //verticalData.addAll(List.generate(increment, (index) => verticalData.length + index));
    _fetchData();
    setState(() {
      isLoadingVertical = false;
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
            LazyLoadScrollView(
              isLoading: isLoadingVertical,
              onEndOfPage: () => _loadMoreVertical(),
              child: Scrollbar(
                child: ListView(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: imageDocuments.length + 1,
                      itemBuilder: (context, position) {
                        if (position == imageDocuments.length) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final document = imageDocuments[position];
                        return DemoItem(position, document);
                      },
                    ),
                  ],
                ),
              ),
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

class DemoItem extends StatelessWidget {
  final int position;
  final DocumentSnapshot<Object?> document;

  const DemoItem(
    this.position,
    this.document, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 150.0,
                    width: 250.0,
                    child: Ink.image(
                      image: NetworkImage(document['image']),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                      //   onTap: () => print('Image tapped'),
                    ),
                  ),
                  const SizedBox(width: 25.0),
                  Text(
                    "Item $position",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
              const Text('')
            ],
          ),
        ),
      ),
    );
  }
}
