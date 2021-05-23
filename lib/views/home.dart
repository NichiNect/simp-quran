import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simp_quran/views/detail.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String url = "https://api.npoint.io/99c279bb173a6e28359c/data";
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;

  Future getData() async {
    var response = await http.get(Uri.parse(url));
    print(response);
    return json.decode(response.body);
  }

  startAudio(url) {
    audioPlayer.play(url);
  }

  stopAudio() {
    audioPlayer.stop();
  }

  Future playSound(url) async {
    if (isPlaying == true) {
      stopAudio();
    } else {
      isPlaying = true;
      await startAudio(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Home Page"))),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshoot) {
            if (snapshoot.hasData) {
              return ListView.builder(
                  itemCount: snapshoot.data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(8.0),
                      height: 130,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Detail(surat: snapshoot.data[index])));
                        },
                        child: Card(
                          elevation: 3,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      snapshoot.data[index]['nama'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(snapshoot.data[index]['arti']),
                                    Row(
                                      children: [
                                        Text(snapshoot.data[index]['asma']),
                                        TextButton(
                                            style: ButtonStyle(
                                                padding:
                                                    MaterialStateProperty.all(
                                                        EdgeInsets.all(0))),
                                            onPressed: () => playSound(
                                                snapshoot.data[index]['audio']),
                                            child:
                                                Icon(Icons.play_arrow_outlined))
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return Center(child: Text('Data tidak ditemukan'));
            }
          }),
    );
  }
}
