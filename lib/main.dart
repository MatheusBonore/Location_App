import 'package:flutter/material.dart';
import 'package:location/location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Location'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

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
  Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  bool _isListenLocation = false;
  bool _isGetLocation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                _serviceEnabled = await location.serviceEnabled();
                if (!_serviceEnabled) {
                  _serviceEnabled = await location.requestService();
                  if (_serviceEnabled) return;
                }
                _permissionGranted = await location.requestPermission();
                if (_permissionGranted == PermissionStatus.denied) {
                  _permissionGranted = await location.requestPermission();
                  if (_permissionGranted != PermissionStatus.granted) return;
                }

                _locationData = await location.getLocation();
                setState(() {
                  _isGetLocation = true;
                });
              },
              child: Text('Get Location'),
            ),
            _isGetLocation
                ? Text(
                    'Location: ${_locationData.latitude}/${_locationData.longitude}')
                : Container(),
            ElevatedButton(
              onPressed: () async {
                _serviceEnabled = await location.serviceEnabled();
                if (!_serviceEnabled) {
                  _serviceEnabled = await location.requestService();
                  if (_serviceEnabled) return;
                }
                _permissionGranted = await location.requestPermission();
                if (_permissionGranted == PermissionStatus.denied) {
                  _permissionGranted = await location.requestPermission();
                  if (_permissionGranted != PermissionStatus.granted) return;
                }

                setState(() {
                  _isListenLocation = true;
                });
              },
              child: Text('Listen Location'),
            ),
            StreamBuilder(
                stream: location.onLocationChanged,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.waiting) {
                    var data = snapshot.data as LocationData;
                    return _isListenLocation
                        ? Text(
                            'Location always change: \n ${data.latitude}/${data.longitude}')
                        : Container();
                  } else
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                }),
          ],
        ),
      ),
    );
  }
}
