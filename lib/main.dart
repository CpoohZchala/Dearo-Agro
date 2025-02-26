import 'package:farmeragriapp/views/farmer_dashbaord.dart';
import 'package:farmeragriapp/views/home_screen.dart';
import 'package:farmeragriapp/views/signIn_screen.dart';
import 'package:farmeragriapp/views/signUp_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green
      ),
      initialRoute: "/",
      routes: {
        "/":(context) =>  HomeScreen(),
        "/signIn":(context) =>  const SignInScreen(),
        "/signUp":(context) => const SignupScreen(),
        "/fdashboard":(context) => const FarmerDashboard(),
      },

    );
  }
}
