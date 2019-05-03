library splashscreen;

import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final int seconds;
  final Text title;
  final Color backgroundColor;
  final dynamic navigateAfterSeconds;
  final dynamic onClick;
  final ImageProvider imageBackground;

  SplashScreen({
    @required this.seconds,
    this.onClick,
    this.navigateAfterSeconds,
    this.title = const Text(''),
    this.backgroundColor = Colors.white,
    this.imageBackground,
  });

  @override
  _SplashScreenState createState() => _SplashScreenState(lastSeconds: seconds);
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _timer;
  int lastSeconds;

  _SplashScreenState({this.lastSeconds});

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        lastSeconds -= 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new InkWell(
        onTap: widget.onClick,
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: new BoxDecoration(
                image: widget.imageBackground == null
                    ? null
                    : new DecorationImage(
                  fit: BoxFit.cover,
                  image: widget.imageBackground,
                ),
                color: widget.backgroundColor,
              ),
            ),
            Positioned(
              top: 40,
              right: 40,
              width: 40,
              height: 40,
              child: Container(
                child: buildTimeCounter(lastSeconds),
                alignment: Alignment.center,
                decoration: new BoxDecoration(
                  color: Color(0x66000000),
                  shape: BoxShape.circle,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  buildTimeCounter(int second) {
    if (second > 0) {
      return Text('$second', style: TextStyle(fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white),);
    } else {
      return GestureDetector(
        child: Icon(Icons.close, size: 30.0, color: Colors.white,), onTap: () {
        if (widget.navigateAfterSeconds is String) {
          // It's fairly safe to assume this is using the in-built material
          // named route component
          Navigator.of(context).pushReplacementNamed(
              widget.navigateAfterSeconds);
        } else if (widget.navigateAfterSeconds is Widget) {
          Navigator.of(context).pushReplacement(new MaterialPageRoute(
              builder: (BuildContext context) =>
              widget
                  .navigateAfterSeconds));
        } else if (widget.navigateAfterSeconds is Function) {
          Navigator.of(context).pushReplacement(new MaterialPageRoute(
              builder: (BuildContext context) =>
                  widget
                      .navigateAfterSeconds()));
        } else {
          throw new ArgumentError(
              'widget.navigateAfterSeconds must either be a String or Widget'
          );
        }
      }
        ,);
    }
  }
}
