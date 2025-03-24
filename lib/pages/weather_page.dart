import 'package:bibipweather/models/weather_model.dart';
import 'package:bibipweather/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // API key
  final _weatherService = WeatherService('6213a8cfea32eedda178245352019e1b');
  Weather? _weather;

  // PageController for managing page navigation
  final PageController _pageController = PageController();

  // Fetch weather
  _fetchWeather() async {
    try {
      final weather = await _weatherService.getWeatherByLocation();
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // Get weather animation based on main condition
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/Animation - 1742675154714.json'; // Default animation (clear)
    }

    switch (mainCondition.toLowerCase()) {
      case 'clear':
        return 'assets/Animation - 1742675154714.json'; // Güneşli
      case 'clouds':
        return 'assets/Animation - 1742675191898.json'; // Bulutlu
      case 'rain':
        return 'assets/Animation - 1742675225266.json'; // Yağmurlu
      case 'thunderstorm':
        return 'assets/Animation - 1742675286697.json'; // Şimşekli
      case 'drizzle':
        return 'assets/Animation - 1742675325084.json'; // Parçalı Bulutlu
      case 'snow':
        return 'assets/Animation - 1742675521052.json'; // Karlı
      default:
        return 'assets/Animation - 1742675154714.json'; // Default animation (clear)
    }
  }

  // Translate weather condition to Turkish
  String getWeatherConditionInTurkish(String? condition) {
    if (condition == null) return "Bilinmiyor"; // Default if condition is null

    switch (condition.toLowerCase()) {
      case 'clear':
        return 'Güneşli';
      case 'clouds':
        return 'Bulutlu';
      case 'rain':
        return 'Yağmurlu';
      case 'thunderstorm':
        return 'Şimşekli';
      case 'drizzle':
        return 'Parçalı Bulutlu';
      case 'snow':
        return 'Karlı';
      default:
        return 'Bilinmiyor'; // Default if condition is not recognized
    }
  }

  // Get background color based on weather condition
  Color? getWeatherBackgroundColor(String? mainCondition) {
    if (mainCondition == null) return Colors.white; // Default background color

    switch (mainCondition.toLowerCase()) {
      case 'clear':
        return Colors.blue; // Güneşli hava için mavi
      case 'clouds':
        return Colors.grey[800]; // Bulutlu hava için gri
      case 'rain':
        return Colors.blueGrey; // Yağmurlu hava için koyu mavi-gri
      case 'thunderstorm':
        return Colors.indigo[900]; // Şimşekli hava için morumsu bir renk
      case 'drizzle':
        return Colors.lightBlueAccent; // Çiseleyen yağmur için açık mavi
      case 'snow':
        return Colors.white; // Karlı hava için beyaz
      default:
        return Colors.white; // Varsayılan olarak beyaz
    }
  }

  // Get text color based on background color (contrast for visibility)
  Color? getWeatherTextColor(String? mainCondition) {
    if (mainCondition == null) return Colors.black; // Varsayılan renk

    switch (mainCondition.toLowerCase()) {
      case 'clear':
        return Colors.white; // Güneşli hava için beyaz yazı (Mavi arka plan)
      case 'clouds':
        return Colors.white; // Bulutlu hava için siyah yazı (Gri arka plan)
      case 'rain':
        return Colors
            .white; // Yağmurlu hava için beyaz yazı (Koyu mavi-gri arka plan)
      case 'thunderstorm':
        return Colors.white; // Şimşekli hava için sarı yazı (Morumsu arka plan)
      case 'drizzle':
        return Colors
            .white; // Parçalı bulutlu için siyah yazı (Açık mavi arka plan)
      case 'snow':
        return Colors.grey[800]; // Karlı hava için siyah yazı (Beyaz arka plan)
      default:
        return Colors.grey[800]; // Varsayılan siyah yazı
    }
  }

  // Init state
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getWeatherBackgroundColor(
        _weather?.mainCondition,
      ), // Arka plan değişiyor!
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.horizontal, // Yatay kaydırma
        children: [
          // Weather page
          _weather == null
              ? Center(
                child: CircularProgressIndicator(),
              ) // Yükleniyor göstergesi
              : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // City name
                    Text(
                      _weather?.cityName ?? "City...",
                      style: TextStyle(
                        fontSize: 35,
                        color: getWeatherTextColor(
                          _weather?.mainCondition,
                        ), // Dinamik renk
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Display weather animation based on the main condition
                    Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

                    // Temperature
                    Text(
                      '${_weather?.temperature.round()} °C',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: getWeatherTextColor(
                          _weather?.mainCondition,
                        ), // Dinamik renk
                      ),
                    ),

                    // Weather condition in Turkish with larger font size
                    Text(
                      getWeatherConditionInTurkish(_weather?.mainCondition),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: getWeatherTextColor(
                          _weather?.mainCondition,
                        ), // Dinamik renk
                      ),
                    ),
                  ],
                ),
              ),
          // Second page with white background
          Container(
            color: Colors.white, // Set background to white for second page
            child: Center(
              child: Text(
                "İkinci Sayfa",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ), // Text color set to black
              ),
            ),
          ),
        ],
      ),
    );
  }
}
