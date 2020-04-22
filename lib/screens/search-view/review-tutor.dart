import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:tutorsplus/models/tutor.dart';
import 'package:tutorsplus/models/user.dart';
import 'package:tutorsplus/services/database.dart';
import 'package:tutorsplus/shared/common.dart';
import 'package:tutorsplus/shared/loading.dart';

class ReviewTutor extends StatefulWidget {

  final User user;
  final TutorData tutorData;

  ReviewTutor({this.user, this.tutorData});
  @override
  _ReviewTutorState createState() => _ReviewTutorState();
}

class _ReviewTutorState extends State<ReviewTutor> {

  String review = "";
  double rating = 0;
  bool _loading = false;
  final _formBuilderKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return _loading? Loading() : Material(
      child: Container(
        color: whitePlus,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FormBuilder(
              key: _formBuilderKey,
              autovalidate: false,
              child: Column(
                children: <Widget>[

                  Text(
                    'Tutor Review',
                    style: TextStyle(
                      color: blackPlus,
                      fontFamily: 'OpenSans',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Card(
                    child: FormBuilderTextField( 
                      attribute: 'review_field',
                      maxLines: 4,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Enter your review...',
                        border: InputBorder.none, 
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20)
                      ),
                      validators: [
                        FormBuilderValidators.required(errorText: "Review text required")
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  Text(
                    'Tutor Rating',
                    style: TextStyle(
                      color: blackPlus,
                      fontFamily: 'OpenSans',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),
                  
                  SmoothStarRating(
                    allowHalfRating: false,
                    onRatingChanged: (v) {
                      setState(() {
                        rating = v;
                      });
                    },
                    starCount: 5,
                    rating: rating,
                    size: 40.0,
                    color: yellowPlus,
                    borderColor: yellowPlus,
                    spacing:0.0
                  ),

                  SizedBox(height: 20),

                ]
              )
            ),
            //SUBMIT BUTTON
              Container(
                padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 75),
                width: double.infinity,
                child: RaisedButton(
                  elevation: 5.0,
                  padding: EdgeInsets.all(15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  color: amberPlus,
                  child: Text(
                    'Add Review',
                    style: TextStyle(
                      color: whitePlus,
                      letterSpacing: 1.5,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  onPressed: () async {
                    if(_formBuilderKey.currentState.saveAndValidate()){
                      setState(() {
                        _loading = true;
                        review = _formBuilderKey.currentState.value['review_field'];

                        print(review);
                      });

                      await DatabaseService(uid: widget.user.uid).addReview(widget.tutorData, review, rating);
                      Navigator.pop(context);
                    }
                  }
                ),
              ),
          ],
        ),
      ),
    );
  }
}