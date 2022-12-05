import 'package:chatstream/shared_prefrences/helper_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatstream/services/auth_service.dart';
import 'package:chatstream/services/database_service.dart';

class AuthServices{
  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;

  //login function
  Future loginUserNameandPassword(String email,String password)async{
    try{
      User user=(await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user!;
      if(user!=null){
        //call our database to update user data

        return true;

      }

    } on FirebaseAuthException catch(e){
      return e.message;
    }
  }

//register function
Future registerUserWithEmailandPassword(String fullName,String email,String password)async{
  try{
    User user=(await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user!;
    if(user!=null){
      //call our database to update user data
    await  DatabaseService(uid: user.uid).savingUserData(fullName, email);
      return true;

    }

  } on FirebaseAuthException catch(e){
    return e.message;
  }
}


//sign out function
Future signOut() async{
  try{
    await HelperFunctions.saveUserLoggedInStatus(false);
    await HelperFunctions.saveUserEmailSF("");
    await HelperFunctions.saveUserNameSF("");
    await firebaseAuth.signOut();

}catch(e){
    return null;

  }
}}