import 'package:chatstream/pages/home_page.dart';
import 'package:chatstream/services/database_service.dart';
import 'package:chatstream/shared_prefrences/helper_function.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:chatstream/widgets/wideget.dart';
import 'package:chatstream/pages/register_screen.dart';
import 'package:chatstream/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey=GlobalKey<FormState>();
  String email="";
  String password="";
  bool _isLoading=false;
  AuthServices authServices=AuthServices();


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),):SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
               const Text("ChatStream",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
                const SizedBox(height: 10,),
                const Text("Login now to see what they are talking",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                Image.asset("images/loginimg.png"),
                TextFormField(

                  cursorColor: Theme.of(context).primaryColor,
                  decoration: textInputDecoration.copyWith(
                    labelText: "Email",
                  prefixIcon: Icon(
                    Icons.email,
                    color: Theme.of(context).primaryColor,
                  ),
                  ),
                  onChanged: (val){
                    setState(() {
                      email=val;
                    }
                    );
                    },//val
                  validator: (val){
                    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val!) ? null: "Please enter a valid email";
                  },

                ),

                const SizedBox(height: 10,),
                TextFormField(
                  obscureText: true,
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: textInputDecoration.copyWith(
                    labelText: "Password",
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  validator: (val){
                    if(val!.length<6){
                     return "Password must be at leats 6 characters";
                    }else{
                      return null;
                    }
                  },
                  onChanged: (val){
                    setState(() {
                      password=val;

                    });
                  },

                ),
                const SizedBox(height: 20,),
                SizedBox(width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: (){
                      login();
                    },
                  ),

                ),
                const SizedBox(height: 10),
                Text.rich(TextSpan(
                  text: "Dont have an account? ",
                  style: const TextStyle(color: Colors.black,fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(
                      text: "Register here",
                      style: const TextStyle(color: Color(0xff214365,),fontSize: 15,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()..onTap=(){
                        nextScreen(context, RegisterScreen());
                      }
                    )
                  ]
                ))

              ],
            ),
          ),
        ),
      ),
    );}
  login()async{
    if(formkey.currentState!.validate()){

        setState(() {
          _isLoading=true;
        });
        await authServices.loginUserNameandPassword(email, password).then((value)async{
          if(value==true){
            QuerySnapshot snapshot=
            await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);
            //saving the share prefrences state
            await HelperFunctions.saveUserLoggedInStatus(true);
            await HelperFunctions.saveUserEmailSF(email);
            await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
            nextScreenReplace(context, HomePage());
          }else{
            showSnackBar(context, Colors.red, value);
            setState(() {
              _isLoading=false;

            });
          }
        });
      }

    }
  }
