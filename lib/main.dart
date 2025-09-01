import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_boy/get_current_temperature.dart';
import 'package:weather_boy/get_icon.dart';
import 'dart:convert';

import 'summary_card.dart';
import 'additional_info.dart';
import 'current_weather.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Map<String, dynamic>> weather;
  late Map<String, dynamic> mapData;
  String temperature = "loading...";
  String skyType = "loading...";
  IconData skyIcon = Icons.circle;
  String humidity = "loading...";
  String pressure = "loading...";
  String windSpeed = "loading...";

  int hours = DateTime.now().hour;
  int mins = DateTime.now().minute;
  late int dataStartHour;

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    String weatherPlace = 'Elumathur,in';

    String openWeatherAppId = dotenv.env['API_KEY'] ?? 'no key found';

    try {
      var data = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$weatherPlace&APPID=$openWeatherAppId',
        ),
      );

      await Future.delayed(Duration(seconds: 2));

      Map<String, dynamic> mapData = json.decode(data.body);

      if (mapData['cod'] != '200') {
        throw 'An unexpected error occured';
      }

      dataStartHour = int.parse(
        DateFormat.H().format(DateTime.parse(mapData['list'][0]['dt_txt'])),
      );
      return mapData;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(  ).copyWith(
        appBarTheme: AppBarTheme(color: Color.fromRGBO(100, 100, 100, 0.17)),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'WEATHER BOY',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  weather = getCurrentWeather();
                });
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: weather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LinearProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.connectionState == ConnectionState.done) {
              mapData = snapshot.data!;
              temperature =
                  getCurrentTemperature(mapData['list'], [
                    hours,
                    mins,
                  ], dataStartHour).toString();
              skyType = (mapData['list'][0]['weather'][0]['main']).toString();
              skyIcon = getIcon(skyType);
              humidity = (mapData['list'][0]['main']['humidity']).toString();
              pressure = (mapData['list'][0]['main']['pressure']).toString();
              windSpeed = (mapData['list'][0]['wind']['speed']).toString();
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  children: [
                    SizedBox(height: 20),

                    CurrentWeather(
                      temp: temperature,
                      icon: Icon(skyIcon, size: 40),
                      comment: skyType,
                    ),

                    SizedBox(height: 20),

                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Weather Summary',
                        style: TextStyle(fontSize: 27),
                        textAlign: TextAlign.left,
                      ),
                    ),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: SizedBox(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              var weatherTime = DateTime.parse(
                                mapData['list'][index]['dt_txt'],
                              );
                              var convertedWeathertime = DateFormat.j().format(
                                weatherTime,
                              );
                              return SummaryCard(
                                time: convertedWeathertime,
                                icon: Icon(
                                  getIcon(
                                    mapData['list'][index]['weather'][0]['main'],
                                  ),
                                ),
                                temp: (mapData['list'][index]['main']['temp'] -
                                        273.15)
                                    .toStringAsFixed(2),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Additional Information',
                        style: TextStyle(fontSize: 27),
                      ),
                    ),
                    SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AdditionalInfo(
                                  icon: Icons.water_drop,
                                  info: 'Humidity',
                                  data: humidity,
                                ),
                                SizedBox(width: 30),
                                AdditionalInfo(
                                  icon: Icons.wind_power_outlined,
                                  info: 'Wind Speed',
                                  data: windSpeed,
                                ),
                                SizedBox(width: 30),
                                AdditionalInfo(
                                  icon: Icons.speed_outlined,
                                  info: 'Pressure',
                                  data: pressure,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
