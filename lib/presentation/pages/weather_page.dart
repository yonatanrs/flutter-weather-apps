import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/models/area_model.dart';
import '../../data/models/temperature_model.dart';
import '../../data/repositories/weather_repository.dart';
import '../controllers/weather_controller.dart';
import '../widgets/weather_card.dart';

class WeatherPage extends StatelessWidget {
  int rowIndex = 0;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WeatherController(
      repository: context.read<WeatherRepository>(),
    ));
    return Scaffold(
      appBar: AppBar(
        title:  Row(
          children: <Widget>[
            Icon(
              Icons.cloud,
              color: Colors.black, // Warna ikon cuaca
            ),
            SizedBox(width: 8), // Jarak antara ikon dan teks
            Text(
              'Weather App',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0).copyWith(top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.scale(
              scale: 0.5, // Ganti nilai ini sesuai dengan faktor skala yang Anda inginkan
              child: Container(
                margin: EdgeInsets.all(1.0), // Sesuaikan nilai margin sesuai kebutuhan
                child: Image.asset('assets/images/lampung_logo.png'),
              ),
            ),
            Obx(() {
              final fetchWeatherResult = controller.weatherResult.value;
              final weatherModel = fetchWeatherResult.weatherModel;
              final e = fetchWeatherResult.weatherModel;
              final isLoading = fetchWeatherResult.isLoading;
              String getTemperatureStatus(TemperatureModel temperatureModel) {
                if (temperatureModel.celcius > 30) {
                  return 'Diatas Standard';
                } else if (temperatureModel.celcius < 30) {
                  return 'Dibawah Standard';
                } else {
                  return 'Standard';
                }
              }
              Color getTemperatureColor(TemperatureModel temperatureModel) {
                if (temperatureModel.celcius > 30) {
                  return Colors.red; // Ubah warna teks untuk Diatas Standard menjadi merah
                } else if (temperatureModel.celcius < 30) {
                  return Colors.blue; // Ubah warna teks untuk Dibawah Standard menjadi biru
                } else {
                  return Colors.green; // Ubah warna teks untuk Standard menjadi hijau
                }
              }
              String formatDate(String dateString) {
                final year = int.parse(dateString.substring(0, 4));
                final month = int.parse(dateString.substring(4, 6));
                final day = int.parse(dateString.substring(6, 8));
                final hour = int.parse(dateString.substring(8, 10));
                final minute = int.parse(dateString.substring(10, 12));
                final second = int.parse(dateString.substring(12, 14));
                final dateTime = DateTime.utc(year, month, day, hour, minute, second);
                return DateFormat("dd MMMM yyyy, HH:mm:ss").format(dateTime);
              }
              if (isLoading) {
                return const Text("Loading");
              } else if (weatherModel == null && e == null) {
                return const Text("Anda belum menekan tombol Perbarui Data Cuaca");
              } else if (weatherModel != null) {
                List<AreaModel> areaModelList = weatherModel.areaModelList;
                return Center(
                  child: Table(
                    children: [
                      const TableRow(children: [
                        Text("Nama Kota", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                        Text("Tindakan", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                      ]),
                      ...areaModelList.map<TableRow>((e) {
                        final backgroundColor = rowIndex % 2 == 0 ? Colors.grey : Colors.white; // Menentukan warna latar belakang
                        rowIndex++; // Menambah indeks baris setiap kali loop
                        return TableRow(
                            children: [
                          Container(
                            color: backgroundColor, // Menetapkan warna latar belakang
                            child: Text(e.cityName, style: TextStyle(fontSize: 15.0)),
                          ),
                         Container(
                         color: backgroundColor,
                            child:  GestureDetector(
                                 onTap: () {
                                   AreaModel areaModel = e;
                                   List<TemperatureTimeRangeModel> temperatureTimeRangeModelList = areaModel.temperatureParameterModel.temperatureTimeRangeModelList;
                                   showDialog(
                                     context: context,
                                     builder: (BuildContext context) {
                                       return Dialog(
                                           child: SingleChildScrollView(
                                               padding: const EdgeInsets.all(16.0),
                                               child: Column(
                                                   children: [
                                                     Text(
                                                         areaModel.cityName,
                                                         style: TextStyle(
                                                             fontSize: 16,
                                                             fontWeight: FontWeight.bold
                                                         )
                                                     ),
                                                     const SizedBox(height: 10),
                                                     Table(
                                                       children: [
                                                         const TableRow(children: [
                                                           Text("Tanggal", style: TextStyle(fontSize: 15.0)),
                                                           Text("Suhu", style: TextStyle(fontSize: 15.0)),
                                                           Text("Status", style: TextStyle(fontSize: 15.0)),
                                                         ]),
                                                         ...temperatureTimeRangeModelList.map<TableRow>((temperatureTimeRangeModel) {
                                                           return TableRow(children: [
                                                             Text(formatDate("${temperatureTimeRangeModel.dateTime}00"), style: TextStyle(fontSize: 15.0)),
                                                             Text("${temperatureTimeRangeModel.temperatureModel.celcius} °C", style: TextStyle(fontSize: 15.0)),
                                                             Text(getTemperatureStatus(temperatureTimeRangeModel.temperatureModel), style: TextStyle(fontSize: 15.0, color: getTemperatureColor(temperatureTimeRangeModel.temperatureModel))),
                                                           ]);
                                                         }).toList()
                                                       ],
                                                     )
                                                   ]
                                               )
                                           )
                                       );
                                     },
                                   );
                                 },
                                 child: Center(child: Text(
                                     "Lihat Detail",
                                     style: TextStyle(
                                         fontSize: 15.0,
                                         color: Colors.blue,fontWeight: FontWeight.bold
                                     )
                                 ),)
                             )
                         ),
                        ]);
                      }).toList()
                    ],
                  )
                );
              } else if (e != null) {
                return Text("Ada error: $e");
              }
              return Container();
            }),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.fetchWeather();
              },
              child: Text('Perbarui Data Cuaca'),
            ),
          ],
        ),
      ),
    );
  }
}
