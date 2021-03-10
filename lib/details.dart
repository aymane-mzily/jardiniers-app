import 'package:flutter/material.dart';
import './models/gardener.dart';
import './utils/url_launcher.dart';
import './utils/constants.dart';

class Details extends StatelessWidget {

  final Gardener gardener;

  Details({this.gardener});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(gardener.fullName()),
        ),
        body: new ListView(
            children: <Widget>[
              Hero(
                tag: "avatar_" + gardener.fullName(),
                child: new Image.network(Uri.http(baseApiURL, imagesPath+'/'+gardener.image).toString()),
              ),
              GestureDetector(
                  onTap: () {
                    URLLauncher().launchURL('tel:${gardener.phoneNumber}');
                  },
                  child: new Container(
                    padding: const EdgeInsets.all(32.0),
                    child: new Row(
                      children: [
                        // First child in the Row for the name and the
                        new Expanded(
                          // Name and Address are in the same column
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Code to create the view for name.
                              new Container(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: new Text(
                                  "Nom et prénom: " + gardener.fullName(),
                                  style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              new Text(
                                "Prix: " + gardener.price.toString() + " MAD",
                                style: new TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Code to create the view for address.
                              new Text(
                                gardener.notes,
                                style: new TextStyle(
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Icon to indicate the phone number.
                        new Icon(
                          Icons.phone,
                          color: Colors.red[500],
                        ),
                        new Text('${gardener.phoneNumber}'),
                      ],
                    ),
                  )
              ),
            ]
        )
    );
  }
}