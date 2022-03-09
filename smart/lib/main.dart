import 'package:clay_containers/clay_containers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nemo_home/config.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'firebase.dart';
import 'login/ui/signin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home:
          FirebaseAuth.instance.currentUser == null ? SignInPage() : HomePage(),
    );
  }
}

var data = {'flame': true, 'temp': 50};
var loader = false;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _value = 0.0;
  double gasValue = 50;
  var valueRef = FirebaseDatabase.instance.ref('test');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                tileColor: Colors.red,
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
                    builder: (BuildContext context) => SignInScreen(),
                  ));
                },
                leading: Icon(Icons.logout),
                title: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: primaryColor,
      body: SafeArea(
        child: 
        StreamBuilder(
stream: valueRef.onValue,
builder: (BuildContext context, snapshot) {
if(snapshot.hasData) => return "Has Data";
else if(snapshot.hasError) => return "Error";
})
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: <Widget>[
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: <Widget>[
        //         ClayContainer(
        //           height: 50,
        //           width: MediaQuery.of(context).size.width * 0.7,
        //           borderRadius: 12,
        //           color: primaryColor,
        //           child: Container(
        //             decoration: BoxDecoration(
        //               gradient: LinearGradient(colors: <Color>[
        //                 activeColor1,
        //                 activeColor2,
        //               ]),
        //               borderRadius: BorderRadius.circular(12),
        //             ),
        //             child: Center(
        //               child: Text(
        //                 'E-Thermostate',
        //                 style: TextStyle(
        //                   color: Colors.white,
        //                   fontSize: 26,
        //                   fontWeight: FontWeight.w600,
        //                 ),
        //               ),
        //             ),
        //           ),
        //         )
        //       ],
        //     ),
        //     ClayContainer(
        //       height: 200,
        //       width: 200,
        //       color: primaryColor,
        //       borderRadius: 200,
        //       child: Padding(
        //         padding: EdgeInsets.all(12),
        //         child: SleekCircularSlider(
        //             max: 100,
        //             appearance: CircularSliderAppearance(
        //               customColors: CustomSliderColors(
        //                 progressBarColors: gradientColors,
        //                 hideShadow: true,
        //                 shadowColor: Colors.transparent,
        //               ),
        //               infoProperties: InfoProperties(
        //                   mainLabelStyle: TextStyle(
        //                     color: Colors.white,
        //                     fontWeight: FontWeight.w600,
        //                     fontSize: 28,
        //                   ),
        //                   modifier: (double value) {
        //                     final roundedValue =
        //                         value.ceil().toInt().toString();
        //                     return '$roundedValue \u2103';
        //                   }),
        //             ),
        //             onChange: (double value) async {
        //               gasValue = value;
        //               setValues();
        //               print(value);
        //             }),
        //       ),
        //     ),
        //     SizedBox(height: 20),
        //     loader
        //         ? Center(child: CircularProgressIndicator(color: Colors.red))
        //         : InkWell(
        //             onTap: () async {
        //               loader = true;
        //               setState(() {});

        //               loader = false;

        //               data['flame'] = !(data['flame'] == true);
        //               setValues();
        //               setState(() {});
        //             },
        //             child: ClayContainer(
        //               height: MediaQuery.of(context).size.width * 0.4,
        //               width: MediaQuery.of(context).size.width * 0.4,
        //               color: primaryColor,
        //               borderRadius: 12,
        //               child: Center(
        //                 child: Icon(
        //                     data['flame'] == true
        //                         ? Icons.fireplace
        //                         : Icons.fireplace_outlined,
        //                     color: data['flame'] == true
        //                         ? Colors.red
        //                         : Colors.white,
        //                     size: 80),
        //               ),
        //             ),
        //           ),
        //     SizedBox(height: 18),
        //   ],
        // ),
      ),
    );
  }

  setValues() async {
    await FirebaseFirestore.instance
        .collection('values')
        .doc('0')
        .set({'burner': data['flame'], 'gas': gasValue});
  }

  String percentageModifier(double value) {
    final roundedValue = value.ceil().toInt().toString();
    return '$roundedValue 0x00B0 C';
  }
}

class MenuItem extends StatefulWidget {
  final IconData iconName;

  const MenuItem({Key? key, required this.iconName}) : super(key: key);
  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: ClayContainer(
        height: MediaQuery.of(context).size.width * 1 / 7,
        width: MediaQuery.of(context).size.width * 1 / 7,
        borderRadius: 10,
        color: primaryColor,
        surfaceColor: isSelected ? activeColor2 : primaryColor,
        child: Icon(widget.iconName, color: Colors.white, size: 20),
      ),
    );
  }
}
