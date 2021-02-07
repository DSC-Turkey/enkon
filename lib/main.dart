import 'package:enkom/screens/home_page.dart';
import 'package:enkom/screens/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String city;
String contact;
bool isLogin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences mySharedPreferences = await SharedPreferences.getInstance();
  isLogin = mySharedPreferences.getBool("isLogin");
  city = mySharedPreferences.getString("Sehir");
  contact = mySharedPreferences.getString("Kisi");
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isLogin == null ? SplashScreen() : HomePage(),
    );
  }
}

