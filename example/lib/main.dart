import 'package:flutter/material.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Country State and City Picker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? countryValue;
  String? stateValue;
  String? cityValue;

  void displayMsg(msg) {
    print(msg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Country State Picker'),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          // height: 600,
          child: Container(
            child: Column(
              children: [
                SelectState(
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(5.0),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700
                  ),
                  spacing: 25.0,
                  countryLogo: Icon(Icons.public),
                  onCountryChanged: (value) {
                    setState(() {
                      countryValue = value;
                    });
                  },
                  stateLogo: Icon(Icons.domain),
                  onCountryTap: () => displayMsg('You\'ve tapped on countries!'),
                  onStateChanged: (value) {
                    setState(() {
                      stateValue = value;
                    });
                  },
                  onStateTap: () => displayMsg('You\'ve tapped on states!'),
                  iconColor: Colors.black,
                ),
              ],
            ),
          )),
    );
  }
}
