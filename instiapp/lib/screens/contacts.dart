import 'package:flutter/material.dart';
import 'package:instiapp/screens/classes/contactcard.dart';


class Contacts extends StatefulWidget {

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {

  List<ContactCard> cards = [
    ContactCard(name: 'Fire:', contacts: ['Fire and emergency services, Gandhinagar - 079-23222100, 079-23222742', 'Mr. Maheshkumar M. Parmar (Safety Supervisor, IITGN) - 09879560096']),
    ContactCard(name: 'Police:', contacts: ['Police Control Room, Gandhinagar - 079-23210914, 079-23210106', 'Chiloda Police Station - 079-23273600, 079-23273737']),
    ContactCard(name: 'Ambulance:', contacts: ['Dial - 108', 'Junior Citizen Council, Gandhinagar - 079-23242023, 079-23240182, 09426833344', 'General Hospital (Civil), Gandhinagar - 079-23221931, 079-23221932, 079-23221933']),
    ContactCard(name: 'IITGN Security (SIS):', contacts: ['Security Supervisor - 07567935473, 07567935474', 'Main Gate - 07069016201']),
    ContactCard(name: 'IITGN Medical Facility:', contacts: ['Mr. Mukesh Sharma - 09276836488', 'Mr. Hareshkumar Chaudhari - 08140893650']),
    ContactCard(name: 'Lift Issues:', contacts: ['Mr. Vishnu Deth (Tech. Officer, IITGN) - 09925422163']),
    ContactCard(name: 'Snake catchers:', contacts: ['Contact to Security Main Gate - 07069016201', 'Mr. Pankajsinh Bihola (Palaj) - 09099325553', 'Mr. Kaushiksinh Bihola (Palaj) - 08733004456', 'Mr. Bhaviksinh Bihola (Palaj) - 09909569691', 'Note: Please keep watch on the whereabouts of the snake until snake catcher/help arrives.']),
    ContactCard(name: 'Any other student emergency:', contacts: ['Mr. Vishwajeet Mishra - 09898037530', 'Security Guard (Block-F) - 07573951949']),
    ContactCard(name: 'Maintenance Issues:', contacts: ['For Civil Emergency- Mr. R L Sharma (Sr. AE, IITGN) - 09974191333', 'For Electrical Emergency- Mr. L K Mishra (AE, IITGN) - 09630189649']),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Important Contacts'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: cards.map((card) => card.contactCard()).toList(),
        ),
      ),
    );
  }
}
