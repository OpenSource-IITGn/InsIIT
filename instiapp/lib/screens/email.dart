import 'package:flutter/material.dart';

class Email extends StatefulWidget {
  @override
  _EmailState createState() => _EmailState();
}

class _EmailState extends State<Email> {
  
  List <Data> emails = [
    Data(email: 'flutter@gmail.com', name: 'Dart'),
    Data(email: 'python@iitgn.ac.in', name: 'Random'),
    Data(email: 'python@iitgn.ac.in', name: 'Random'),
    Data(email: 'python@iitgn.ac.in', name: 'Random'),
    Data(email: 'python@iitgn.ac.in', name: 'Random'),
    Data(email: 'python@iitgn.ac.in', name: 'Random'),
    Data(email: 'python@iitgn.ac.in', name: 'Random'),
    Data(email: 'python@iitgn.ac.in', name: 'Random'),
    Data(email: 'python@iitgn.ac.in', name: 'Random'),


  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Links'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.blue[250],
      ),

      body : SingleChildScrollView(
              child: Column(
          // children: {template(emails[0])}.toList(),
          children : emails.map( (currentobject) => Template(obj: currentobject)).toList(),

          //.toList across the whole emails.map(), since the children of coloumn need to be in list 
          
          //since children property expects a list, adding .toList()
        ),
      )
      
    );
  }
}

class Data {

  String email;
  String name;
  // String contact;
  // String extra;

  Data({ String email, String name}){
    this.email = email;
    this.name = name;

  // Data({this.email, this.name}); // a way of writing the same as above

  }

}

class Template extends StatelessWidget {
  const Template({
    Key key,
    @required this.obj,
  }) : super(key: key);

  final obj;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin : EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      
      child : Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.stretch,
          
          children: <Widget>[
            Text(
              
              obj.email,
              style: TextStyle(
                fontSize: 28,
                color: Colors.blue[600],
                ),
            ),

            SizedBox(height: 6.0,),

            Text(
              obj.name,
              style : TextStyle(fontSize: 20.0, color: Colors.grey[800])

            )
          ],
        ),
      ),
    );

  }
}