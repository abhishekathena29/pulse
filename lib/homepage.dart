import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:pulse/graph.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://192.168.4.1/ws'), // Replace with your ESP32 IP address
  );

  List<PdfDataModel> allHeartRate = [];
  // List<double> allAvgHeartRate = [];
  List<PdfDataModel> allSpo2Rate = [];
  // List<double> allAvgSpo2Rate = [];
  List<PdfDataModel> allHumidity = [];
  // List<double> allAvgHumidity = [];
  List<PdfDataModel> allTempdht22 = [];
  // List<double> allAvgTempdht22 = [];
  List<PdfDataModel> allTempLm35 = [];
  // List<double> allAvgTempdLm35 = [];

  int count = 0;

  double sumHeartRate = 0,
      sumSpo2 = 0,
      sumHumidity = 0,
      sumTempdht22 = 0,
      sumTemplm35 = 0;
  double calculateAvg(double sum, double rate) {
    return double.parse((sum / count).toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Pulse App'),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: channel.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.active) {
              var data = jsonDecode(snapshot.data);

              count++;

              double heartRate = double.parse(data["heartRate"].toString());
              sumHeartRate += heartRate;
              double avgHearRate = calculateAvg(sumHeartRate, heartRate);
              if (DateTime.now().second % 10 == 0) {
                log('hello');
                allHeartRate.add(PdfDataModel(
                    value: heartRate,
                    avgValue: avgHearRate,
                    date: DateTime.now()));
              }

              double spo02 = double.parse(data["spO2"].toString());
              sumSpo2 += spo02;
              double avgSpo2 = calculateAvg(sumSpo2, spo02);
              if (DateTime.now().second % 10 == 0) {
                allSpo2Rate.add(PdfDataModel(
                    value: spo02, avgValue: avgSpo2, date: DateTime.now()));
              }

              double humidity = double.parse(data["humidity"].toString());
              sumHumidity += humidity;
              double avgHumidity = calculateAvg(sumHumidity, humidity);

              if (DateTime.now().second % 10 == 0) {
                allHumidity.add(PdfDataModel(
                    value: humidity,
                    avgValue: avgHumidity,
                    date: DateTime.now()));
              }

              double tempdht22 = double.parse(data["tempDHT22"].toString());
              sumTempdht22 += tempdht22;
              double avgTempdht22 = calculateAvg(sumTempdht22, tempdht22);

              if (DateTime.now().second % 10 == 0) {
                allTempdht22.add(PdfDataModel(
                    value: tempdht22,
                    avgValue: avgTempdht22,
                    date: DateTime.now()));
              }

              double templm35 = double.parse(data["tempLM35"].toString());
              sumTemplm35 += templm35;
              double avgTempl35 = calculateAvg(sumTemplm35, templm35);

              if (DateTime.now().second % 10 == 0) {
                allTempLm35.add(PdfDataModel(
                    value: templm35,
                    avgValue: avgTempl35,
                    date: DateTime.now()));
              }

              log(data.toString());
              return Center(
                child: Column(
                  children: [
                    DataContainer(
                      title: "Heart Rate",
                      value: "${data["heartRate"]} bpm",
                      avgValue: "$avgHearRate bpm",
                      graphName: "heartRate",
                    ),
                    DataContainer(
                      title: "SP02",
                      value: "${data["spO2"]} %",
                      avgValue: "$avgSpo2 %",
                      graphName: "spO2",
                    ),
                    DataContainer(
                      title: "Humidity",
                      value: "${data["humidity"]} %",
                      avgValue: "$avgHumidity %",
                      graphName: "humidity",
                    ),
                    DataContainer(
                      title: "Temperature Outside",
                      value: "${data["tempDHT22"]} celcius",
                      avgValue: "$avgTempdht22 celcius",
                      graphName: "tempDHT22",
                    ),
                    DataContainer(
                      title: "Body temperature",
                      value: "${data["tempLM35"]} celcius",
                      avgValue: "$avgTempl35 celcius",
                      graphName: "tempLM35",
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // final file = File("$path/timedata.csv");
                        // await file.writeAsString(datafile);

                        final pdf = pw.Document();
                        pdf.addPage(pw.MultiPage(
                            pageFormat: PdfPageFormat.a4,
                            build: (pw.Context context) {
                              return [
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text('Pulse App Report',
                                        style: pw.TextStyle(
                                            fontSize: 25,
                                            fontWeight: pw.FontWeight.bold)),
                                    pw.SizedBox(height: 50),
                                    pw.Text('Heart Rate',
                                        style: pw.TextStyle(fontSize: 20)),
                                    ...List.generate(
                                      allHeartRate.length,
                                      (index) => pw.Row(
                                        children: [
                                          pw.Text(DateFormat('dd-MM-yy hh:mm a')
                                              .format(
                                                  allHeartRate[index].date)),
                                          pw.SizedBox(width: 20),
                                          pw.Text(allHeartRate[index]
                                              .value
                                              .toStringAsFixed(2)),
                                        ],
                                      ),
                                    ),
                                    pw.SizedBox(height: 10),
                                    pw.Text('SP O2',
                                        style: pw.TextStyle(fontSize: 20)),
                                    ...List.generate(
                                      allSpo2Rate.length,
                                      (index) => pw.Row(
                                        children: [
                                          pw.Text(DateFormat('dd-MM-yy hh:mm a')
                                              .format(allSpo2Rate[index].date)),
                                          pw.SizedBox(width: 20),
                                          pw.Text(allSpo2Rate[index]
                                              .value
                                              .toStringAsFixed(2)),
                                        ],
                                      ),
                                    ),
                                    pw.SizedBox(height: 10),
                                    pw.Text('Humidity',
                                        style: pw.TextStyle(fontSize: 20)),

                                    ...List.generate(
                                      allHumidity.length,
                                      (index) => pw.Row(
                                        children: [
                                          pw.Text(DateFormat('dd-MM-yy hh:mm a')
                                              .format(allHumidity[index].date)),
                                          pw.SizedBox(width: 20),
                                          pw.Text(allHumidity[index]
                                              .value
                                              .toStringAsFixed(2)),
                                        ],
                                      ),
                                    ),
                                    pw.SizedBox(height: 10),
                                    pw.Text('Temperature Outside',
                                        style: pw.TextStyle(fontSize: 20)),
                                    ...List.generate(
                                      allTempdht22.length,
                                      (index) => pw.Row(
                                        children: [
                                          pw.Text(DateFormat('dd-MM-yy hh:mm a')
                                              .format(
                                                  allTempdht22[index].date)),
                                          pw.SizedBox(width: 20),
                                          pw.Text(allTempdht22[index]
                                              .value
                                              .toStringAsFixed(2)),
                                        ],
                                      ),
                                    ),
                                    pw.SizedBox(height: 10),
                                    pw.Text('Body Tempera ture',
                                        style: pw.TextStyle(fontSize: 20)),
                                    ...List.generate(
                                      allTempLm35.length,
                                      (index) => pw.Row(
                                        children: [
                                          pw.Text(DateFormat('dd-MM-yy hh:mm a')
                                              .format(allTempLm35[index].date)),
                                          pw.SizedBox(width: 20),
                                          pw.Text(allTempLm35[index]
                                              .value
                                              .toStringAsFixed(2)),
                                        ],
                                      ),
                                    ),

                                    // pw.Text('SP O2'),
                                    // ...List.generate(
                                    //     allSpo2Rate.length,
                                    //     (index) => pw.Text(
                                    //         allSpo2Rate[index].toString())),
                                    // pw.Text('Humidity'),
                                    // ...List.generate(
                                    //     allHumidity.length,
                                    //     (index) => pw.Text(
                                    //         allHumidity[index].toString())),
                                  ],
                                ),
                                // if (image != null)
                                //   pw.Image(pw.MemoryImage(image))
                              ];
                            }));

                        final directory =
                            Directory("/storage/emulated/0/Download");
                        final path = directory.path;
                        print(path);

                        await Directory(path).create(recursive: true);

                        final file = File(
                            "$path/pulse_report_${DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now())}.pdf");
                        await file.writeAsBytes(await pdf.save());
                      },
                      child: Text('Generate Report'),
                    )
                  ],
                ),
              );
            }
            return Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.sizeOf(context).height / 3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DataContainer extends StatelessWidget {
  const DataContainer({
    super.key,
    required this.value,
    required this.title,
    required this.graphName,
    required this.avgValue,
  });
  final String title;
  final String value;
  final String avgValue;
  final String graphName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width,
          margin: EdgeInsets.only(bottom: 20, left: 15, right: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 17, color: Colors.black54),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GraphView(
                                  title: title, graphName: graphName)));
                    },
                    child: Row(
                      children: [
                        Icon(Icons.bar_chart),
                        SizedBox(width: 5),
                        Text('Graph'),
                        SizedBox(width: 15),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Average",
                    style: const TextStyle(),
                  ),
                  SizedBox(width: 20),
                  Text(
                    avgValue,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PdfDataModel {
  double value;
  double avgValue;
  DateTime date;

  PdfDataModel({
    required this.value,
    required this.avgValue,
    required this.date,
  });
}
