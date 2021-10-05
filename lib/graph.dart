import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_plot/flutter_plot.dart';
import 'package:numanal_lab2/math.dart';

class GraphScreen extends StatefulWidget {
  GraphScreen({
    Key? key,
    required List<Point> interpolationPoints,
    required this.pointsToFind,
  })  : interpolation = Interpolation(interpolationPoints),
        super(key: key) {
    for (var pointX in pointsToFind) {
      foundPoints.add(interpolation.findOrdinateFor(pointX));
    }

    highlightPoints.addAll(foundPoints);
    highlightPoints.addAll(interpolation.points);

    num minX = highlightPoints[0].x;
    num maxX = highlightPoints[0].x;

    for (var i = 1; i < highlightPoints.length; i++) {
      if (highlightPoints[i].x < minX) {
        minX = highlightPoints[i].x;
      } else if (highlightPoints[i].x > maxX) {
        maxX = highlightPoints[i].x;
      }
    }

    minX = (minX - 1).ceil();
    maxX = (maxX + 1).ceil();

    step = (maxX - minX) / 500;

    for (var x = minX; x < maxX; x = x + step) {
      x = (x * 1000).floor() / 1000;
      final res = interpolation.findOrdinateFor(x);
      graphingPoints.add(res);

      if (x == minX) {
        highlightPoints.add(res);
      }
    }

    final maxPoint = interpolation.findOrdinateFor(maxX);

    highlightPoints.add(maxPoint);
    graphingPoints.add(maxPoint);

    highlightPoints.add(graphingPoints.last);
  }

  final Interpolation interpolation;
  final List<num> pointsToFind;
  final List<Point> foundPoints = [];
  final List<Point> highlightPoints = [];
  final List<Point> graphingPoints = [];
  late final num step;

  @override
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graph'),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Stack(
            children: [
              Plot(
                height: 500.0,
                data: widget.graphingPoints,
                gridSize: Offset(
                    widget.step.toDouble() * 200, widget.step.toDouble() * 200),
                style: PlotStyle(
                  pointRadius: 3.0,
                  outlineRadius: 1.0,
                  primary: Colors.transparent,
                  secondary: Colors.transparent,
                  textStyle: const TextStyle(
                    color: Colors.transparent,
                  ),
                  trace: true,
                  traceStokeWidth: 1.0,
                  traceColor: Colors.blueGrey,
                ),
                padding: const EdgeInsets.fromLTRB(40.0, 12.0, 12.0, 40.0),
              ),
              Plot(
                height: 500.0,
                data: widget.highlightPoints,
                gridSize: Offset(
                    widget.step.toDouble() * 200, widget.step.toDouble() * 200),
                style: PlotStyle(
                  pointRadius: 3.0,
                  outlineRadius: 1.0,
                  primary: Colors.white,
                  secondary: Colors.orange,
                  textStyle: const TextStyle(
                    fontSize: 8.0,
                    color: Colors.blueGrey,
                  ),
                  axis: Colors.blueGrey[600],
                  gridline: Colors.blueGrey[100],
                  showCoordinates: true,
                ),
                padding: const EdgeInsets.fromLTRB(40.0, 12.0, 12.0, 40.0),
                xTitle: 'x',
                yTitle: 'y',
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Text('Found points'),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Table(
              border: const TableBorder(
                  horizontalInside: BorderSide(
                width: 1,
              )),
              children: [
                const TableRow(children: [
                  TableCell(child: Text('X')),
                  TableCell(child: Text('Y'))
                ]),
                ...widget.foundPoints.map<TableRow>((e) => TableRow(children: [
                      TableCell(
                        child: Text(e.x.toString()),
                      ),
                      TableCell(
                        child: Text(e.y.toString()),
                      )
                    ])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
