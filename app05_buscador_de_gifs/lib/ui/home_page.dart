import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

import 'gif_page.dart';


const _urlTrending = "https://api.giphy.com/v1/gifs/trending?api_key=wusbFwUExpkztfjeMr3QRimPUc4kd1J9&limit=20&rating=G";
//const _urlSearch = ;
const _urlIcon = "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif";


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _search;
  int _offset = 25;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null || _search.isEmpty) {
      response = await http.get(_urlTrending);
    } else {
      response = await http.get("https://api.giphy.com/v1/gifs/search?api_key=wusbFwUExpkztfjeMr3QRimPUc4kd1J9&limit=19&offset=$_offset&rating=G&lang=en&q=$_search");
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    
    _getGifs().then((map){
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(_urlIcon, height: 25,),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Search",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()
              ),
              style: TextStyle(color: Colors.white, fontSize: 18),
              onSubmitted: (text){
                setState(() {
                  _search = text;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if(snapshot.hasError) return Container();
                    else return _createGifTable(context, snapshot);
                }
              }
            ),
          )
        ],
      ),
    );
  }

  int _getCount(List data){
    if(_search == null){
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10
        ),
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context, index){
          if(_search == null || index < snapshot.data["data"].length)
            return GestureDetector(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                height: 300,
                fit:  BoxFit.cover,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context){
                      return GifPage(snapshot.data["data"][index]);
                    }));
              },
              onLongPress: (){
                Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
              },
          );
          else
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add, color: Colors.white, size: 70,),
                    Text("Carregar mais..", style: TextStyle(color: Colors.white, fontSize: 22))
                  ],
                ),
                onTap: () {
                  setState(() {
                    _offset += 25;
                  });
                },
              ),
            );
        });
  }
}
