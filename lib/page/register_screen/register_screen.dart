import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_profile/utils/app_theme.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../utils/app_theme_data.dart';
import '../../utils/validator.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController email_controller = TextEditingController();
  TextEditingController fullname_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  TextEditingController password_confirmation_controller = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  String _valRole = "Level A";

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void validateRegister() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _signUpWithEmailAndPassword();
    }
  }

  Widget emailInput() {
    return TextFormField(
      controller: email_controller,
      key: Key("register_email_field"),
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
      validator: (value) {
        return Validator().validateEmail(value);
      },
    );
  }

  Widget fullnameInput() {
    return TextFormField(
      key: Key("register_fullname_field"),
      controller: fullname_controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Fullname",
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
      validator: (value) {
        return Validator().validateFullname(value);
      },
    );
  }

  Widget passInput() {
    return TextFormField(
      key: Key("register_password_field"),
      controller: password_controller,
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
      validator: (value) {
        return Validator().validatePassword(value);
      },
    );
  }

  Widget passConfirmationInput() {
    return TextFormField(
      key: Key("register_password_confirmation_field"),
      controller: password_confirmation_controller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Password Confirmation",
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
      validator: (value) {
        return Validator().validatePasswordConfirmation(password_controller.text, value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Register Here, ",
                    style: AppThemeData(context: context).myTextTheme.headline1,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  emailInput(),
                  SizedBox(
                    height: 16,
                  ),
                  fullnameInput(),
                  SizedBox(
                    height: 16,
                  ),
                  passInput(),
                  SizedBox(
                    height: 12,
                  ),
                  passConfirmationInput(),
                  SizedBox(
                    height: 12,
                  ),
                  new DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Role",
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
                    ),
                    items: <String>['Level A', 'Level B', 'Level C'].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _valRole = value;
                      });
                    },
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
                      key: Key("go_register_process"),
                      onPressed: validateRegister,
                      padding: EdgeInsets.all(0),
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: AppThemeData(context: context).borderRadius,
                          color: AppThemeData(context: context).colorPrimary,
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          constraints: BoxConstraints(maxWidth: double.infinity, minHeight: 50),
                          child: Text(
                            "Register",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                  Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          key: Key("register_go_back"),
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Back",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _signUpWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email_controller.text, password: password_controller.text);
      final User user = userCredential.user;
      try {
        await addUser(user.uid);
        Alert(
          style: alertStyle,
          context: context,
          type: AlertType.success,
          title: "",
          desc: "Registration Success",
          buttons: [
            DialogButton(
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              width: 120,
            ),
          ],
        ).show();
      } catch (e) {
        Alert(
          context: context,
          type: AlertType.error,
          style: alertStyle,
          title: "woops",
          desc: "SOmething went wrong , please try again",
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
      } else if (e.code == 'weak-password') {
        Alert(
          context: context,
          type: AlertType.error,
          style: alertStyle,
          title: "woops",
          desc: "The password provided is too weak.",
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
      } else if (e.code == 'email-already-in-use') {
        Alert(
          context: context,
          type: AlertType.error,
          title: "woops",
          desc: "The account already exists for that email.",
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

  Future<void> addUser(String uid) {
    // Call the user's CollectionReference to add a new user
    return users
        .doc(uid)
        .set({
          'uid': uid,
          'fullname': fullname_controller.text, // John Doe
          'email': email_controller.text, // John Doe
          'role': _valRole
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
