import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', width: 600),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 1, 64, 4)

              ),
              onPressed: () {
                Navigator.pushNamed(context, "/signIn");
              },
              child: const Text("Get Started",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),),
              
            ),
          ],
        ),
      ),
    );
  }
}
