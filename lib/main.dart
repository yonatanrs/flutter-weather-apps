import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'data/datasources/weather_remote_data_source.dart';
import 'data/repositories/weather_repository.dart';
import 'presentation/controllers/weather_controller.dart';
import 'presentation/pages/weather_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WeatherRemoteDataSource weatherRemoteDataSource =
    WeatherRemoteDataSource(apiUrl: 'https://data.bmkg.go.id/DataMKG/MEWS/DigitalForecast/DigitalForecast-Lampung.xml');
    final WeatherRepository weatherRepository =
    WeatherRepository(remoteDataSource: weatherRemoteDataSource);

    return MultiProvider(
      providers: [
        Provider.value(value: weatherRepository),
      ],
      child: GetMaterialApp(
        title: 'Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WeatherPage(),
      ),
    );
  }
}
