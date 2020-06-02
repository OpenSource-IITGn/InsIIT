// import 'package:flutter/material.dart';
// import 'package:instiapp/classes/textcard.dart';


// class Articles extends StatefulWidget {
//   @override
//   _ArticlesState createState() => _ArticlesState();
// }

// List<TextCard> cards = [];

// class _ArticlesState extends State<Articles> {

//   // Retrieve old articles from catch while starting the app.

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.indigo,
//         title: Text('Articles'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: cards.map((card) {
//             return Card(
//               child: Column(
//                 children: <Widget>[
//                   card.textCard(),
//                   Row(
//                     children: <Widget>[
//                       FlatButton.icon(
//                         onPressed: () {
//                           setState(() {
//                             if (card.pressed == null) {
//                               card.upVote++;
//                               card.pressed = 'upVote';
//                               card.upVoteColor = Colors.blue;
//                             } else if (card.pressed == 'upVote') {
//                               card.upVote--;
//                               card.pressed = null;
//                               card.upVoteColor = Colors.black;
//                             } else if (card.pressed == 'downVote') {
//                               card.upVote++;
//                               card.downVote--;
//                               card.pressed = 'upVote';
//                               card.upVoteColor = Colors.blue;
//                               card.downVoteColor = Colors.black;
//                             }
//                           });
//                         },
//                         icon: Icon(
//                           Icons.thumb_up,
//                           color: card.upVoteColor,
//                         ),
//                         label: Text(
//                           '${card.upVote}',
//                         ),
//                       ),
//                       FlatButton.icon(
//                         onPressed: () {
//                           setState(() {
//                             if (card.pressed == null) {
//                               card.downVote++;
//                               card.pressed = 'downVote';
//                               card.downVoteColor = Colors.blue;
//                             } else if (card.pressed == 'downVote') {
//                               card.downVote--;
//                               card.pressed = null;
//                               card.downVoteColor = Colors.black;
//                             } else if (card.pressed == 'upVote') {
//                               card.upVote--;
//                               card.downVote++;
//                               card.pressed = 'downVote';
//                               card.downVoteColor = Colors.blue;
//                               card.upVoteColor = Colors.black;
//                             }
//                           });
//                         },
//                         icon: Icon(
//                           Icons.thumb_down,
//                           color: card.downVoteColor,
//                         ),
//                         label: Text(
//                           '${card.downVote}',
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.indigo,
//         onPressed: () async {
//           dynamic data = await Navigator.pushNamed(context, '/addtext');
//           setState(() {
//             cards = [TextCard(title: data['title'], description: data['description'], image: data['image'])] + cards;
//           });
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
