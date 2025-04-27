import 'package:farmeragriapp/screens/forms/add_expense.dart';
import 'package:farmeragriapp/screens/forms/commiunityIScreen.dart';
import 'package:farmeragriapp/screens/forms/financialIScreen.dart';
import 'package:farmeragriapp/screens/forms/generalIScreen.dart';
import 'package:farmeragriapp/screens/forms/general_inq_crud.dart';
import 'package:farmeragriapp/screens/forms/technicalIScreen.dart';
import 'package:farmeragriapp/screens/forms/technical_inq_crud.dart';
import 'package:farmeragriapp/screens/views/Cultivational_expense.dart';
import 'package:farmeragriapp/screens/views/crop_details_screen.dart';
import 'package:farmeragriapp/screens/views/cultivation_screen.dart';
import 'package:farmeragriapp/screens/forms/addCultivational.dart';
import 'package:farmeragriapp/screens/views/home_screen.dart';
import 'package:farmeragriapp/screens/views/inquiries_screen.dart';
import 'package:farmeragriapp/screens/forms/newUpdateForm.dart';
import 'package:farmeragriapp/screens/views/orders_screen.dart';
import 'package:farmeragriapp/screens/views/predictionscreen.dart';
import 'package:farmeragriapp/screens/forms/signIn_screen.dart';
import 'package:farmeragriapp/screens/forms/signUp_screen.dart';
import 'package:farmeragriapp/screens/views/stock_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.green),
      initialRoute: "/",
      routes: {
        "/": (context) => HomeScreen(),
        "/signIn": (context) => const SignInScreen(),
        "/signUp": (context) => const SignupScreen(),
        "/cultivational": (context) => const CultivationalScreen(),
        "/crop_updates": (context) => const CropDetailsScreen(),
        "/expenses": (context) => const CultivationalExpense(),
        "/stock": (context) => const StockScreen(),
        "/orders": (context) => const Orderscreen(),
        "/inqueries": (context) => const InqueriesScreen(),
        "/prediction": (context) => const Predictionscreen(),
        "/addCultivational": (context) => const CultivationalAddScreen(),
        "/newcropupdate": (context) => const NewUpdateForm(),
        "/addExpenses": (context) => const AddExpense(),
        "/general": (context) => const GeneralIScreen(),
        "/commiunity": (context) => const CommiunityIscreen(),
        "/finacial": (context) => const FinancialIscreen(),
        "/technical": (context) => const TechnicalIScreen(),
        "/myGeneral": (context) => const GeneralInquiryList(baseUrl: 'http://192.168.8.125:5000/api',),
        "/myTechnical": (context) => const TechnicalInquiryList(baseUrl: 'http://192.168.8.125:5000/api',),
      },
    );
  }
}

