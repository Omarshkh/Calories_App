import 'package:flutter/material.dart';
import 'package:flutterflow_assesment/Screens/Details/details.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          SizedBox.expand(
            child: Positioned.fill(
              child: Image.asset("assets/images/welcome_img.jpg",fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              )
            ),
          ),
          // Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.15), // Optional dark overlay
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 48,left: 46),
            child: Container(child: Text("Balanced Meal",style:  GoogleFonts.abhayaLibre(color:Colors.white,fontSize: 48,fontWeight: FontWeight.bold)),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 559,left: 24),
            child: Container(child: Text("Craft your ideal meal effortlessly with our app. Select nutritious ingredients tailored to your taste and well-being.",style: GoogleFonts.poppins(fontSize: 20,color: Colors.white), textAlign: TextAlign.center,),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 709,left: 24),
            child:  ElevatedButton(
              
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(350, 60),
                      backgroundColor: const Color.fromRGBO(242, 87, 0, 1),
                      shape: RoundedRectangleBorder(
                      
                        borderRadius: BorderRadius.circular(12),
                        
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    ),
                    onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>EnterDetailsScreen()));
                    },
                    child: Text(
                      'Order Food',
                      style: GoogleFonts.poppins(fontSize: 16,color: Colors.white,),textAlign: TextAlign.center,
                    ),
                  )
          )
         ],
      ),
    );
  }
}