// class _LoginState extends State<Login>{
//   List<Interest> _selectedInterests;

//   @override
//   void initState() {
//     _selectedInterests = [];
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _selectedInterests.clear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User Preferences'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(10.0),

//             child: FlutterTagging<Interest>(
//               initialItems: _selectedInterests,
//               textFieldConfiguration: TextFieldConfiguration(
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   filled: true,
//                   fillColor: blackPlus.withAlpha(30),
//                   hintText: 'Add interests',
//                   //labelText: 'Select Tags',
//                 ),
//               ),
//               findSuggestions: InterestService.getPossibleInterests,
//               additionCallback: (val) {
//                 return Interest(
//                   value: val,
//                 );
//               },
//               onAdded: (newInterest) {
//                 // api calls here, triggered when add interest button is pressed
//                 return null;
//               },
//               configureSuggestion: (newInterest) {
//                 return SuggestionConfiguration(
//                   title: Text(newInterest.value),
//                   //subtitle: Text(lang.position.toString()),
//                   // additionWidget: Chip(
//                   //   avatar: Icon(
//                   //     Icons.add_circle,
//                   //     color: Colors.white,
//                   //   ),
//                   //   label: Text('Add Interest'),
//                   //   labelStyle: TextStyle(
//                   //     color: Colors.white,
//                   //     fontSize: 14.0,
//                   //     fontWeight: FontWeight.w300,
//                   //   ),
//                   //   backgroundColor: Colors.green,
//                   // ),
//                   additionWidget: Chip(
//                     avatar: Icon(
//                       Icons.cancel,
//                       color: Colors.white,
//                     ),
//                     label: Text("Clear"),
//                     labelStyle: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14.0,
//                       fontWeight: FontWeight.w300,
//                     ),
//                     backgroundColor: greyPlus,
//                   ),
//                 );
//               },
//               configureChip: (chosenInterest) {
//                 return ChipConfiguration(
//                   label: Text(chosenInterest.value),
//                   backgroundColor: amberPlus,
//                   labelStyle: TextStyle(color: Colors.white),
//                   deleteIconColor: Colors.white,
//                 );
//               },
//               onChanged: () {
//                 setState(() {
//                   print(_selectedInterests.map<String>((interest) => interest.value)
//                   .toList()
//                   .toString()
//                   );
                  
//                 });
//               },
//             ),
//           ),
//           SizedBox(
//             height: 20.0,
//           )
//         ],
//       ),
//     );
//   }
// }

// class InterestService {
//   /// Mocks fetching language from network API with delay of 500ms.
//   static Future<List<Interest>> getPossibleInterests(String query) async {
//     await Future.delayed(Duration(milliseconds: 500), null);
//     return <Interest>[
//       Interest(value: 'Mathematics'),
//       Interest(value: 'Pure Maths'),
//       Interest(value: 'Maths'),
//       Interest(value: 'Physics'),
//       Interest(value: 'Computing'),
//       Interest(value: 'English'),
//     ]
//         .where((lang) => lang.value.toLowerCase().contains(query.toLowerCase()))
//         .toList();
//   }
// }

// class Interest extends Taggable {
//   final String value;

//   Interest({this.value});

//   @override
//   List<Object> get props => [value];
// }