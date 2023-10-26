import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import '../models/area_model.dart';
import '../models/temperature_model.dart';
import '../models/weather_model.dart';

class WeatherRemoteDataSource {
  final String apiUrl;

  WeatherRemoteDataSource({required this.apiUrl});

  Future<WeatherModel> fetchWeatherData() async {
    final response = await http.get(
      Uri.parse(apiUrl),
    );
    final document = XmlDocument.parse(response.body);
    final data = document.findElements("data").first;
    final forecast = data.findElements("forecast").first;
    final area = forecast.findElements("area");
    final List<AreaModel> areaModelList = [];
    for (var areaNode in area) {
      // Name
      String cityName = "";
      var nameNodeList = areaNode.findElements("name");
      for (var nameNode in nameNodeList) {
        if (nameNode.getAttribute('xml:lang') == 'id_ID') {
          cityName = nameNode.text;
        }
      }
      // All Parameter
      var parameterNodeList = areaNode.findElements("parameter");
      late TemperatureParameterModel temperatureParameterModel;

      for (var parameterNode in parameterNodeList) {
        // Temperature Parameter
        if (parameterNode.getAttribute('id') == 't') {
          List<TemperatureTimeRangeModel> temperatureTimeRangeModelList = [];
          // Temperature Time Range
          var temperatureTimeRangeNodeList = parameterNode.findElements("timerange");
          for (var temperatureTimeRangeNode in temperatureTimeRangeNodeList) {
            double celcius = 0.0;
            var temperatureNodeList = temperatureTimeRangeNode.findElements("value");
            for (var temperatureNode in temperatureNodeList) {
              if (temperatureNode.getAttribute('unit') == 'C') {
                celcius = double.parse(temperatureNode.text);
              }
            }
            TemperatureTimeRangeModel temperatureTimeRangeModel = TemperatureTimeRangeModel(
              type: temperatureTimeRangeNode.getAttribute("type") ?? "",
              h: temperatureTimeRangeNode.getAttribute("h") ?? "",
              dateTime: temperatureTimeRangeNode.getAttribute("datetime") ?? "",
              temperatureModel: TemperatureModel(
                celcius: celcius
              )
            );
            temperatureTimeRangeModelList.add(temperatureTimeRangeModel);
          }
          temperatureParameterModel = TemperatureParameterModel(
            temperatureTimeRangeModelList: temperatureTimeRangeModelList
          );
        }
      }

      areaModelList.add(
        AreaModel(
          cityName: cityName,
          temperatureParameterModel: temperatureParameterModel
        )
      );
    }
    return WeatherModel(
      areaModelList: areaModelList
    );
  }
}
