import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_svg/flutter_svg.dart';

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
                  color: Colors.brown[50],
                  elevation: 1.7,
                  child: new Padding(
                    padding: new EdgeInsets.all(10.0),
                    child: new Column(children: [
                      new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new SvgPicture.network(
                                    countries[index]
                                        .flag
                                        .replaceAll('https', 'http'),
                                    height: 45.0,
                                    width: 60.0,
                                    placeholderBuilder:
                                        (BuildContext context) => new Container(
                                            padding: const EdgeInsets.all(60.0),
                                            child:
                                                const CircularProgressIndicator()),
                                  ),
                                ]),
                            new Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Text(
                                    countries[index].name,
                                    style: _titleTextStyle(),
                                  ),
                                  new Text(
                                    countries[index].capital,
                                    style: _itemTextStyle(Colors.indigo[700]),
                                  ),
                                ]),
                            new Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  new Text(
                                    countries[index].subregion,
                                    style: _itemTextStyle(Colors.brown[700]),
                                  ),
                                  new Row(
                                    children: <Widget>[
                                      new Text(
                                        formatter.format(
                                            countries[index].population),
                                        style: _itemTextStyle(
                                            _getColorPerPopulation(
                                                countries[index].population)),
                                      ),
                                      new Icon(Icons.nature_people,
                                          size: 16.0,
                                          color: _getColorPerPopulation(
                                              countries[index].population)),
                                    ],
                                  )
                                ])
                          ]),
                    ]),
                  )));
        });
  }

  _itemTextStyle([Color color = Colors.black]) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  _titleTextStyle() {
    return new TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w700,
      color: Colors.teal[700],
    );
  }

  _getColorPerPopulation(int population) {
    Color color = Colors.green[700];

    if (population > 100000000) {
      color = Colors.red[700];
    } else {
      if (population > 10000000) {
        color = Colors.orange[700];
      } else {
        if (population > 1000000) {
          color = Colors.blue[700];
        }
      }
    }

    return color;
  }
}
