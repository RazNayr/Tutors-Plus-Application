import 'package:flutter/gestures.dart';
import 'package:tutorsplus/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:tutorsplus/shared/common.dart';
import 'package:tutorsplus/shared/loading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

//For DateTime form fields
import 'package:intl/intl.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final GlobalKey<FormBuilderState> _formBuilderKey = GlobalKey<FormBuilderState>();
  final AuthService _auth = AuthService();

  Map<String,dynamic> userData = new Map();

  String error = '';
  String email = '';
  String password = '';

  bool loading = false;
  bool _obscurePassword = true;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {

    return loading ? Loading() : Scaffold(
      backgroundColor: whitePlus,

      appBar: AppBar(
        backgroundColor: blackPlus,
        elevation: 0.0,
        title: Text('Sign Up to Tutors+'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Sign In'),
            onPressed: () => widget.toggleView(),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Column(
            children: <Widget>[

              //Form Builder
              FormBuilder(
                key: _formBuilderKey,
                autovalidate: false,

                //Form Fields
                child: Column(
                  children: <Widget>[
                    
                    //Email Text Field
                    FormBuilderTextField( 
                      attribute: 'email_field',
                      maxLines: 1,
                      decoration: textInputDecoration.copyWith(hintText: 'Email', suffixIcon: Icon(Icons.email)),
                      validators: [
                        FormBuilderValidators.email(errorText: "Valid email address required"),
                        FormBuilderValidators.required(errorText: "Valid email address required")
                      ],
                    ),

                    SizedBox(height: 20),

                    //Password Text Field
                    FormBuilderTextField( 
                      attribute: 'pass_field',
                      maxLines: 1,
                      decoration: textInputDecoration.copyWith(hintText: 'password', suffixIcon: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility), onPressed: _toggle)),
                      obscureText: _obscurePassword,
                      validators: [
                        FormBuilderValidators.required(errorText: "Password required"),
                      ],
                    ),

                    SizedBox(height: 20),

                    //First Name Text Field
                    FormBuilderTextField( 
                      attribute: 'fname_field',
                      maxLines: 1,
                      decoration: textInputDecoration.copyWith(labelText: 'First Name'),
                      validators: [
                        FormBuilderValidators.required(errorText: "First name required")
                      ],
                    ),

                    SizedBox(height: 20),

                    //First Name Text Field
                    FormBuilderTextField( 
                      attribute: 'lname_field',
                      maxLines: 1,
                      decoration: textInputDecoration.copyWith(labelText: 'Last Name'),
                      validators: [
                        FormBuilderValidators.required(errorText: "Last name required")
                      ],
                    ),

                    SizedBox(height: 20),

                    //User DOB Field
                    FormBuilderDateTimePicker(
                      attribute: 'dob_field',
                      inputType: InputType.date,
                      format: DateFormat("dd-MM-yyyy"),
                      decoration: textInputDecoration.copyWith(labelText: 'Date of birth'),
                      validators: [
                        FormBuilderValidators.required(errorText: "Date of birth required")
                      ],
                    ),

                    SizedBox(height: 20),

                    //User Gender Field
                    FormBuilderRadio(
                      attribute: "gender_field",
                      decoration: textInputDecoration.copyWith(labelText: 'Gender'),
                      validators: [
                        FormBuilderValidators.required(errorText: "Gender required")
                      ],
                      options: ["Male","Female","Other",]
                          .map((gender) => FormBuilderFieldOption(value: gender))
                          .toList(growable: false),
                    ),

                    SizedBox(height: 20),

                    //Terms and Conditions Field
                    FormBuilderCheckbox(
                      attribute: 'accept_terms',
                      initialValue: false,
                      leadingInput: false,
                      label: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'I have read and agree to the ',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: 'Terms and Conditions',
                              style: TextStyle(color: purplePlus),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print("launch url");
                                },
                            ),
                          ],
                        ),
                      ),
                      validators: [
                        FormBuilderValidators.requiredTrue(
                          errorText:"You must accept terms and conditions to continue",
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 20.0),

                    //Validation error
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),

                    SizedBox(height: 60),

                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            color: blackPlus,
                            child: Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (_formBuilderKey.currentState.saveAndValidate()) {
                                setState((){
                                  loading = true;
                                  email = _formBuilderKey.currentState.value['email_field'];
                                  password = _formBuilderKey.currentState.value['pass_field'];

                                  //User Data Map
                                  userData['fname'] = _formBuilderKey.currentState.value['fname_field'];
                                  userData['lname'] = _formBuilderKey.currentState.value['lname_field'];
                                  userData['dob'] = _formBuilderKey.currentState.value['dob_field'];
                                  userData['gender'] = _formBuilderKey.currentState.value['gender_field'];
                                });
                                dynamic result = await _auth.registerWithEmailAndPassword(email, password, userData);

                                if(result is String) {
                                  setState(() {
                                    loading = false;
                                    error = result;
                                  });
                                }
                              } 
                            },
                          ),
                        ),
                        
                        SizedBox(width: 20),

                        Expanded(
                          child: MaterialButton(
                            color: blackPlus,
                            child: Text(
                              "Reset",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              _formBuilderKey.currentState.reset();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

              )
            ],
          ),
        ),
      )
    );
  }
}