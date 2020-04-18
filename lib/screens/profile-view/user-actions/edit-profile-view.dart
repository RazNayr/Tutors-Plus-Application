import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:tutorsplus/models/user.dart';
import 'package:tutorsplus/services/database.dart';
import 'package:tutorsplus/shared/category.dart';
import 'package:tutorsplus/shared/common.dart';

class EditUserProfile extends StatefulWidget {

  final UserData userData;

  EditUserProfile({this.userData});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditUserProfile> {
  
  double screenWidth;
  double screenHeight;
  bool _canAddTags;
  String fname = '';
  String lname = '';
  List<String> _userPrefs;
  List<String> _prefSuggestions = Category().getCategories();

  final _formBuilderKey = GlobalKey<FormBuilderState>();
  final _tagStateKey = GlobalKey<TagsState>();
  
  @override
  Widget build(BuildContext context) {

    final userData = widget.userData;
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: blackPlus,
        elevation: 0.0,
      ),

      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: whitePlus,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child:FormBuilder(
          key: _formBuilderKey,
          autovalidate: false,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 30.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTitleCont(),
                _buildImageCont(),
                SizedBox(height: 30),
                _buildFirstNameCont(userData.fname),
                SizedBox(height: 30),
                _buildLastNameCont(userData.lname),
                SizedBox(height: 30),
                _buildInterestsCont(_userPrefs ?? userData.interests),
                _buildSaveCont(userData.uid),
                SizedBox(height: 60),
            ]),
          ),
        )
      ),
        
    );
  }

  Widget _buildTitleCont(){
    return Container(
      child: Text(
        'Edit User Profile',
        style: TextStyle(
          color: blackPlus,
          fontFamily: 'OpenSans',
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
      )
    );
  }

  Widget _buildImageCont(){
    return Stack(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage('assets/profile-icon.jpg'),
          radius: screenWidth * 0.2,
        ),
        Container(
          width: screenWidth * 0.2 * 2,
          height: screenWidth * 0.2 * 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(Icons.add_a_photo, color: blackPlus,)
          ]),
        )
      ]
    );
  }

  Widget _buildFirstNameCont(userFname){
    return FormBuilderTextField( 
      attribute: 'fname_field',
      initialValue: userFname,
      maxLines: 1,
      decoration: textInputDecoration.copyWith(labelText: 'First Name'),
      validators: [
        FormBuilderValidators.required(errorText: "A first name is required")
      ],
    );
  }

  Widget _buildLastNameCont(userLname){
    return FormBuilderTextField( 
      attribute: 'lname_field',
      initialValue: userLname,
      maxLines: 1,
      decoration: textInputDecoration.copyWith(labelText: 'Last Name'),
      validators: [
        FormBuilderValidators.required(errorText: "A last name is required")
      ],
    );
  }

  Widget _buildInterestsCont(userInterests){

    double _fontSize = 14;

    _userPrefs = userInterests;
    _userPrefs.length >= 5 ? _canAddTags = false : _canAddTags = true;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "Your Interests",
          style: TextStyle(
          fontFamily: 'OpenSans',
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          )
        ),

        SizedBox(height: 20),

        Tags(
          key:_tagStateKey,
          //spacing: screenWidth,
          textField: !_canAddTags? null : TagsTextField(
            textStyle: TextStyle(fontSize: _fontSize),
            hintText: "Add an interest!",
            constraintSuggestion: true,
            suggestions: _prefSuggestions,
            suggestionTextColor: greyPlus,
            duplicates: false,
            autocorrect: true,
            autofocus: false,
            width: double.infinity,
            onSubmitted: (String str) {
              // Add item to the data source.
              setState(() {
                _userPrefs.add(str);
              });
            },
          ),
          itemCount: _userPrefs.length, // required
          itemBuilder: (int index){          
            final item = _userPrefs[index];

            return ItemTags(
              key: Key(index.toString()),
              index: index, // required
              title: item,
              pressEnabled: false,
              colorShowDuplicate: Colors.blueGrey,
              textStyle: TextStyle( fontSize: _fontSize, ),
              combine: ItemTagsCombine.withTextBefore,
              // icon: ItemTagsIcon(
              //   icon: Icons.add,
              // ), // OR null,
              removeButton: ItemTagsRemoveButton(
                onRemoved: (){
                    // Remove the item from the data source.
                    setState(() {
                        _userPrefs.removeAt(index);
                    });
                    return true;
                },
              ),
              //onPressed: (item) => print(item),
              //onLongPressed: (item) => print(item),
            );
        
          },
        ),
      ],
    );  
  }

  Widget _buildSaveCont(userId){
    return Container(
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
          'SAVE',
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
            await DatabaseService(uid: userId).updateUserProfileDetails(
              _formBuilderKey.currentState.value['fname_field'],
              _formBuilderKey.currentState.value['lname_field'],
              _userPrefs,
            );
            Navigator.pop(context);
          }
        }
      ),
    );
  }
}