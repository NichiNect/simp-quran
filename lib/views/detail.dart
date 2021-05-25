import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';

class Detail extends StatelessWidget {
  @override
  final Map surat;
  Detail({@required this.surat});

  Future getDataDetail(int i) async {
    var response = await http.get(Uri.parse(
        "https://api.npoint.io/99c279bb173a6e28359c/surat/" + i.toString()));

    return json.decode(response.body);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(surat['nama'] + " - " + surat['ayat'].toString() + " ayat"),),
        body: Container(
          // padding: EdgeInsets.only(top: 20),
          child: FutureBuilder(
            future: getDataDetail(int.parse(surat['nomor'])),
            builder: (context, res) {
              if (res.hasData) {
                // print(res.data[0]['id']);
                return ListView.builder(
                  itemCount: res.data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(res.data[index]['ar'], style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      new Html(data: res.data[index]['tr'], 
                                        defaultTextStyle: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Artinya : " + res.data[index]['id'] + "(" + res.data[index]['nomor'].toString() + ")",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic
                                    ),
                                  ),
                                  Divider(),
                                ],
                              )
                            ],
                          ),
                        ),
                    );
                  },
                );
              } else {
                return Center(child: Text('Data belum ditemukan'));
              }
            },
          ),
        ));
  }
}
