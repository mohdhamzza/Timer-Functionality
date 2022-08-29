import 'dart:async';
import 'package:timer_3/notification.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{

 late TabController tb;
 int hour = 0;
 int min = 0;
 int sec = 0;
 bool started = true;
 bool stopped = true;
 int timeForTimer = 0;
 String timeToDisplay = "";
bool checkTimer = true;

  @override
  void initState() {
    tb = TabController(length: 2, vsync: this);
    super.initState();
  }
  void start(){
    setState((){
      started = false;
      stopped = false;
    });
    timeForTimer = ((hour * 60 * 60) + (min * 60) + sec);
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if(timeForTimer < 0 || checkTimer == false){
          t.cancel();
          if(timeForTimer == 0){
            debugPrint('Stopped by default');
          }
          Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(),
          ));
        }
        else if(timeForTimer < 60){
          timeToDisplay = timeForTimer.toString();
          timeForTimer = timeForTimer - 1;
        }else if(timeForTimer < 3600) {
          var m = timeForTimer ~/ 60;
          var s = timeForTimer - (60 * m);
          timeToDisplay = m.toString() + ":" + s.toString();
          timeForTimer = timeForTimer -1;
        }else{
          var h = timeForTimer ~/ 3600;
          var t = timeForTimer - (3600 * h);
          var m = t ~/ 60;
          var s = t - (60 * m);
          timeToDisplay =
              h.toString() + ":" + m.toString() + ":" + s.toString();
          timeForTimer = timeForTimer - 1;
        }if (timeForTimer < 0 ) {
          Alert(context: context,
              title: "Food Delayed",
              style: AlertStyle(
                titleStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 30,
                ),
                isButtonVisible: false,
                isCloseButton: true,
              ),
              type: AlertType.warning,
          ).show();
        }
      });
    });
  }
 void stop(){
setState(() {
  started = true;
  stopped = true;
  checkTimer = false;
});
 }


  Widget timer(){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 6, child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget>[
                  Padding(padding: EdgeInsets.only
                    (bottom: 10.0),
                    child: Text(
                      "Hours",  style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800
                    ),
                    ),
                  ),
                 NumberPicker(minValue: 0,
                     maxValue: 23,
                     value: hour,
                     itemWidth: 90,
                     onChanged: (val){
                   setState(() {
                     hour = val;
                   });
                     },
                 ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget>[
                  Padding(padding: EdgeInsets.only
                    (bottom: 10.0),
                    child: Text(
                        "Minutes",  style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700
                    ),
                    ),
                  ),
                  NumberPicker(minValue: 0,
                    maxValue: 60,
                    value: min,
                    itemWidth: 90,
                    onChanged: (val){
                      setState(() {
                        min = val;
                      });
                    },
                  ),

                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget>[
                  Padding(padding: EdgeInsets.only
                    (bottom: 10.0),
                    child: Text(
                        "Seconds",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                  NumberPicker(minValue: 0,
                    maxValue: 60,
                    value: sec,
                    itemWidth: 90,
                    onChanged: (val){
                      setState(() {
                       sec = val;
                      });
                    },
                  ),
                ],
              )
            ],
          )),
          Expanded(
            flex: 1,
            child: Text(
              timeToDisplay,
              style: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          Expanded(
            flex: 3, child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(onPressed: started ? start : null,
              padding: EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 10.0,
              ),
                color: Colors.green,
                child: Text(
                  "Start",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)
                ),
              ),
              RaisedButton(onPressed: stopped ? null : stop,
              padding: EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 10.0,
              ),
                color: Colors.red,
                child: Text(
                  "Stop",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)
              ),
              ),
            ],
            
          )
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Time Projesct"),
        centerTitle: true,
        bottom: TabBar(
          tabs:<Widget>[
            Text("Timer"),
            Text("History"),
          ],
          labelPadding: EdgeInsets.only(
            bottom: 10.0,
          ),
          labelStyle: TextStyle(
            fontSize: 18.0,
          ),
          unselectedLabelColor: Colors.white60,
          controller: tb,
        ),
      ),
      body: TabBarView(
        children: <Widget>[
          timer(),
          Text('History')

        ],
        controller: tb,
      ),
    );
  }
}

