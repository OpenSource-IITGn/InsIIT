import 'package:flutter/material.dart';
import 'package:instiapp/themeing/notifier.dart';
import 'package:instiapp/utilities/biodataStore.dart';

/// Lets a student enter their own details once, so features do not have to ask
/// for them again. See issue #22.
class BiodataPage extends StatefulWidget {
  @override
  _BiodataPageState createState() => _BiodataPageState();
}

class _BiodataPageState extends State<BiodataPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _roll = TextEditingController();
  final TextEditingController _programme = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _bio = TextEditingController();

  bool _loaded = false;
  String _message;

  @override
  void initState() {
    super.initState();
    _prefill();
  }

  Future<void> _prefill() async {
    final Map<String, String> data = await BiodataStore.load();
    if (!mounted) return;
    setState(() {
      _name.text = data['name'];
      _roll.text = data['roll'];
      _programme.text = data['programme'];
      _mobile.text = data['mobile'];
      _bio.text = data['bio'];
      _loaded = true;
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _roll.dispose();
    _programme.dispose();
    _mobile.dispose();
    _bio.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await BiodataStore.save(<String, String>{
      'name': _name.text.trim(),
      'roll': _roll.text.trim(),
      'programme': _programme.text.trim(),
      'mobile': _mobile.text.trim(),
      'bio': _bio.text.trim(),
    });
    if (!mounted) return;
    setState(() {
      _message = 'Saved. Your details stay on this device.';
    });
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    String hint,
    int maxLines = 1,
    TextInputType keyboard,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.textHeadingColor,
          ),
        ),
        SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboard,
          style: TextStyle(color: theme.textHeadingColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: theme.textSubheadingColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: theme.appBarColor,
        title: Text(
          'My Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.textHeadingColor,
          ),
        ),
        iconTheme: IconThemeData(color: theme.iconColor),
      ),
      body: !_loaded
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Fill these in once and they stay on your device, so other '
                    'parts of the app do not have to ask again.',
                    style: TextStyle(color: theme.textSubheadingColor),
                  ),
                  SizedBox(height: 20),
                  _field('Name', _name, hint: 'Your full name'),
                  SizedBox(height: 16),
                  _field('Roll Number', _roll, hint: 'e.g. 19110001'),
                  SizedBox(height: 16),
                  _field('Programme', _programme, hint: 'e.g. B.Tech, EE'),
                  SizedBox(height: 16),
                  _field('Mobile Number', _mobile,
                      hint: '10-digit number',
                      keyboard: TextInputType.phone),
                  SizedBox(height: 16),
                  _field('About you', _bio,
                      hint: 'A short bio', maxLines: 3),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      color: theme.buttonColor,
                      onPressed: _save,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(14.0),
                        child: Text(
                          'Save',
                          style: TextStyle(color: theme.buttonContentColor),
                        ),
                      ),
                    ),
                  ),
                  (_message != null)
                      ? Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            _message,
                            style: TextStyle(color: theme.upvoteColor),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
    );
  }
}
