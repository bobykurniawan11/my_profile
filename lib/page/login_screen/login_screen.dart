import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_profile/page/dashboard/Dashboard.dart';
import 'package:my_profile/page/register_screen/register_screen.dart';
import 'package:my_profile/utils/app_theme.dart';
import 'package:my_profile/utils/app_theme_data.dart';
import 'package:my_profile/utils/validator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController email_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget emailInput() {
    return TextFormField(
      key: Key("login_email_field"),
      controller: email_controller,
      validator: (value) {
        return Validator().validateEmail(value);
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email",
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
    );
  }

  Widget passInput() {
    return TextFormField(
      key: Key("login_password_field"),
      controller: password_controller,
      validator: (value) {
        return Validator().validatePassword(value);
      },
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: AppThemeData(context: context).myTextTheme.caption,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: AppThemeData(context: context).borderRadius,
            borderSide: BorderSide(
              color: AppThemeData(context: context).colorSecondary,
            )),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: AppThemeData(context: context).colorPrimary,
          ),
          onPressed: _toggle,
        ),
      ),
      textInputAction: TextInputAction.done,
      obscureText: _obscureText,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          "Welcome,",
                          style: AppThemeData(context: context).myTextTheme.headline1,
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "Sign in to continue!",
                          style: AppThemeData(context: context).myTextTheme.headline2,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        emailInput(),
                        SizedBox(
                          height: 16,
                        ),
                        passInput(),
                        SizedBox(
                          height: 12,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            "Forgot Password ?",
                            style: AppThemeData(context: context).myTextTheme.bodyText1,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 50,
                          width: double.infinity,
                          child: FlatButton(
                            onPressed: validateLogin,
                            key: Key("go_login_process"),
                            padding: EdgeInsets.all(0),
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: AppThemeData(context: context).borderRadius,
                                color: AppThemeData(context: context).colorPrimary,
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                constraints:
                                    BoxConstraints(maxWidth: double.infinity, minHeight: 50),
                                child: Text(
                                  "Login",
                                  style:
                                      TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppThemeData(context: context).borderRadius,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text("Or Connect with"),
                                SizedBox(
                                  height: 20,
                                ),
                                SignInButton(
                                  Buttons.Google,
                                  text: "Login With Google",
                                  onPressed: () async {
                                    await signInWithGoogle();
                                  },
                                ),
                                SignInButton(
                                  Buttons.Facebook,
                                  text: "Login With Facebook",
                                  onPressed: () async {
                                    await signInWithFacebook();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Don't have an account?",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return RegisterScreen();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              "Sign up",
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }

  void validateLogin() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _signInWithEmailAndPassword();
    }
  }

  Future _setSession(userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("uid", userData['uid']);
    await prefs.setString("role", userData['role']);
    await prefs.setString("fullname", userData['fullname']);
    await prefs.setString("email", userData['email']);
  }

  void _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email_controller.text, password: password_controller.text);
      final User userInfo = userCredential.user;
      CollectionReference userDocumentData = FirebaseFirestore.instance.collection('users');
      var document = await userDocumentData.doc(userInfo.uid).get();
      var userData = document.data();
      await _setSession(userData);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Dashboard(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Alert(
          context: context,
          type: AlertType.error,
          style: alertStyle,
          title: "woops",
          desc: "No user found for that email.",
          buttons: [
            DialogButton(
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      } else if (e.code == 'wrong-password') {
        Alert(
          context: context,
          type: AlertType.error,
          title: "woops",
          desc: "Wrong password provided for that user.",
          buttons: [
            DialogButton(
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      await addUser(userCredential, "Level A");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => Dashboard(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        Alert(
          context: context,
          type: AlertType.error,
          title: "woops",
          desc:
              "An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email.",
          buttons: [
            DialogButton(
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      }
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    await FacebookAuth.instance.login().then((result) async {
      final FacebookAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.token);
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
        await addUser(userCredential, "Level B");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Dashboard(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          Alert(
            context: context,
            type: AlertType.error,
            title: "woops",
            desc:
                "An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email.",
            buttons: [
              DialogButton(
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
              )
            ],
          ).show();
        }
      }
    });
  }

  Future<void> addUser(UserCredential userCredential, String level) {
    return users.doc(userCredential.user.uid).set({
      'uid': userCredential.user.uid,
      'fullname': userCredential.user.displayName, // John Doe
      'email': userCredential.user.email, // John Doe
      'photoUrl': userCredential.user.photoURL,
      'role': level
    }).then((value) async {
      print(userCredential.user.displayName);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("uid", userCredential.user.uid);
      await prefs.setString("role", level);
      await prefs.setString("fullname", userCredential.user.displayName);
      await prefs.setString("email", userCredential.user.email);
      await prefs.setString("photoUrl", userCredential.user.photoURL);
    });
  }
}
