import 'package:tutorsplus/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:tutorsplus/shared/common.dart';
import 'package:tutorsplus/shared/loading.dart';

class Login extends StatefulWidget {

  final Function toggleView;
  Login({ this.toggleView });

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(      
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 40.0),
              Center(
                child: Container(
                  height: 200,
                  width: 260,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/cham.png'),
                      fit: BoxFit.fill,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'email'),
                      validator: (val) => val.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      obscureText: true,
                      decoration: textInputDecoration.copyWith(hintText: 'password'),
                      validator: (val) => val.length < 6 ? 'Enter a password 6+ chars long' : null,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    
                    SizedBox(height: 40.0),

                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: RaisedButton(
                        color: orangePlus,
                        child: Text(
                          'Log in',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if(_formKey.currentState.validate()){
                            setState(() => loading = true);
                            dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                            if(result == null) {
                              setState(() {
                                loading = false;
                                error = 'Could not login with those credentials';
                              });
                            }
                          }
                        }
                      ),
                    ),
                    
                    SizedBox(height: 20.0),
                    
                    Row(
                      children: <Widget>[
                        Icon(Icons.email),
                        SizedBox(
                          //width: double.infinity,
                          height: 40,
                          child: RaisedButton(
                            color: Colors.red,

                            child: Text(
                              'Login with Google',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              setState(() => loading = true);
                              dynamic result = await _auth.signInWithGoogle();
                              if(result == null) {
                                setState(() {
                                  loading = false;
                                  error = 'Could not login with Google';
                                });
                              }
                            }
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("New User?  "),
                        GestureDetector(
                          onTap: () => widget.toggleView(),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: amberPlus,
                              fontSize: 14,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
