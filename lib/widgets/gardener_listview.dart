import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/gardener.dart';
import '../utils/constants.dart';

class GardenerListView extends StatelessWidget{

  final String jwt;
  void Function(Gardener) itemTapCallback;

  GardenerListView({@required this.jwt, this.itemTapCallback});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Gardener>>(
      future: _fetchGardeners(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Gardener> data = snapshot.data;
          return _gardenersListView(context, data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  ListView _gardenersListView(BuildContext context, List<Gardener> gardeners) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: gardeners.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, Gardener gardener) {
    return Card(
      key: ValueKey(gardener.id),
      elevation: 3.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, .9)),
        child: ListTile(
          contentPadding:
          EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right: new BorderSide(width: 1.0, color: Colors.white24))),
              child: Hero(
                  tag: "avatar_" + gardener.fullName(),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(Uri.http(baseApiURL, imagesPath+'/'+gardener.image).toString()),
                  )
              )
          ),
          title: Text(
            gardener.fullName(),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          subtitle: Row(
            children: <Widget>[
              new Flexible(
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: gardener.notes,
                            style: TextStyle(color: Colors.black, fontSize: 13.0),
                          ),
                          maxLines: 3,
                          softWrap: true,
                        ),
                        Text(
                            "Prix: " + gardener.price.toString() + " MAD",
                            style: new TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                            ),
                        ),
                      ]))
            ],
          ),
          trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0),
          onTap: () {
            if(itemTapCallback!=null) itemTapCallback(gardener);
            /*Navigator.push(
                context, MaterialPageRoute(builder: (context) => new DetailPage(record: record)));*/
          },
        ),
      ),
    );
  }

  Future<List<Gardener>> _fetchGardeners() async {
    final response = await http.get(
      Uri.http(baseApiURL, availiableGardeners),
        headers: <String, String>{
          'x-access-token': this.jwt,
        },
      );

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((gardener) => new Gardener.fromJson(gardener)).toList();
      }else{
        throw Exception('Failed');
      }
  }

}