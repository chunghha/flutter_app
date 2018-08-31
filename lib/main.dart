import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  AnimationController _controller;
  bool _visible = true;

  @override
  initState() {
    super.initState();

    _controller = AnimationController(
      value: 50.0,
      lowerBound: 50.0,
      upperBound: 300.0,
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _controller.forward().orCancel;
  }

  @override
  dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text("Tap the logo"),
            ),
            body: GestureDetector(
                onTap: () {
                  final status = _controller.status;
                  if (status == AnimationStatus.completed) {
                    _controller.reverse().orCancel;
                  } else {
                    _controller.animateTo(
                      300.0,
                      curve: Curves.bounceOut,
                    );
                  }

                  setState(() {
                    _visible = !_visible;
                  });
                },
                child: Center(
                    child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _controller.value * 0.12565,
                      child: Container(
                      child: child,
                      height: _controller.value,
                      width: _controller.value,
                    ));
                  },
                  child: AnimatedOpacity(
                    opacity: _visible ? 1.0 : 0.2,
                    duration: Duration(milliseconds: 1500),
                    child: Container(
                      color: Colors.lightBlue[100],
                      constraints: BoxConstraints.expand(),
                      child: FlutterLogo(),
                    ),
                  ),
                )))));
  }
}
