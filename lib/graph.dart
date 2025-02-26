import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AppColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}

final List<Color> gradientColors = [
  AppColors.contentColorCyan,
  AppColors.contentColorBlue,
];

class GraphView extends StatefulWidget {
  const GraphView({super.key, required this.graphName, required this.title});

  final String graphName;
  final String title;

  static const routeName = '/stream';

  @override
  State<GraphView> createState() => _GraphViewState();
}

class _GraphViewState extends State<GraphView> {
  List<double> feed = [];

  // Stream<double> getRandomValue() async* {
  //   var random = Random(100);
  //   while (true) {
  //     yield double.parse(random.nextDouble().toStringAsFixed(3));
  //     await Future.delayed(const Duration(seconds: 1));
  //   }
  // }

  final channel = WebSocketChannel.connect(
    Uri.parse('ws://192.168.4.1/ws'), // Replace with your ESP32 IP address
  );

  LineChartData feedGraph(List<double> feed) {
    final List<FlSpot> spots = List.generate(
        feed.length, (index) => FlSpot(index.toDouble(), feed[index]));

    int mx = -(1 << 63);
    int mn = (1 << 63) - 1;
    for (var i in feed) {
      mx = max(mx, i.ceil());
      mn = min(mn, i.ceil());
    }

    return graphUI(feed, mn, mx, spots);
  }

  LineChartData graphUI(List<double> feed, int mn, int mx, List<FlSpot> spots) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: const FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: feed.length + 0,
      minY: mn.toDouble(),
      maxY: mx.toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 2,
          isStrokeJoinRound: true,
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
          stream: channel.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.active) {
              var data = jsonDecode(snapshot.data);

              feed.add(data[widget.graphName]);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 400,
                    width: 500,
                    child: LineChart(feedGraph(feed)),
                  ),
                ],
              );
            }
            return const Center(child: Text("Loading"));
          }),
    );
  }
}
