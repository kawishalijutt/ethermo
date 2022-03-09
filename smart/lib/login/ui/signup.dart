import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nemo_home/login/ui/signin.dart';
import 'package:nemo_home/main.dart';
import '../../firebase.dart';
import '../../snackbar.dart';
import '../constants/constants.dart';

import 'widgets/custom_shape.dart';
import 'widgets/customappbar.dart';
import 'widgets/responsive_ui.dart';
import 'widgets/textformfield.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool checkBoxValue = false;
  late double _height;
  late double _width;
  late double _pixelRatio;
  late bool _large;
  late bool _medium;
  Map<String, TextEditingController> c = {
    'fname': TextEditingController(text: "user"),
    'lname': TextEditingController(text: "app"),
    'email': TextEditingController(text: "user@gmail.com"),
    'phone': TextEditingController(text: "03021122993"),
    'password': TextEditingController(text: "user123456"),
  };
  bool doctor = false;
  File? file;
  bool loader = false;
  GlobalKey _sKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      child: SafeArea(
        child: Scaffold(
          key: _sKey,
          body: Container(
            height: _height,
            width: _width,
            margin: EdgeInsets.only(bottom: 5),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // Opacity(opacity: 0.88, child: CustomAppBar()),
                  clipShape(),
                  // userTypeField(),
                  form(),
                  SizedBox(
                    height: _height / 35,
                  ),
                  signUnTextRow(),
                  loader ? CircularProgressIndicator() : button(),
                  // infoTextRow(),
                  // socialIconsRow(),
                  //signInTextRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large
                  ? _height / 8
                  : (_medium ? _height / 7 : _height / 6.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: color,
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large
                  ? _height / 12
                  : (_medium ? _height / 11 : _height / 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: color,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget form() {
    return Container(
      margin: EdgeInsets.only(
          left: _width / 12.0, right: _width / 12.0, top: _height / 20.0),
      child: Form(
        child: Column(
          children: <Widget>[
            firstNameTextFormField(),
            SizedBox(height: _height / 60.0),
            lastNameTextFormField(),
            SizedBox(height: _height / 60.0),
            emailTextFormField(),
            SizedBox(height: _height / 60.0),
            phoneTextFormField(),
            SizedBox(height: _height / 60.0),
            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget firstNameTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      icon: Icons.person,
      hint: "First Name",
      textEditingController: c['fname']!,
    );
  }

  Widget lastNameTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      icon: Icons.person,
      hint: "Last Name",
      textEditingController: c['lname']!,
    );
  }

  Widget emailTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.emailAddress,
      icon: Icons.email,
      hint: "Email ID",
      textEditingController: c['email']!,
    );
  }

  Widget phoneTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.number,
      icon: Icons.phone,
      hint: "Mobile Number",
      textEditingController: c['phone']!,
    );
  }

  Widget passwordTextFormField() {
    return CustomTextField(
      keyboardType: TextInputType.text,
      obscureText: true,
      icon: Icons.lock,
      hint: "Password",
      textEditingController: c['password']!,
    );
  }

  Widget userTypeField() {
    return Center(
      child: Container(
        child: ListTile(
          title: Text(
            doctor ? "Doctor" : "User",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: Transform.scale(
              scale: 1.5,
              child: Switch(
                onChanged: (v) {
                  doctor = v;
                  setState(() {});
                },
                value: doctor,
                activeColor: Colors.blue,
                activeTrackColor: Colors.lightBlueAccent,
                inactiveThumbColor: Colors.blueAccent,
                inactiveTrackColor: Colors.lightBlue,
              )),
        ),
      ),
    );
  }

  validateForm() async {
    bool flag = true;
    Map<String, dynamic> data = {};
    c.forEach((key, value) {
      if (value.text.isEmpty) {
        flag = false;
      } else {
        data[key] = value.text;
      }
    });

    data['type'] = doctor ? 'doctor' : 'user';
    if (doctor) {
      data['institute'] = "";
      data['designation'] = "";
      data['about'] = "";
      data['timing'] = getDefaultSchedual();
    }
    return flag ? data : null;
  }

  getDefaultSchedual() {
    return {
      'monday': {'status': true, 'from': '10 am', 'to': '6 pm'},
      'tuesday': {'status': true, 'from': '10 am', 'to': '6 pm'},
      'wednesday': {'status': true, 'from': '10 am', 'to': '6 pm'},
      'thursday': {'status': true, 'from': '10 am', 'to': '6 pm'},
      'friday': {'status': true, 'from': '10 am', 'to': '6 pm'},
      'saturday': {'status': false, 'from': '10 am', 'to': '6 pm'},
      'sunday': {'status': false, 'from': '10 am', 'to': '6 pm'},
    };
  }

  Widget button() {
    return MaterialButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () async {
        loader = true;
        setState(() {});
        try {
          var data = await validateForm();

          if (data == null) {
            showSnackbar(
                key: _sKey, msg: "Fill the Form Completely", status: false);
          } else {
            bool status = await createAccountWithEmailPassword(
              data: data,
              skey: _sKey,
              file: file,
            );
            if (status) {
              Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
                builder: (BuildContext context) => HomePage(),
              ));
            }
          }
          loader = false;
          setState(() {});
        } catch (ex) {
          loader = false;
          setState(() {});
          print(ex);
        }
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
//        height: _height / 20,
        width: _large ? _width / 4 : (_medium ? _width / 3.75 : _width / 3.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: color,
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'SIGN UP',
          style: TextStyle(fontSize: _large ? 14 : (_medium ? 12 : 10)),
        ),
      ),
    );
  }

  Widget infoTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Or create using social media",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: _large ? 12 : (_medium ? 11 : 10)),
          ),
        ],
      ),
    );
  }

  Widget socialIconsRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 80.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage("assets/images/googlelogo.png"),
          ),
          SizedBox(
            width: 20,
          ),
          CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage("assets/images/fblogo.jpg"),
          ),
          SizedBox(
            width: 20,
          ),
          CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage("assets/images/twitterlogo.jpg"),
          ),
        ],
      ),
    );
  }

  Widget signUnTextRow() {
    return Container(
      margin: EdgeInsets.only(bottom: _height / 20.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
            builder: (BuildContext context) => SignInScreen(),
          ));
        },
        child: Text(
          "Sign In",
          style: TextStyle(
              fontWeight: FontWeight.w800,
              color: textColor,
              fontSize: _large ? 19 : (_medium ? 17 : 15)),
        ),
      ),
    );
  }
}

showImage(file) {
  return file == null
      ? DecorationImage(
          fit: BoxFit.fill, image: AssetImage('assets/icons/upload.png'))
      : DecorationImage(fit: BoxFit.fill, image: FileImage(file!));
}
