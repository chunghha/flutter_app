import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info/package_info.dart';

import 'package:flutter_app/service/fetch.dart';
import 'package:flutter_app/model/country.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Future List Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final formatter = NumberFormat("#,###");

  @override
  Widget build(BuildContext context) {
    var futureBuilder = FutureBuilder(
      future: fetchCountries(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return _getLoadingSpinner();
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else
              return createListView(context, snapshot);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Countries", style: GoogleFonts.lobster()),
      ),
      body: futureBuilder,
      drawer: Drawer(
        elevation: 8.0,
        child: Container(
          color: Color.fromRGBO(250, 250, 250, 0.05),
          child: ListView(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            children: <Widget>[
              Container(
                height: 120.0,
                child: DrawerHeader(
                    child: Text(
                      'Countries',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.brown[700]),
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Color.fromRGBO(235, 235, 235, 0.1),
                          offset: Offset(2.0, 8.0),
                          blurRadius: 8.0,
                        ),
                      ],
                      color: Color.fromRGBO(150, 150, 150, 0.15),
                    ),
                    margin: EdgeInsets.only(bottom: 10.0),
                    padding: EdgeInsets.only(top: 10.0)),
              ),
              ListTile(
                title: FlatButton.icon(
                  color: Colors.grey[300],
                  icon: Icon(Icons.home, size: 18.0),
                  label: Text('HOME'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              ListTile(
                title: FlatButton.icon(
                  color: Colors.grey[300],
                  icon: Icon(Icons.help, size: 18.0),
                  label: Text('ABOUT'),
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

    return ListView.builder(
        itemCount: countries.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              child: Card(
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
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SvgPicture.network(
                                    countries[index]
                                        .flag
                                        .replaceAll('https', 'http'),
                                    height: 70.0,
                                    width: 90.0,
                                    placeholderBuilder:
                                        (BuildContext context) => Container(
                                            padding: EdgeInsets.all(20.0),
                                            child: CircularProgressIndicator()),
                                  ),
                                ]),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.all(2.0),
                                    width: 240.0,
                                    child: Text(
                                      countries[index].name,
                                      style: GoogleFonts.montserrat(
                                          textStyle: _titleTextStyle()),
                                    ),
                                  ),
                                  Text(
                                    countries[index].capital,
                                    style: GoogleFonts.poppins(
                                        textStyle:
                                            _itemTextStyle(Colors.indigo[700])),
                                  ),
                                  Text(
                                    countries[index].subregion,
                                    style: GoogleFonts.rubik(
                                        textStyle:
                                            _itemTextStyle(Colors.brown[700])),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        formatter.format(
                                            countries[index].population),
                                        style: GoogleFonts.poppins(
                                          textStyle: _itemTextStyle(
                                              _getColorPerPopulation(
                                                  countries[index].population)),
                                        ),
                                      ),
                                      Icon(Icons.nature_people,
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
    return TextStyle(
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
        Opacity(
          opacity: 0.3,
          child: ModalBarrier(dismissible: false, color: Colors.lightGreen),
        ),
        Center(
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }

  _showDialog() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // For Web
    // var _version = packageInfo.version;
    var _version = '1.0.0+1';
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(
            "Flutter App ($_version)",
            style: _titleTextStyle(),
            textAlign: TextAlign.center,
          ),
          content: Wrap(
            children: <Widget>[
              Text("Countries from REST service"),
              FlutterLogo(
                size: 20.0,
              ),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("CLOSE"),
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
