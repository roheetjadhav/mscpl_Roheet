import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otp_verification/GlobalUi.dart';
import 'package:otp_verification/MyFonts.dart';
import 'package:otp_verification/Mycolors.dart';
import 'package:otp_verification/Screens/VerifyOtp.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  TextEditingController phone_con = TextEditingController();
  StreamController<bool> allow_con = StreamController.broadcast();

  @override
  void dispose() {
    super.dispose();
    phone_con.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mycolors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 36, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            backButton(),
            SizedBox(height: 38,),
            createText("Enter your mobile no", 24, Mycolors.ebony,MyFonts.Bold),
            SizedBox(height: 8,),
            createText("We need to verity your number", 16, Mycolors.palesky,MyFonts.Regular),
            SizedBox(height: 32,),
            RichText(
              text: TextSpan(
                style: new TextStyle(
                  fontSize: 14.0,
                  color: Mycolors.black,
                ),
                children: <TextSpan>[
                  new TextSpan(text: 'Mobile Number '),
                  new TextSpan(text: '*', style: new TextStyle(fontWeight: FontWeight.bold,color: Mycolors.red)),
                ],
              ),
            ),
            SizedBox(height: 10,),

            Container(
              height: 54,
              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Mycolors.palesky),
              ),
              child: TextFormField(
                showCursor: true,
                controller: phone_con,
                maxLength: 10,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter mobile no",
                  border: InputBorder.none,
                  counterText : "",
                ),
                style: TextStyle(fontSize: 14, color: Mycolors.palesky,fontFamily: MyFonts.Medium),
              ),
            ),

            Spacer(),

            StreamBuilder<bool>(
              stream: allow_con.stream,
              builder: (context, snapshot) {
                return InkWell(
                  onTap: (){
                    if(snapshot.data==true && phone_con.text.length ==10){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=> VerifyOtp(phone_con.text)));
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: snapshot.data==true && phone_con.text.length ==10? Mycolors.grayscale:Mycolors.lightgrey,
                    ),
                    child: Center(child: createText("Get OTP", 16, Mycolors.white,MyFonts.Bold)),
                  ),
                );
              }
            ),
            Spacer(),
            StreamBuilder<bool>(
              stream: allow_con.stream,
              initialData: false,
              builder: (context, snapshot) {
                return Row(
                  children: [
                    // Checkbox(
                    //   value: snapshot.data,
                    //   shape: CircleBorder(),
                    //   onChanged: (val){
                    //   allow_con.add(val!);
                    // },
                    // ),
                    snapshot.data == true ? InkWell(onTap:(){allow_con.add(false); },child: Image.asset("assets/radio.png",height: 24,width: 24,)) :
                    InkWell(
                onTap: (){
                  allow_con.add(true);
                },
                child: Container(
                        height: 24,width: 24,
                        decoration: BoxDecoration(
                          border: Border.all(color: Mycolors.grey1),
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ) ,

                    SizedBox(width: 12,),
                    Expanded(child: createText("Allow fydaa to send financial knowledge and critical alerts on your WhatsApp.", 12, Mycolors.palesky,MyFonts.Medium)),
                  ],
                );
              }
            ),


          ],
        ),
      ),
    );
  }
}
