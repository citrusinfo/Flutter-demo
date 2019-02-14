import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'dart:io';
import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/date_symbol_data_local.dart';


class RecordAudio extends StatefulWidget {
  @override
  _RecordAudioState createState() => new _RecordAudioState();
}

class _RecordAudioState extends State<RecordAudio> {
  bool _isRecording = false;
  BuildContext _context;
  StreamSubscription _recorderSubscription;
  StreamSubscription _dbPeakSubscription;
  FlutterSound flutterSound;
  String _recorderTxt = '00:00:00';
  double _dbLevel;
  double slider_current_position = 0.0;
  double max_duration = 1.0;

  @override
  void initState() {
    super.initState();
    flutterSound = new FlutterSound();
    flutterSound.setSubscriptionDuration(0.01);
    flutterSound.setDbPeakLevelUpdate(0.8);
    flutterSound.setDbLevelEnabled(true);
  }

  void startRecorder() async {
    try {
      var root = await getApplicationDocumentsDirectory();
      int id = new DateTime.now().millisecondsSinceEpoch;
      var myDir = new Directory(root.path + '/flutterdemo/Recordings');
      try{
        if (!await myDir.exists()) {
          await myDir.create(recursive: true);
        }
      }catch (err){
        flutterSound.startRecorder(null);
        flutterSound.stopRecorder();
      }
      String uri = root.path +
          "/flutterdemo/Recordings/flutterdemo_audio" +
          id.toString() +
          ".mp4";
      print(uri);
      String path = await flutterSound.startRecorder(uri);
      print(': $path');
      _recorderSubscription = flutterSound.onRecorderStateChanged.listen((e) {
        initializeDateFormatting();
        DateTime date =
            new DateTime.fromMillisecondsSinceEpoch(e.currentPosition.toInt(),isUtc: true);
        String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);

        this.setState(() {
          this._recorderTxt = txt.substring(0, 8);
        });
      });
      _dbPeakSubscription =
          flutterSound.onRecorderDbPeakChanged.listen((value) {
        print("got update -> $value");
        setState(() {
          this._dbLevel = value;
        });
      });

      this.setState(() {
        this._isRecording = true;
      });
    } catch (err) {
      print('startRecorder error: $err');
    }
  }

  void stopRecorder() async {
    try {
      String result = await flutterSound.stopRecorder();
      print('stopRecorder: $result');

      if (_recorderSubscription != null) {
        _recorderSubscription.cancel();
        _recorderSubscription = null;
      }
      if (_dbPeakSubscription != null) {
        _dbPeakSubscription.cancel();
        _dbPeakSubscription = null;
      }

      this.setState(() {
        this._isRecording = false;
      });
      Navigator.pushReplacementNamed(_context, '/home');
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Record Audio'),
        ),
        body: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 24.0, bottom: 16.0),
                  child: Text(
                    this._recorderTxt,
                    style: TextStyle(
                      fontSize: 48.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                _isRecording
                    ? LinearProgressIndicator(
                        value: 100.0 / 120.0 * (this._dbLevel ?? 1) / 100,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        backgroundColor: Colors.red,
                      )
                    : Container()
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 56.0,
                  height: 56.0,
                  child: ClipOval(
                    child: FlatButton(
                      onPressed: () {
                        if (!this._isRecording) {
                          return this.startRecorder();
                        }
                        this.stopRecorder();
                      },
                      padding: EdgeInsets.all(8.0),
                      child: new Icon(
                        this._isRecording ? Icons.stop : Icons.mic,
                        size: 50.0,
                      ),
                    ),
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ],
        ),
      ),
    );
  }
}
