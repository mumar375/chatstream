import 'package:chatstream/pages/home_page.dart';
import 'package:chatstream/pages/login_page.dart';
import 'package:chatstream/shared_prefrences/helper_function.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:chatstream/widgets/wideget.dart';
import 'package:chatstream/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey=GlobalKey<FormState>();
  String email="";
  String password="";
  String fullName="";
  bool _isLoading=false;
  AuthServices authServices=AuthServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),) :
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text("ChatStream",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
                const SizedBox(height: 10,),
                const Text("Create an account to chat with friends",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                Image.asset("images/signupimg.png"),
                TextFormField(

                  cursorColor: Theme.of(context).primaryColor,
                  decoration: textInputDecoration.copyWith(
                    labelText: "Name",
                    prefixIcon: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onChanged: (val){
                    setState(() {
                      fullName=val;
                    }
                    );
                  },//val
                  validator: (val){
                    if(val!.isNotEmpty){
                      return null;
                    }else{
                      return "Please enter your name";
                    }
                  },
                ),
                const SizedBox(height: 10,),
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
                      "Register",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: (){
                      register();
                    },
                  ),

                ),
                const SizedBox(height: 10),
                Text.rich(TextSpan(
                    text: "Already have an account? ",
                    style: const TextStyle(color: Colors.black,fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                          text: "Login now",
                          style: const TextStyle(color: Color(0xff214365,),fontSize: 15,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()..onTap=(){
                            nextScreen(context, LoginPage());
                          }
                      )
                    ]
                ))

              ],
            ),
          ),
        ),
      ),
    );
  }register()async{
    if(formKey.currentState!.validate()){
      setState(() {
        _isLoading=true;
      });
      await authServices.registerUserWithEmailandPassword(fullName, email, password).then((value)async{
        if(value==true){
          //saving the share prefrences state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
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