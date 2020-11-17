import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_profile/utils/app_theme_data.dart';
import 'package:my_profile/utils/my_sharedpreference.dart';
import 'package:my_profile/utils/routes.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
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

  VideoPlayerController _cameraVideoPlayerController;
  bool _isUploading = false;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  Future<DocumentSnapshot> getUserInformation;
  Future<List<DocumentSnapshot>> getUserVideo;

  int image_upload_count = 0;
  int max_upload_count = 0;

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
      getUserVideo = user_video();
      MySharedPreferences.instance.getStringValue("role").then((value) => setState(() {
            if (value == "Level A") {
              max_upload_count = 3;
            } else if (value == "Level B") {
              max_upload_count = 1;
            } else if (value == "Level C") {
              max_upload_count = 5;
            }
          }));
    });
  }

  Future<DocumentSnapshot> user_information() async {
    return users.doc(FirebaseAuth.instance.currentUser.uid).get();
  }

  Future<List<DocumentSnapshot>> user_video() async {
    final QuerySnapshot result =
        await users.doc(FirebaseAuth.instance.currentUser.uid).collection("images").get();
    final List<DocumentSnapshot> documents = result.docs;
    setState(() {
      image_upload_count = result.docs.length;
    });

    return documents;
  }

  _pickVideoCamera() async {
    PickedFile pickedFile = await picker.getVideo(source: ImageSource.camera);
    _cameraVideo = File(pickedFile.path);
    _cameraVideoPlayerController = VideoPlayerController.file(_cameraVideo)
      ..initialize().then((_) {
        setState(() {});
        popUpVideoPlayer();
        _cameraVideoPlayerController.play();
      });
  }

  _pickVideoGallery() async {
    PickedFile pickedFile = await picker.getVideo(source: ImageSource.gallery);
    _cameraVideo = File(pickedFile.path);
    _cameraVideoPlayerController = VideoPlayerController.file(_cameraVideo)
      ..initialize().then((_) {
        setState(() {});
        popUpVideoPlayer();
        _cameraVideoPlayerController.play();
      });
  }

  popUpVideoPlayer() {
    Alert(
        context: context,
        title: "",
        content: Column(
          children: [
            Container(
              height: 300,
              width: 300,
              child: VideoPlayer(_cameraVideoPlayerController),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              key: Key("login_email_field"),
              controller: caption_controller,
              keyboardType: TextInputType.emailAddress,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: "Caption",
                labelStyle: AppThemeData(context: context).myTextTheme.caption,
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppThemeData(context: context).borderRadius,
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: AppThemeData(context: context).colorSecondary,
                    )),
              ),
              textInputAction: TextInputAction.next,
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              if (caption_controller.text.length > 9) {
                handleUpload();
                Navigator.pop(context);
              } else {
                Alert(context: context, title: "", desc: "At least 10 characters long ", buttons: [
                  DialogButton(
                    color: Colors.redAccent,
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Ok",
                      style: AppThemeData(context: context).myTextTheme.button,
                    ),
                  ),
                ]).show();
              }
            },
            child: Text(
              "Upload",
              style: AppThemeData(context: context).myTextTheme.button,
            ),
          ),
          DialogButton(
            color: Colors.redAccent,
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: AppThemeData(context: context).myTextTheme.button,
            ),
          ),
        ]).show();
  }

  popUpPlayVideoPlayer(String caption) {
    Alert(
        context: context,
        title: "",
        content: Column(
          children: [
            Container(
              height: 300,
              width: 300,
              child: VideoPlayer(_cameraVideoPlayerController),
            ),
            SizedBox(
              height: 20,
            ),
            Text(caption)
          ],
        ),
        buttons: [
          DialogButton(
            color: Colors.redAccent,
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Close",
              style: AppThemeData(context: context).myTextTheme.button,
            ),
          ),
        ]).show();
  }

  Widget _floatActionButton() {
    if (image_upload_count == max_upload_count) {
      return Container();
    } else if (_isUploading == true) {
      return Container();
    } else {
      return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showPicker(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldkey,
        floatingActionButton: _floatActionButton(),
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
            SizedBox(
              height: 20,
            ),
            Text("Tap to play video and Hold to delete video"),
            Expanded(
              child: FutureBuilder<List<DocumentSnapshot>>(
                future: user_video(),
                builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  } else if (snapshot.hasData && !snapshot.hasError) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return VideoSection(snapshot.data[index]);
                      },
                    );
                  }

                  return Text("loading");
                },
              ),
            )
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

  Widget VideoSection(data) {
    return InkWell(
      child: ListTile(
        title: Text(data['caption'] ?? ''),
      ),
      onLongPress: () {
        Alert(context: context, title: "", desc: "Are you sure want to delete this ?", buttons: [
          DialogButton(
            color: Colors.redAccent,
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .collection("images")
                  .doc(data.id)
                  .delete();
              user_video();
              setState(() {
                image_upload_count = image_upload_count - 1;
              });
              Navigator.pop(context);
            },
            child: Text(
              "Delete",
              style: AppThemeData(context: context).myTextTheme.button,
            ),
          ),
          DialogButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: AppThemeData(context: context).myTextTheme.button,
            ),
          ),
        ]).show();
      },
      onTap: () {
        print(data.id);
        _cameraVideoPlayerController = VideoPlayerController.network(data['download_url'])
          ..initialize().then((_) {
            setState(() {});
          });
        popUpPlayVideoPlayer(data['caption']);
        _cameraVideoPlayerController.play();
      },
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        _pickVideoGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _pickVideoCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
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
            user_video();
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
