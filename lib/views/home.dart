import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

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
      appBar: AppBar(title: Center(child: Text("Our Al-Qur'an"))),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshoot) {
            if (snapshoot.hasData) {
              return ListView.builder(
                  itemCount: snapshoot.data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(8.0),
                      height: 150,
                      child: GestureDetector(
                        onTap: () {
                          Get.bottomSheet(
                            ClipRRect(
                              clipBehavior: Clip.antiAlias,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                              ),
                              child: Container(
                                color: Colors.white,
                                padding: EdgeInsets.only(
                                  top: 40,
                                  right: 20,
                                  left: 20,
                                  bottom: 10
                                ),
                                child:
                                    // Icon(Icons.arrow_drop_down_sharp),
                                    ListView.builder(
                                      itemCount: 1,
                                      itemBuilder: (BuildContext context, int i) {
                                        return Container(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              ElevatedButton(onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Detail(surat: snapshoot.data[index])));
                                              }, child: Text("Baca")),

                                              Html(data: snapshoot.data[index]['keterangan'])
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                              ),
                            ),
                          );

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             Detail(surat: snapshoot.data[index])));
                        },
                        child: Card(
                          elevation: 3,
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      snapshoot.data[index]['nama'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(snapshoot.data[index]['asma'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20)),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(snapshoot.data[index]['arti']),
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
              return Center(child: Text('Data belum ditemukan'));
            }
          }),
    );
  }
}
// showModalBottomSheet(
//                               backgroundColor: Colors.transparent,
//                               context: context,
//                               builder: (context) {
//                                 return ClipRRect(
//                                   clipBehavior: Clip.antiAlias,
//                                   borderRadius: BorderRadius.only(
//                                     topRight: Radius.circular(20),
//                                     topLeft: Radius.circular(20),
//                                   ),
//                                   child: Container(
//                                       height: 250,
//                                       color: Colors.grey[400],
//                                       child: Container(
//                                         padding: EdgeInsets.all(20),
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceAround,
//                                           children: [
//                                             Text(snapshoot.data[index]
//                                                 ['keterangan'])
//                                           ],
//                                         ),
//                                       )),
//                                 );
//                               });
