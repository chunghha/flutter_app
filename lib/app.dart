import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'service/fetch.dart';
import 'model/country.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Future List Demo',
      theme: new ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final formatter = new NumberFormat("#,###");

  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
      future: fetchCountries(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return createListView(context, snapshot);
        }
      },
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Countries"),
      ),
      body: futureBuilder,
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Country> countries = snapshot.data;
    const _itemPadding = EdgeInsets.only(left: 4.0);

    return new ListView.builder(
        itemCount: countries.length,
        itemBuilder: (BuildContext context, int index) {
          return new GestureDetector(
              child: new Card(
                  elevation: 1.7,
                  child: new Padding(
                    padding: new EdgeInsets.all(10.0),
                    child: new Column(children: [
                      new Row(children: <Widget>[
                        new Padding(
                          padding: _itemPadding,
                          child: new Text(
                            countries[index].flag,
                            style: _itemTextStyle(),
                          ),
                        ),
                      ]),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                        new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                countries[index].name,
                                style: _titleTextStyle(),
                              ),
                              new Text(
                                countries[index].capital,
                                style: _itemTextStyle(),
                              ),
                            ]),
                        new Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              new Text(
                                countries[index].subregion,
                                style: _itemTextStyle(),
                              ),
                              new Text(
                                formatter.format(countries[index].population),
                                style: _itemTextStyle(),
                              ),
                            ])
                      ]),
                    ]),
                  )));
        });
  }

  _itemTextStyle() {
    return TextStyle(
      fontWeight: FontWeight.w500,
      color: Colors.grey[500],
    );
  }

  _titleTextStyle() {
    return new TextStyle(
      fontWeight: FontWeight.w700,
      color: Colors.grey[700],
    );
  }
}
