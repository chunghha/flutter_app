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
            return _getLoadingSpinner();
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
      drawer: new Drawer(
        elevation: 8.0,
        child: Container(
          color: Color.fromRGBO(250, 250, 250, 0.05),
          child: ListView(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            children: <Widget>[
              Container(
                height: 80.0,
                child: DrawerHeader(
                    child: new Text(
                      'Countries',
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.brown[700]),
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      boxShadow: <BoxShadow>[
                        new BoxShadow(
                          color: Color.fromRGBO(235, 235, 235, 0.1),
                          offset: new Offset(2.0, 8.0),
                          blurRadius: 8.0,
                        ),
                      ],
                      color: Color.fromRGBO(150, 150, 150, 0.15),
                    ),
                    margin: EdgeInsets.only(bottom: 10.0),
                    padding: EdgeInsets.only(top: 10.0)),
              ),
              ListTile(
                title: new FlatButton.icon(
                  color: Colors.grey[300],
                  icon: const Icon(Icons.home, size: 18.0),
                  label: const Text('HOME'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              ListTile(
                title: new FlatButton.icon(
                  color: Colors.grey[300],
                  icon: const Icon(Icons.help, size: 18.0),
                  label: const Text('ABOUT'),
                  onPressed: () {
                    _showDialog();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Country> countries = snapshot.data;

    return new ListView.builder(
        itemCount: countries.length,
        itemBuilder: (BuildContext context, int index) {
          return new GestureDetector(
              child: new Card(
                  color: Colors.lightGreen[50],
                  elevation: 2.7,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.zero,
                        bottomLeft: Radius.circular(16.0),
                        bottomRight: Radius.circular(16.0),
                      ),
                      side: BorderSide(
                        color: Colors.lightGreen[200],
                        width: 2.0,
                      )),
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
                                    height: 60.0,
                                    width: 90.0,
                                    placeholderBuilder:
                                        (BuildContext context) => new Container(
                                            padding: const EdgeInsets.all(20.0),
                                            child:
                                                const CircularProgressIndicator()),
                                  ),
                                ]),
                            new Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  new Container(
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.all(2.0),
                                    width: 240.0,
                                    child: new Text(
                                      countries[index].name,
                                      style: _titleTextStyle(),
                                    ),
                                  ),
                                  new Text(
                                    countries[index].capital,
                                    style: _itemTextStyle(Colors.indigo[700]),
                                  ),
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

  _getLoadingSpinner() {
    return Stack(
      children: [
        new Opacity(
          opacity: 0.3,
          child:
              const ModalBarrier(dismissible: false, color: Colors.lightGreen),
        ),
        new Center(
          child: new CircularProgressIndicator(),
        ),
      ],
    );
  }

  _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Flutter App"),
          content: new Text("Countries from REST service"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
