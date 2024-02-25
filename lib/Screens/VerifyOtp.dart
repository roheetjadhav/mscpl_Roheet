import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otp_verification/GlobalUi.dart';
import 'package:otp_verification/MyFonts.dart';
import 'package:otp_verification/Mycolors.dart';

class VerifyOtp extends StatefulWidget {
  String phoneNo;
   VerifyOtp(this.phoneNo);

  @override
  _VerifyOtpState createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {

  List otpvalue = [];
  int opttextbox = 6;
  String hardcodedOtp = "934477";
  StreamController<otpstatus> otp_stream = StreamController.broadcast();
  StreamController<int> sec_con = StreamController.broadcast();
  Timer? timer ;
  int seconds = 170;
  int resendcode = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Mycolors.white,
        body: _body(),
      ),
    );
  }

  Widget _body(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 36, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
              onTap: (){
                _back();
              },
              child: backButton()),
          SizedBox(height: 16,),
          createText("Verify your phone", 32, Mycolors.grayscale1,MyFonts.Bold),
          SizedBox(height: 24,),
          createText("""Enter the verification code sent to\n (9**) ***-***${widget.phoneNo.substring(widget.phoneNo.length-2)}.
          """, 16, Mycolors.black,MyFonts.Medium),
          fillOtp(),
          Spacer(),
          onclickEvent("Resend Code"),
          SizedBox(height: 16,),
          onclickEvent("Change Number"),
        ],
      ),
    );
  }

  _back(){
    Navigator.pop(context);
  }



  Widget fillOtp(){
    return StreamBuilder<otpstatus>(
      stream: otp_stream.stream,
      initialData: otpstatus.neutral,
      builder: (context, snapshot) {
        return Container(
          decoration: BoxDecoration(
            color: snapshot.data == otpstatus.neutral ? Mycolors.white : snapshot.data == otpstatus.verified ? Mycolors.green : Mycolors.red,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              SizedBox(height: 16,),
              Row(
                children: List.generate(opttextbox, (index)  {
                  return Container(
                    margin: EdgeInsets.all(5),
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: snapshot.data == otpstatus.neutral ? Mycolors.lightgrey1 : Mycolors.white,
                    ),
                    child: TextFormField(
                      autofocus: true,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: "",
                        contentPadding: EdgeInsets.zero,
                      ),
                      maxLength: 1,
                      onChanged: (value){
                        if(value != ""){
                          otpvalue.add(value);
                          if(index != (opttextbox-1)){
                            FocusScope.of(context).nextFocus();
                          }else{
                            if(otpvalue.join("")==hardcodedOtp){
                              otp_stream.add(otpstatus.verified);
                            }else{
                              otp_stream.add(otpstatus.invalid);
                            }
                          }
                        }else{
                          otpvalue.removeLast();
                          if(index!=0){
                            FocusScope.of(context).previousFocus();
                            otp_stream.add(otpstatus.neutral);
                          }
                        }
                        print("otpvalue==>"+otpvalue.toString()+otpvalue.length.toString());

                      },
                    ),
                  );
                }),
              ),
              SizedBox(height: 15,),
              StreamBuilder<int>(
                stream: sec_con.stream,
                initialData: seconds,
                builder: (context, snapshot1) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      snapshot.data == otpstatus.neutral ? Container() : snapshot.data == otpstatus.verified ? Image.asset("assets/verify.png",height: 24,width: 24,) : Image.asset("assets/invalid.png",height: 24,width: 24,),
                      SizedBox(width: 8,),
                      createText(
                          snapshot.data == otpstatus.neutral? "Verification code expires in ${formattedTime(snapshot1.data!)}": snapshot.data == otpstatus.verified ? "Verified":"Invalid OTP",
                          14,
                         snapshot.data == otpstatus.neutral ? Mycolors.grey1 : Mycolors.white,MyFonts.Medium
                      ),
                    ],
                  );
                }
              ),
              SizedBox(height: 16,),
            ],
          ),
        );
      }
    );
  }

  formattedTime( int timeInSecond) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }

  Widget onclickEvent(String text){
    return StreamBuilder<int>(
      stream: sec_con.stream,
      builder: (context, snapshot) {
        return InkWell(
          onTap: (){
            switch(text.toLowerCase()){
              case "resend code":
                resendcode = resendcode + 1;
                if(seconds != 0){
                  return;
                }
                if(resendcode<5){
                  otpvalue.clear();
                  startTimer();
                  otp_stream.sink.add(otpstatus.neutral);
                }
                break;
              case "change number":
                _back();
                break;
            }
          },
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Mycolors.lightgrey1),
            ),
            child: Center(child: createText(text, 16,(text.toLowerCase()=="resend code" && seconds !=0)?Mycolors.grey1:Mycolors.grayscale1,MyFonts.Bold)),
          ),
        );
      }
    );
  }

  void startTimer(){
    seconds = 170;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      seconds--;
      if(seconds>0){
        sec_con.sink.add(seconds);
      }else{
        stopTimer();
      }

    });
  }
   void stopTimer(){
    timer!.cancel();
    sec_con.sink.add(seconds);
   }

}
