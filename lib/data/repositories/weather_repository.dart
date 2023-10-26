import '../datasources/weather_remote_data_source.dart';
import '../models/weather_model.dart';

class WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;

  WeatherRepository({required this.remoteDataSource});

  Future<WeatherModel> getWeatherData() async {
    final weatherData = await remoteDataSource.fetchWeatherData();
    return weatherData;
  }
}
