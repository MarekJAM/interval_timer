import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interval Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Timer _timer;
  bool _isPaused;
  Duration _exerciseTime = new Duration(seconds: 30);
  Duration _restTime = new Duration(seconds: 5);
  Duration _timeLeft = new Duration(seconds: 0);

  void startTimer() {
    _timeLeft = _exerciseTime;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_timeLeft < Duration(seconds: 1)) {
            timer.cancel();
          } else {
            _timeLeft = _timeLeft - Duration(seconds: 1);
          }
        },
      ),
    );
  }

  void stopTimer() {
    _timer.cancel();
    _isPaused = true;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  format(Duration d) => d.toString().substring(2, 7);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Interval timer")),
      body: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FloatingActionButton(
                onPressed: () {
                  if (_exerciseTime > Duration(seconds: 0))
                    setState(() {
                      _exerciseTime = _exerciseTime - Duration(seconds: 1);
                    });
                },
                child: Text('-'),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Text('Exercise time: ${format(_exerciseTime)}'),
              ),
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _exerciseTime = _exerciseTime + Duration(seconds: 1);
                  });
                },
                child: Text('+'),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FloatingActionButton(
                onPressed: () {
                  if (_restTime > Duration(seconds: 0))
                    setState(() {
                      _restTime = _restTime - Duration(seconds: 1);
                    });
                },
                child: Text('-'),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Text('Rest time: ${format(_restTime)}'),
              ),
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _restTime = _restTime + Duration(seconds: 1);
                  });
                },
                child: Text('+'),
              ),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("${format(_timeLeft)}", style: TextStyle(fontSize: 30),),
                RaisedButton(
                  onPressed: () {
                    startTimer();
                    _isPaused = false;
                  },
                  child: Text(_isPaused? "start":"stop", style: TextStyle(fontSize: 20),),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
