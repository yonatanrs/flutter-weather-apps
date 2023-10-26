import 'package:get/get.dart';

import '../../data/models/weather_model.dart';
import '../../data/repositories/weather_repository.dart';

class WeatherController extends GetxController {
  final WeatherRepository repository;

  WeatherController({required this.repository});

  var weatherResult = FetchWeatherResult(
    isLoading: false,
    weatherModel: null,
    e: null
  ).obs;

  void fetchWeather() async {
    try {
      weatherResult.value = FetchWeatherResult(
        isLoading: true,
        weatherModel: null,
        e: null
      );
      update();
      final result = await repository.getWeatherData();
      weatherResult.value = FetchWeatherResult(
        isLoading: false,
        weatherModel: result,
        e: null
      );
      update();
    } catch (e) {
      weatherResult.value = FetchWeatherResult(
        isLoading: false,
        weatherModel: null,
        e: e
      );
      update();
    }
  }
}

class FetchWeatherResult {
  bool isLoading;
  WeatherModel? weatherModel;
  dynamic e;

  FetchWeatherResult({
    required this.isLoading,
    required this.weatherModel,
    required this.e
  });
}