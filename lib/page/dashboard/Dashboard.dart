import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_profile/page/dashboard/ChatScreen.dart';
import 'package:my_profile/utils/app_theme_data.dart';
import 'package:my_profile/utils/my_sharedpreference.dart';
import 'package:my_profile/utils/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  String userId;
  File _cameraVideo;
  final picker = ImagePicker();
  TextEditingController caption_controller = TextEditingController();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  VideoPlayerController _cameraVideoPlayerController;
  bool _isUploading = false;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  Future<DocumentSnapshot> getUserInformation;
  Future<List<DocumentSnapshot>> getUserVideo;

  int image_upload_count = 0;
  int max_upload_count = 0;

  List<String> ChatRoom = [];

  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  getUserId() {
    setState(() {
      userId = FirebaseAuth.instance.currentUser.uid;

      getUserInformation = user_information();

      MySharedPreferences.instance.getStringValue("role").then((value) => setState(() {
            if (value == "Level A") {
              ChatRoom.add("Group 1");
            } else if (value == "Level B") {
              ChatRoom.add("Group 2");
            } else if (value == "Level C") {
              ChatRoom.add("Group 1");
              ChatRoom.add("Group 2");
            }
          }));
    });
  }

  Future<DocumentSnapshot> user_information() async {
    final data = users.doc(FirebaseAuth.instance.currentUser.uid).get();
    data.then((value) async {
      print(value['fullname']);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("fullname", value['fullname']);
    });
    return data;
    //
    // prefs.setInt("counter", counter)
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            InkWell(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                SharedPreferences preferences = await SharedPreferences.getInstance();
                await preferences.clear();
                Navigator.of(context).pushReplacement(new WelcomeScreenRoute());
              },
              child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.exit_to_app),
              ),
            )
          ],
          title: Text("Dashboard", style: AppThemeData(context: context).myTextTheme.button),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "User Information",
                  style: AppThemeData(context: context).myTextTheme.headline1,
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            FutureBuilder<DocumentSnapshot>(
              future: getUserInformation,
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data = snapshot.data.data();
                  return userSection(data);
                }

                return Text("loading");
              },
            ),
            Divider(),
            Text("Chat Room"),
            Divider(),
            Container(
              height: 250,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: VideoSection(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget userSection(data) {
    return ListTile(
      title: Text(data['fullname']),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['email'],
            style: AppThemeData(context: context).myTextTheme.headline3,
          ),
          Text(
            data['role'],
            style: AppThemeData(context: context).myTextTheme.headline3,
          ),
          Text(
            data['uid'],
            style: AppThemeData(context: context).myTextTheme.headline3,
          ),
        ],
      ),
    );
  }

  Widget VideoSection() {
    return new ListView.builder(
      itemCount: ChatRoom.length,
      itemBuilder: (BuildContext ctxt, int index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ChatScreen(
                    group_name: ChatRoom[index],
                  );
                },
              ),
            );
          },
          child: ListTile(
            title: Text(
              ChatRoom[index],
              style: TextStyle(fontSize: 22),
            ),
          ),
        );
      },
    );
  }

  firebase_storage.UploadTask uploadFile(String user_id) {
    if (_cameraVideo == null) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("No file was selected")));
      return null;
    }
    String file_name = getRandomString(7);
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref().child(user_id).child(file_name);
    return ref.putFile(_cameraVideo);
  }

  String getRandomString(int length) => String.fromCharCodes(
      Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  void handleUpload() async {
    firebase_storage.UploadTask task = uploadFile(userId);
    if (task != null) {
      task.snapshotEvents.listen((event) async {
        if (event.state == firebase_storage.TaskState.running && _isUploading == false) {
          setState(() {
            _isUploading = true;
          });
          loadingSnackbar();
        } else if (event.state == firebase_storage.TaskState.success) {
          _scaffoldkey.currentState.hideCurrentSnackBar();
          setState(() {
            _isUploading = false;
            finishSnackbar();
          });
          CollectionReference user_file =
              FirebaseFirestore.instance.collection('users').doc(userId).collection("images");
          String download_url = await event.ref.getDownloadURL();
          user_file.doc().set({
            'uid': userId,
            'download_url': download_url,
            'path': event.ref.fullPath,
            'caption': caption_controller.text
          });
          caption_controller.text = "";
        } else if (event.state == firebase_storage.TaskState.error) {
          _scaffoldkey.currentState.hideCurrentSnackBar();
          setState(() {
            _isUploading = false;
            errorSnackbar();
          });
        }
      });
    }
  }

  loadingSnackbar() {
    return _scaffoldkey.currentState.showSnackBar(SnackBar(
      backgroundColor: AppThemeData(context: context).myCustomTheme.primaryColor,
      duration: Duration(days: 100),
      content: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularProgressIndicator(),
            Text(
              "Uploading ...",
              style: AppThemeData(context: context).myTextTheme.button,
            ),
          ],
        ),
      ),
    ));
  }

  finishSnackbar() {
    return _scaffoldkey.currentState.showSnackBar(SnackBar(
      backgroundColor: AppThemeData(context: context).myCustomTheme.primaryColor,
      duration: Duration(seconds: 3),
      content: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Upload Success !!!",
              style: AppThemeData(context: context).myTextTheme.button,
            ),
          ],
        ),
      ),
    ));
  }

  errorSnackbar() {
    return _scaffoldkey.currentState.showSnackBar(SnackBar(
      backgroundColor: AppThemeData(context: context).myCustomTheme.primaryColor,
      duration: Duration(seconds: 3),
      content: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Upload Failed !!!",
              style: AppThemeData(context: context).myTextTheme.button,
            ),
          ],
        ),
      ),
    ));
  }
}
