class TemperatureParameterModel {
  List<TemperatureTimeRangeModel> temperatureTimeRangeModelList;

  TemperatureParameterModel({
    required this.temperatureTimeRangeModelList
  });
}

class TemperatureTimeRangeModel {
  String type;
  String h;
  String dateTime;
  TemperatureModel temperatureModel;

  TemperatureTimeRangeModel({
    required this.type,
    required this.h,
    required this.dateTime,
    required this.temperatureModel
  });
}

class TemperatureModel {
  double celcius;

  TemperatureModel({
    required this.celcius
  });
}