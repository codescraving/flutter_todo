import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Description extends StatelessWidget {
  final title,description;
  const Description({super.key, this.title, this.description, required Color color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Description')),
      body: Container(
        
        child: Column(children: [
          Container(
           margin: EdgeInsets.all(10),
            child: Text(title,style: GoogleFonts.roboto(fontSize: 25,fontWeight:FontWeight.bold),)),

      Container(
           margin: EdgeInsets.all(10),
            child: Text(description,style: GoogleFonts.roboto(fontSize: 19,fontWeight:FontWeight.bold),))
      ]  ),
      ),
      
    );
  }
}