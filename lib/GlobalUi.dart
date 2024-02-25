
import 'package:flutter/cupertino.dart';
import 'package:otp_verification/MyFonts.dart';

Widget backButton(){
  return Image.asset("assets/back.png",height: 24,width: 24,);
}

Widget createText(String text,double size, Color color, String myfont){
  return Text(text,style: TextStyle(fontSize: size, color: color, fontFamily: myfont),);
}

enum otpstatus  {neutral, verified, invalid }
