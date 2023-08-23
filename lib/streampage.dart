import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:streamtest/models/stream_data.dart';

class StreamPage extends StatefulWidget {
  const StreamPage({Key? key}) : super(key: key);

  @override
  State<StreamPage> createState() => _StreamPageState();
}

class _StreamPageState extends State<StreamPage> {
  StreamController<StreamData> _streamData = StreamController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamData.close();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(Duration(seconds: 3), (timer) {
      getCrypto();
    });
  }

  Future<void> getCrypto() async {
    var url = Uri.parse("https://data.binance.com/api/v3/ticker/24hr");
    final response = await http.get(url);
    final dataBody = json.decode(response.body).first;

    StreamData dataModel = new StreamData.fromJson(dataBody);
    _streamData.sink.add(dataModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stream Page")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: StreamBuilder<StreamData>(
              stream: _streamData.stream,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Text("Please wait...");
                    } else {
                      return BuildCoin(snapshot.data!);
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget BuildCoin(StreamData dataModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dataModel.name,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            '\$ ' + dataModel.price,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
