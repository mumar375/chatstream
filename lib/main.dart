import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chatstream/pages/login_page.dart';

import 'package:chatstream/shared/constants.dart';
import 'package:chatstream/pages/home_page.dart';
import 'package:chatstream/shared_prefrences/helper_function.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(options: FirebaseOptions(
        apiKey: Constants.apiKey,
        appId: Constants.appId,
        messagingSenderId: Constants.messagingSenderId,
        projectId: Constants.projectId
    ));
  }else{
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn=false;
  @override
  void initState() {
    // TODO: implement initState

    getUserLoggedInStatus();
    super.initState();
  }

  getUserLoggedInStatus() async{
    await HelperFunctions.getUserLoggedInStatus().then((value){
     if(value!=null){
       setState(() {
         _isSignedIn=value;
       });
     }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Constants().primerColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home:  _isSignedIn ? HomePage(): LoginPage(),
    );
  }

}


