import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const String BASE_URL =
      "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService(this.apiKey);

  // Konum verisini alıp hava durumu verisi döndüren fonksiyon
  Future<Weather> getWeatherByLocation() async {
    try {
      // Konum izinlerini kontrol et
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          throw Exception("Konum izinleri reddedildi.");
        }
      }

      // Konum servisini kontrol et
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Konum servisi etkin değil.");
      }

      // Kullanıcının mevcut konumunu al
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print("Konum: ${position.latitude}, ${position.longitude}");

      // API isteğini yap (latitude ve longitude parametrelerini konumdan alıyoruz)
      final response = await http.get(
        Uri.parse(
          "$BASE_URL?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric",
        ),
      );

      if (response.statusCode == 200) {
        print("API Yanıtı: ${response.body}");
        return Weather.fromJson(json.decode(response.body));
      } else {
        print("API Hata: ${response.statusCode} - ${response.body}");
        throw Exception("API'den veri alınamadı.");
      }
    } catch (e) {
      print("Hata: $e");
      throw Exception("Konumla ilgili veri çekme hatası: $e");
    }
  }
}
