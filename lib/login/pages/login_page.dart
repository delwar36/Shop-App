import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation logoanimation;
  String _email, _password, _emailpassword;
  FocusNode focusNode;
  bool _isLoading = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    logoanimation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    logoanimation.addListener(() => this.setState(() {}));
    animationController.forward();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      print("Email: $_email Password: $_password");
      _login();
      setState(() {
        _isLoading = true;
      });
    }
  }

  void _login() async {
    try {
      String uid = await widget.auth.signIn(_email, _password);
      print("Signed in : $uid");
      widget.onSignedIn();
      // await widget.auth.isEmailVerified().then((isVerified) async{
      //   if (isVerified){
      //     print("Verified");
      //     widget.onSignedIn();}
      //   else {
      //     final snackBar = SnackBar(
      //       content: Text("Email Not Verified!"),
      //       duration: Duration(seconds: 2),
      //       action: SnackBarAction(
      //           label: "Send Again",
      //           onPressed: () async {
      //             await widget.auth.sendEmailVerification();
      //           }
      //       ),
      //     );
      //     scaffoldKey.currentState.showSnackBar(snackBar);
      //     await Future.delayed(Duration(milliseconds: 1001));
      //     await widget.auth.signOut();
      //   }
      // },
      // );
    } catch (e) {
      final snackBar = SnackBar(content: Text("সাইন ইন করতে সমস্যা হচ্ছে!"));
      setState(() {
        _isLoading = false;
      });
      scaffoldKey.currentState.showSnackBar(snackBar);
      print("Error: $e");
    }
  }

  void _passwordReset() async {
    final form = formKey1.currentState;
    if (form.validate()) {
      form.save();
      try {
        await widget.auth.resetPassword(_emailpassword);
        Navigator.of(context).pop();
        final snackBar =
            SnackBar(content: Text("পাসওয়ার্ড রিসেট কোড পাঠানো হয়েছে"));

        Scaffold.of(context).hideCurrentSnackBar();
        scaffoldKey.currentState.showSnackBar(snackBar);
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Image.asset(
          //   "assets/images/login.jpg",
          //   fit: BoxFit.cover,
          //   color: Colors.blue,
          //   colorBlendMode: BlendMode.darken,
          // ),
          Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: ListView(
              children: <Widget>[
                Container(
                  height: 100.0,
                ),
                Image.asset(
                  "assets/images/loginlogo.png",
                  height: logoanimation.value * 80,
                  width: logoanimation.value * 80,
                ),
                Padding(padding: EdgeInsets.only(top: 85.0)),
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "ইমেইল দিন",
                          labelText: "ইমেইল",
                          labelStyle: TextStyle(color: Colors.grey),
                          hintStyle:
                              TextStyle(color: Colors.grey.withOpacity(.45)),
                          icon: Icon(
                            Icons.mail,
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                        style: TextStyle(color: Colors.blue),
                        validator: (val) =>
                            !val.contains('@') ? "অকার্যকর ইমেইল" : null,
                        onSaved: (val) => _email = val,
                        onFieldSubmitted: (val) =>
                            FocusScope.of(context).requestFocus(focusNode),
                      ),
                      Padding(padding: EdgeInsets.only(top: 30.0)),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "পাসওয়ার্ড দিন",
                          labelText: "পাসওয়ার্ড",
                          labelStyle: TextStyle(color: Colors.grey),
                          hintStyle:
                              TextStyle(color: Colors.grey.withOpacity(.45)),
                          icon: Icon(
                            Icons.lock,
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                        obscureText: true,
                        style: TextStyle(color: Colors.blue),
                        validator: (val) =>
                            val.length < 6 ? "পাসওয়ার্ড খুব ছোট" : null,
                        onSaved: (val) => _password = val,
                        focusNode: focusNode,
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 40.0)),
                Container(
                  height: 45.0,
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: Colors.blue[400].withOpacity(.6),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: FlatButton(
                    color: Colors.blue,
                    onPressed: _isLoading ? () {} : _submit,
                    child: _isLoading
                        ? CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          )
                        : Text(
                            "লগইন",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontFamily: "Karla",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    splashColor: Colors.blue[800],
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 15.0)),
                FlatButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              title: Text("পাসওয়ার্ড রিসেট করুন"),
                              content: Form(
                                key: formKey1,
                                child: TextFormField(
                                  onSaved: (val) => _emailpassword = val,
                                  validator: (val) => !val.contains('@')
                                      ? "অকার্যকর ইমেইল"
                                      : null,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(color: Colors.blue),
                                  decoration: InputDecoration(
                                    hintText: "ইমেইল দিন",
                                    labelText: "ইমেইল",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                  ),
                                  autofocus: true,
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text(
                                      "বাতিল",
                                      style: TextStyle(color: Colors.black),
                                    )),
                                RaisedButton(
                                  onPressed: () {
                                    _passwordReset();
                                  },
                                  child: Text(
                                    "সাবমিট",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.green,
                                )
                              ],
                            );
                          });
                    },
                    child: Text(
                      "পাসওয়ার্ড ভুলে গেছেন?",
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Karla",
                          fontSize: 16.0),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
