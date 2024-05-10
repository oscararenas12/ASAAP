import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '7fc52346cc6a1b849d37d8f5e542e3cd';
  final String city = 'Long Beach';
  final String countryCode = 'US';

  Future<Map<String, dynamic>> fetchWeather() async {
    var url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city,$countryCode&appid=$apiKey&units=imperial');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
