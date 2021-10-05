import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numanal_lab2/graph.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interpolation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PointsInput(),
    );
  }
}

class TextEditingControllerPair {
  final TextEditingController x;
  final TextEditingController y;

  TextEditingControllerPair(this.x, this.y);
}

class PointsInput extends StatefulWidget {
  const PointsInput({Key? key}) : super(key: key);

  @override
  State<PointsInput> createState() => _PointsInputState();
}

class _PointsInputState extends State<PointsInput> {
  List<TextEditingControllerPair> controllers = [];
  List<TextEditingController> controllersToFind = [];

  void addNewPoint(Point defaultValue) {
    setState(() {
      final c = TextEditingControllerPair(
        TextEditingController(
          text: defaultValue.x.toString(),
        ),
        TextEditingController(
          text: defaultValue.y.toString(),
        ),
      );

      controllers.add(c);
    });
  }

  void addNewPointToFind(num defaultValue) {
    setState(() {
      controllersToFind.add(
        TextEditingController(
          text: defaultValue.toString(),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();

    addNewPoint(const Point(-2, -22));
    addNewPoint(const Point(-1, -10));
    addNewPoint(const Point(2, -10));
    addNewPoint(const Point(3, -2));

    addNewPointToFind(-1.5);
    addNewPointToFind(-0.5);
    addNewPointToFind(1.5);
    addNewPointToFind(2.5);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> inputFields = [];

    for (var i = 0; i < controllers.length; i++) {
      inputFields.add(
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: TextFormField(
                  controller: controllers[i].x,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "x",
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: TextFormField(
                  controller: controllers[i].y,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "y",
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    final List<Widget> inputFieldsToFind = [];

    for (var i = 0; i < controllersToFind.length; i++) {
      inputFieldsToFind.add(
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: TextFormField(
                  controller: controllersToFind[i],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "x",
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Interpolation"),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text("Interpolation Points"),
          ),
          Card(
            child: Column(
              children: inputFields,
            ),
          ),
          Center(
            child: ElevatedButton(
              child: const Text('Add a point'),
              onPressed: () => addNewPoint(const Point(0, 0)),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text("Points to Find"),
          ),
          Card(
            child: Column(
              children: inputFieldsToFind,
            ),
          ),
          Center(
            child: ElevatedButton(
              child: const Text('Add a point'),
              onPressed: () => addNewPointToFind(0),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.auto_graph),
        onPressed: () => {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GraphScreen(
                interpolationPoints: controllers
                    .map(
                      (e) => Point(num.tryParse(e.x.text) ?? 0,
                          num.tryParse(e.y.text) ?? 0),
                    )
                    .toList(),
                pointsToFind: controllersToFind
                    .map(
                      (e) => num.tryParse(e.text) ?? 0,
                    )
                    .toList(),
              ),
            ),
          )
        },
      ),
    );
  }
}
