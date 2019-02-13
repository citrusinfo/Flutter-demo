import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';

import '../../Screens/Record/audio_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {

    void bottomSheet() {
      showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.music_note),
                  title: new Text('Audio'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/record');
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.videocam),
                  title: new Text('Video'),
                  onTap: () => {},
                ),
                new ListTile(
                  leading: new Icon(Icons.cancel),
                  title: new Text('Cancel'),
                  onTap: () {Navigator.pop(context);},
                ),
              ],
            );
          });
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("My Recordings"),
          actions: <Widget>[
            IconButton(
              // action button
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: getFiles(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == null) {
                return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(Icons.report_problem),
                      title: Text("No recordings yet"),
                    );
                  },
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    print(basename(File(snapshot.data[index]).path));
                    return ListTile(
                      leading: basename(File(snapshot.data[index]).path)
                          .contains("mp4")
                          ? Icon(Icons.audiotrack)
                          : Icon(Icons.videocam),
                      title: Text(basename(File(snapshot.data[index]).path)),
                      onTap: (){
                        String uri = File(snapshot.data[index]).path.toString();
                        Navigator.push(context, MaterialPageRoute(builder:
                            (BuildContext context) => PlayAudio(path: uri)));
                      },
                    );
                  },
                );
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: bottomSheet,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Future getFiles() async {
    var root = await getExternalStorageDirectory();
    print("Path==="+root.path);
    List<String> files =
    await FileManager(root: root.path + "/flutterdemo").filesTree();
    return files.reversed.toList(); // For to show latest files first
  }

}
