import 'package:farmeragriapp/views/Cultivational_expense.dart';
import 'package:farmeragriapp/views/crop_details_screen.dart';
import 'package:farmeragriapp/views/cultivation_screen.dart';
import 'package:farmeragriapp/views/cultivationalDetailsAdd.dart';
import 'package:farmeragriapp/views/farmer_dashbaord.dart';
import 'package:farmeragriapp/views/home_screen.dart';
import 'package:farmeragriapp/views/inquiries_screen.dart';
import 'package:farmeragriapp/views/orders_screen.dart';
import 'package:farmeragriapp/views/predictionscreen.dart';
import 'package:farmeragriapp/views/signIn_screen.dart';
import 'package:farmeragriapp/views/signUp_screen.dart';
import 'package:farmeragriapp/views/stock_screen.dart';
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
        "/cultivational":(context) => const CultivationalScreen(),
        "/crop_updates":(context) => const CropDetailsScreen(),
        "/expenses" :(context) => const CultivationalExpense(),
        "/stock":(context) => const StockScreen(),
        "/orders":(context) => const Orderscreen(),
        "/inqueries":(context) => const InqueriesScreen(),
        "/prediction":(context) => const Predictionscreen (),
        "/addCultivational":(context)=> const CultivationalAddScreen(),
        },

    );
  }
}
