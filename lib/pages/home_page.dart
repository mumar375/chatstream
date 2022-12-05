import 'package:flutter/material.dart';
import 'package:chatstream/services/auth_service.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthServices authServices=AuthServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: ElevatedButton(
      onPressed: (){
        authServices.signOut();
      },
      child: Text("Logout"),
    ),),);
  }
}
