import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class Addtask extends StatefulWidget {
  const Addtask({super.key});

  @override
  State<Addtask> createState() => _AddtaskState();
}

class _AddtaskState extends State<Addtask> {
  TextEditingController titleController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();

void addtasktofirebase() async{

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = await auth.currentUser;
    String uid = user?.uid ?? "";
    var time = DateTime.now();

    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('my tasks')
        .doc(time.toString())
        .set({
      'title': titleController.text,
      'description': descriptionController.text,
      'time': time.toString(),
      'timestamp':time
    });

Fluttertoast.showToast(
        msg: 'Task added',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.lightGreenAccent,
        textColor: Colors.black,
      );

}



  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(title: Text('New task')),
      body: Container(padding: EdgeInsets.all(22),
      child: Column(
        children: [
          Container(child: TextField(
            controller: titleController,
            decoration: InputDecoration(
              
              labelText: 'Enter a Title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18)
              )),
          ),),
          SizedBox(height: 10),
                    Container(
                      
                      child: TextField(
                        controller: descriptionController,
            
            decoration: InputDecoration(
              labelText: 'Enter the description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18)
              )),
          ),),
          Container(
            padding: EdgeInsets.only(top: 10),
            width: double.infinity,
            height: 70,
            child:ElevatedButton(
              style:ElevatedButton.styleFrom(
                
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)
              ) ,
              backgroundColor: Colors.lightGreenAccent,
              ),
            
            onPressed: (){
              addtasktofirebase();
            }, child: Text('Add a task',style: GoogleFonts.roboto(fontSize: 16,
            color: Colors.black),
            ),), )
          
        ],
      ),),
    );
  }
}