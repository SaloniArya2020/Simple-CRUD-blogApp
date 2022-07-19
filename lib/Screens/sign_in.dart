import 'package:blog_app/Models/user.dart';
import 'package:blog_app/Screens/home.dart';
import 'package:blog_app/Screens/sign_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Users? currentUser;

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _key = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  signIn() async {
    try{
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());

      if (user.user!.emailVerified) {

        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.user!.uid)
            .get();

        setState(() {
          currentUser = Users.FromDocument(doc);
        });

        print(currentUser!.uid);

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));

      } else {
        final snackBar = SnackBar(content: Text('Verify your email!'));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }



    } on FirebaseAuthException catch(e){
      final snackBar = SnackBar(content: Text(e.message.toString()));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    'Sign In',
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
                  validator: (val) =>
                      val!.isEmpty ? 'Please write email' : null,
                  controller: _emailController,
                  decoration: InputDecoration(hintText: 'Email'),
                ),
                SizedBox(
                  height: 20,
                ),

                TextFormField(
                  obscureText: true,
                  validator: (val) =>
                      val!.isEmpty ? 'Please write password' : null,
                  controller: _passwordController,
                  decoration: InputDecoration(hintText: 'Password'),
                ),

                SizedBox(
                  height: 20,
                ),

                GestureDetector(
                  onTap: signIn,
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 40,
                    child: Text(
                      'Sign In',
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
                    Text('you don\'t have an account?'),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()));
                      },
                      child: Text(
                        ' SignUp!',
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
