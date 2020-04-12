import 'package:flutter/material.dart';
import 'package:tutorsplus/services/auth.dart';
import 'package:tutorsplus/shared/common.dart';

class Homepage extends StatelessWidget {

  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
        Row(
          children: <Widget>[
            Expanded(
              child: SizedBox(
                height: 40,
                child: RaisedButton(
                  color: purplePlus,
                  child: Text(
                    'Sign out',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    await _auth.signOut();
                  }
                ),
              ),
            ),

            SizedBox(width: 40),

            Expanded(
              child: SizedBox(
                height: 40,
                child: RaisedButton(
                  color: Colors.red,
                  child: Text(
                    'Sign out of Google',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () async {
                    
                  }
                ),
              ),
            ),
          ],
        ),
    );
  }
}