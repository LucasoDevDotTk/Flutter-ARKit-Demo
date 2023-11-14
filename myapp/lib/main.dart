import 'package:flutter/material.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ARKit Flutter Example - Xcatech'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePage(
            onNavigateToCameraPage: (text) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CameraPage(initialText: text),
                ),
              );
            },
          ),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final Function(String) onNavigateToCameraPage;

  HomePage({required this.onNavigateToCameraPage});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: textController,
            decoration: InputDecoration(labelText: 'Enter Text'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Pass the text to the callback function
              widget.onNavigateToCameraPage(textController.text);
            },
            child: Text('Navigate to Camera Page'),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Copyright © 2023 LucasoDevDotTk. (LUCASODEV.UK.TO). All Rights Reserved.', textAlign: TextAlign.center,),
          SizedBox(height: 16),
          Text(
            'This is a debug application. Do not republish or distribute without proper authorization.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}

class CameraPage extends StatefulWidget {
  final String initialText;

  CameraPage({required this.initialText});

  @override
  _CameraPage createState() => _CameraPage();
}

class _CameraPage extends State<CameraPage> {
  late ARKitController arkitController;

  @override
  void dispose() {
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Camera Page'),
        ),
        body: ARKitSceneView(onARKitViewCreated: onARKitViewCreated),
      );

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;

    final node = ARKitNode(
      geometry: ARKitText(
        text: widget.initialText,
        extrusionDepth: 1,
        materials: [
          ARKitMaterial(
            diffuse: ARKitMaterialProperty.color(Colors.orange),
          ),
        ],
      ),
      position: vector.Vector3(-20, -10, -40),
    );

    node.scale.setValues(0.01, 0.01, 0.01);
    this.arkitController.add(node);
  }
}
