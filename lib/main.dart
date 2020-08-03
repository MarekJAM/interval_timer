import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  Timer _timer;
  bool _isPaused = true;
  bool _isStarted = false;
  bool _isResting = false;
  Duration _exerciseTime = new Duration(seconds: 30);
  Duration _restTime = new Duration(seconds: 10);
  Duration _timeLeft = new Duration(seconds: 0);
  AudioPlayer _player;
  final String _startExerciseAudio = "assets/start_exercise.mp3";
  final String _endExerciseAudio = "assets/end_exercise.mp3";

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.setAsset(_endExerciseAudio);
  }

  void startTimer() {
    if (!_isStarted) _timeLeft = _exerciseTime;
    _isStarted = true;
    _isPaused = false;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_timeLeft == Duration(seconds: 4)) {
            _player.play();
            _timeLeft = _timeLeft - Duration(seconds: 1);
          } else if (_timeLeft < Duration(seconds: 1)) {
            _isResting ? _timeLeft = _exerciseTime : _timeLeft = _restTime;
            _isResting = !_isResting;
            _player.stop();
            _player
                .setAsset(_isResting ? _startExerciseAudio : _endExerciseAudio);
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
    _player.stop();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  format(Duration d) => d.toString().substring(2, 7);

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
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
                Container(
                  height: deviceSize.height * 0.1,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                              color: _isResting ? Colors.green : Colors.red),
                          width: deviceSize.width *
                              _timeLeft.inSeconds /
                              (_isResting ? _restTime : _exerciseTime)
                                  .inSeconds,
                        ),
                      ),
                      Center(
                          child: Text(
                        _isResting ? "Rest" : "Exercise!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ))
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Text(
                  "${format(_timeLeft)}",
                  style: TextStyle(fontSize: 30),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        _isPaused ? startTimer() : stopTimer();
                        setState(() {});
                      },
                      child: Text(
                        _isPaused ? "start" : "stop",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                    ),
                    RaisedButton(
                      onPressed: () {
                        stopTimer();
                        setState(() {
                          _timeLeft = _exerciseTime;
                          _isResting = false;
                          _isStarted = false;
                          _player.stop();
                          _player.setAsset(_endExerciseAudio);
                        });
                      },
                      child: Text(
                        "reset",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
