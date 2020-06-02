// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class AddText extends StatefulWidget {
//   @override
//   _AddTextState createState() => _AddTextState();
// }

// class _AddTextState extends State<AddText> {

//   final myControllerTitle = new TextEditingController();
//   final myControllerDescription = new TextEditingController();

//   @override
//   void dispose() {
//     myControllerTitle.dispose();
//     myControllerDescription.dispose();
//     super.dispose();
//   }

//   File _image;

//   Future getImage() async {

//     FocusScope.of(context).unfocus();
//     var image = await ImagePicker.pickImage(source: ImageSource.gallery);

//     setState(() {
//       _image = image;
//     });
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.indigo,
//         title: Text('Send Details'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             textInput('Title', 2, 20.0, myControllerTitle),
//             textInput('Description', 10, 18.0, myControllerDescription),
//             RaisedButton.icon(
//               color: Colors.indigo,
//               onPressed: getImage,
//               icon: Icon(
//                 Icons.attachment,
//                 color: Colors.white,
//               ),
//               label: Text(
//                 'Attach Image',
//                 style: TextStyle(
//                     color: Colors.white
//                 ),
//               ),
//             ),
//             SizedBox(height: 10.0,),
//             RaisedButton.icon(
//               color: Colors.indigo,
//               onPressed: () {
//                 Navigator.pop(context,{
//                   'title' : myControllerTitle.text,
//                   'description' : myControllerDescription.text,
//                   'image' : _image,
//                 });
//               },
//               icon: Icon(
//                 Icons.send,
//                 color: Colors.white,
//               ),
//               label: Text(
//                 'Send',
//                 style: TextStyle(
//                   color: Colors.white,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// Widget textInput (String text,int maxLines,double fontSize, TextEditingController controller) {
//   return Padding(
//     padding: const EdgeInsets.all(20.0),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           text,
//           style: TextStyle(
//             letterSpacing: 2.0,
//             fontSize: 20.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Container(
//           margin: EdgeInsets.all(8.0),
//           padding: EdgeInsets.only(bottom: 5.0),
//           child: TextField(
//             controller: controller,
//             style: TextStyle(
//               fontSize: fontSize,
//             ),
//             maxLines: maxLines,
//             decoration: InputDecoration(
//               hintText: '$text.....',
//               border: OutlineInputBorder(),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
