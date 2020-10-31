import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      home: Scaffold(
        body: ContactUs(),
      ),
    );
  }
}

class ContactUs extends StatefulWidget {
  @override

  _ContactUsState createState() => _ContactUsState();
}


class _ContactUsState extends State<ContactUs> {


  final _firestore = Firestore.instance;

  sendMail() async{
    String username = 'samplemail@gmail.com';
    String password = 'pass';
    final smtpServer =gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Pundrikaksha Badal')
      ..recipients.add('info@redpositive.in')
      ..subject = 'Contact us form'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>Contact Us Form</h1>\n<p>Name : $name</p><p>Email address : $email</p><p>Mobile Number : $mobileNumber</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
  String name;
  String email;
  String mobileNumber;
 saveDataOnFirestoreDatabase(){
  _firestore.collection('Form').add({'Name':name,'Email address':email,'Mobile Number':mobileNumber});
 }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Text("Contact Us",style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold
          ),),
          BuildInputWidget(inputType: (input){name=input;},hintText: 'Enter Name',),
          BuildInputWidget(inputType: (input){email=input;},hintText: 'Enter email id',),
          BuildInputWidget(inputType: (input){mobileNumber=input;},hintText: 'Enter mobile number',),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              height: 50,
              width: 200,
              child: FlatButton(onPressed: (){
              sendMail();
           saveDataOnFirestoreDatabase();

              }, child: Text("Submit"),color: Colors.teal,shape: StadiumBorder(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BuildInputWidget extends StatelessWidget {
 BuildInputWidget(
 {this.hintText,this.inputType}
     );
final String hintText;
final Function inputType;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextField(
       decoration: InputDecoration(
         hintText: hintText,

       ),
        onChanged: inputType,
      ),
    );
  }
}
