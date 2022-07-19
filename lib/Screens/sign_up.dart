import 'package:blog_app/Screens/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _key = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  signup() async {
    if (_key.currentState!.validate()) {
      try {
        UserCredential user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim());

        user.user!.sendEmailVerification().whenComplete(() {
          FirebaseFirestore.instance
              .collection('users')
              .doc(user.user!.uid)
              .set({
            'uid': user.user!.uid,
            'username': _usernameController.text.trim(),
            'email': user.user!.email,
            'profilePhoto': 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png'
          }).whenComplete(() {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => SignInPage()));
          });
        });

      } on FirebaseAuthException catch (e) {

        print(e.message);

        final snackBar = SnackBar(
          content: Text(e.message.toString()),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog App'),
        backgroundColor: Colors.green[400],
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          key: _key,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900]),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? 'Please add username' : null,
                  controller: _usernameController,
                  decoration: InputDecoration(hintText: 'Username'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? 'Please add email' : null,
                  controller: _emailController,
                  decoration: InputDecoration(hintText: 'Email'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? 'Please add password' : null,
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(hintText: 'Password'),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: signup,
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 40,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.indigo[300]),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?'),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInPage()));
                      },
                      child: Text(
                        ' SignIn!',
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
