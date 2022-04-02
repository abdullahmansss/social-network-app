import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_network/constants.dart';
import 'package:social_network/models/user_model.dart';

import 'home.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isVisible = true;
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/social-media.png',
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  const Text(
                    'Register now and discover app',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'username must not be empty';
                      }

                      return null;
                    },
                    controller: usernameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      isDense: false,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15.0,
                        ),
                      ),
                      label: const Text(
                        'username',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'email address must not be empty';
                      }

                      return null;
                    },
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      isDense: false,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15.0,
                        ),
                      ),
                      label: const Text(
                        'email address',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'password is too short';
                      }

                      return null;
                    },
                    controller: passwordController,
                    decoration: InputDecoration(
                      isDense: false,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          15.0,
                        ),
                      ),
                      label: const Text(
                        'password',
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        icon: Icon(
                          isVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    obscureText: isVisible,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Container(
                    height: 42.0,
                    width: double.infinity,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(
                        15.0,
                      ),
                    ),
                    child: MaterialButton(
                      height: 42.0,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            isClicked = true;
                          });

                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text)
                              .then((userData) {
                            // Fluttertoast.showToast(
                            //   msg: userData.user!.uid,
                            // );

                            FirebaseMessaging.instance.getToken().then((value) {
                              UserDataModel model = UserDataModel(
                                uId: userData.user!.uid,
                                image: '',
                                email: emailController.text,
                                username: usernameController.text,
                                token: value!,
                              );

                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userData.user!.uid)
                                  .set(model.toJson())
                                  .then((value) {
                                setState(() {
                                  isClicked = false;
                                });

                                userConst = userData.user;

                                navigateAndFinish(
                                  context,
                                  const HomeScreen(),
                                );
                              }).catchError((error) {
                                Fluttertoast.showToast(
                                  msg: error.toString(),
                                );
                              });
                            });
                          }).catchError((error) {
                            setState(() {
                              isClicked = false;
                            });

                            Fluttertoast.showToast(
                              msg: error.toString().split(']').last,
                            );
                          });
                        }
                      },
                      child: isClicked
                          ? const CupertinoActivityIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Register',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
