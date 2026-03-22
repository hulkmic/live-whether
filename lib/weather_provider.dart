import 'package:flutter/material.dart';
import 'weather_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _weatherService = WeatherService(
    apiKey: '0aad221fb0c2151d720a448eb0433f1d',
  );
  Map<String, dynamic>? _weatherData;
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, dynamic>? get weatherData => _weatherData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchWeather(String city) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _weatherData = await _weatherService.fetchWeather(city);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
