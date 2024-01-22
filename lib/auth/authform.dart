import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Authform extends StatefulWidget {
  const Authform({super.key});

  @override
  State<Authform> createState() => _AuthformState();
}

class _AuthformState extends State<Authform> {
  final _formkey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool isLoginPage = false;

  Future<void> startAuthentication(BuildContext context) async {
    final validity = _formkey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (validity!) {
      _formkey.currentState?.save();
      await submitform(_email, _password, _username);
    }
  }

  Future<void> submitform(
      String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    try {
      UserCredential authResult;
      if (isLoginPage) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String uid = authResult.user?.uid ?? '';
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username': username,
          'email': email,
        });
      }
      print('Authentication successful: ${authResult.user?.uid}');
    } catch (err) {
      print('Error during authentication: $err');
      // Show a toast message when login fails
      Fluttertoast.showToast(
        msg: 'Incorrect email or password. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.lightGreenAccent,
        textColor: Colors.black,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isLoginPage)
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: const ValueKey('Username'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'incorrect Username';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _username = value!;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide()),
                          labelText: "Enter Username",
                          labelStyle: GoogleFonts.roboto()),
                    ),
                  const SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'incorrect email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide()),
                        labelText: "Enter Email",
                        labelStyle: GoogleFonts.roboto()),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'incorrect password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide()),
                        labelText: "Enter Password",
                        labelStyle: GoogleFonts.roboto()),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(5),
                    width: double.infinity,
                    height: 70,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.lightGreenAccent,
                      ),
                      onPressed: () {
                        startAuthentication(context);
                      },
                      child: isLoginPage
                          ? Text(
                              'Login',
                              style: GoogleFonts.roboto(
                                  fontSize: 16, color: Colors.black),
                            )
                          : Text(
                              'SignUp',
                              style: GoogleFonts.roboto(
                                  fontSize: 16, color: Colors.black),
                            ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            isLoginPage = !isLoginPage;
                          });
                        },
                        child: isLoginPage
                            ? Text(
                                'Not a member?',
                                style: GoogleFonts.roboto(
                                    fontSize: 16, color: Colors.black),
                              )
                            : Text('Already a Member?',
                                style: GoogleFonts.roboto(
                                    fontSize: 16, color: Colors.black))),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
