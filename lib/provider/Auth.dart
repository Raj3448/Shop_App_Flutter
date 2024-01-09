import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopii2/main.dart';

class Auth extends ChangeNotifier {
  String? _receivedUid = null;
  bool _toggleForShowDialog = false;

  bool get isAuth {
    print('Received Response Id = $_receivedUid');
    return _receivedUid != null;
  }

  Future<dynamic> _showDialogScreen(
      String message, BuildContext context) async {
    return showDialog(
      context: context,
      builder: (cxt) => AlertDialog(
        title: Text(!_toggleForShowDialog
            ? 'Error Occurred'
            : '✅ Sign Up successfully'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (_toggleForShowDialog) {
                Navigator.of(cxt).pop();
                try {
                  Navigator.of(context).pushReplacementNamed(MyApp.routeName);
                } catch (error) {
                  print('Exception Occured...................');
                }
                _toggleForShowDialog = false;
                notifyListeners();
              }
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  Future<dynamic> createUserWithEmailAndPassword(TextEditingController email,
      TextEditingController password, BuildContext context) async {
    try {
      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      if (credential.user != null) {
        _toggleForShowDialog = true;
        notifyListeners();
        _showDialogScreen('Account created', context);
        _receivedUid = credential.user!.uid;
      } else {
        print('User is null after sign-up.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showDialogScreen('Provided password is too weak.', context);
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _showDialogScreen(
            'The account already exists for this email.', context);
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> signInWithEmailAndPassword(TextEditingController email,
      TextEditingController password, BuildContext context) async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.text, password: password.text);

      if (credential.user != null) {
        print('User has been successfully signed in');
        print('User Credentials: ${credential.user}');
        _receivedUid = credential.user!.uid;
        notifyListeners();
      } else {
        print('User is null after sign-in.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showDialogScreen('No user found for this email.', context);
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _showDialogScreen('Wrong password provided for this user.', context);
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e);
    }
  }
}
