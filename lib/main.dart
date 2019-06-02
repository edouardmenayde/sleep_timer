import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'setup.dart';

void main() {
  setupMusicFiles();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep timer',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF1db954),
        accentColor: Color(0xFF191414),
//        fontFamily: 'Montserrat',
//
//        // Define the default TextTheme. Use this to specify the default
//        // text styling for headlines, titles, bodies of text, and more.
//        textTheme: TextTheme(
//          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
//          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
//          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
//        ),
      ),
      home: MyHomePage(title: 'Sleep timer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = const MethodChannel('sleep_timer.edouardmenayde.fr/audio');

  FlutterSound flutterSound = new FlutterSound();
  final aMinute = Duration(milliseconds: 1 * 1000);

  int remainingTime = 1;
  bool timerActive = false;
  Future<void> timer;

  void stopSound() async {
    try {
      await platform.invokeMethod('getAudioFocus');
    } on PlatformException catch (e) {
      print(e);
    }
    try {
      await flutterSound.stopPlayer();
    }
    catch(e) {

    }
    String path = await flutterSound.startPlayer(await silencePath());
    await flutterSound.setVolume(0.0);
    print('startPlayer: $path');
    await flutterSound.stopPlayer();
  }

  void setRemainingTime(value) {
    setState(() {
      if (remainingTime + value >= 0) {
        remainingTime += value;
      }
    });
  }

  void updateTimer() {
    setState(() {
      if (timerActive) {
        remainingTime -= 1;
        if (remainingTime > 0) {
          timer = Future.delayed(aMinute, updateTimer);
        }
        else {
          timerActive = false;
          remainingTime = 1;
          stopSound();
        }
      }
    });
  }

  void toggleTimerStatus() {
    setState(() {
      timerActive = !timerActive;
      if (timerActive) {
        timer = Future.delayed(aMinute, updateTimer);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Row(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                setRemainingTime(-5);
              },
              child: const Text('- 5 min', style: TextStyle(fontSize: 25.0)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '$remainingTime min',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
              ),
            ),
            RaisedButton(
              onPressed: () {
                setRemainingTime(5);
              },
              child: const Text('+ 5 min', style: TextStyle(fontSize: 25.0)),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleTimerStatus,
        tooltip: 'Increment',
        child: timerActive ? Icon(Icons.pause) : Icon(Icons.play_arrow),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
