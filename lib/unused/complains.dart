// import 'package:flutter/material.dart';
// import 'package:instiapp/classes/textcard.dart';

// class Complains extends StatefulWidget {
//   @override
//   _ComplainsState createState() => _ComplainsState();
// }

// List<TextCard> complainsCards = [];

// class _ComplainsState extends State<Complains> {


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.indigo,
//         title: Text('Complaints'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: complainsCards.map((card) {
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
//             complainsCards = [TextCard(title: data['title'], description: data['description'], image: data['image'])] + complainsCards;
//           });
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
