import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'weather_provider.dart';
import 'indian_cities.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[900]!,
              Colors.blue[700]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32.0),
                Text(
                  'Live Weather',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.oswald(
                    fontSize: 48.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32.0),
                TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _cityController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Enter City',
                      labelStyle: const TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(color: Colors.white70),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  suggestionsCallback: (pattern) {
                    return indianCities
                        .where((city) =>
                            city.toLowerCase().startsWith(pattern.toLowerCase()))
                        .toList();
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    _cityController.text = suggestion;
                    Provider.of<WeatherProvider>(context, listen: false)
                        .fetchWeather(suggestion);
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_cityController.text.isNotEmpty) {
                      Provider.of<WeatherProvider>(context, listen: false)
                          .fetchWeather(_cityController.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: Text(
                    'Get Weather',
                    style: GoogleFonts.lato(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
                Expanded(
                  child: Consumer<WeatherProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (provider.errorMessage != null) {
                        return Center(
                          child: Text(
                            provider.errorMessage!,
                            style: const TextStyle(color: Colors.red, fontSize: 18.0),
                          ),
                        );
                      } else if (provider.weatherData != null) {
                        final weather = provider.weatherData!;
                        return Column(
                          children: [
                            Text(
                              '${weather['name']}, ${weather['sys']['country']}',
                              style: GoogleFonts.lato(
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              '${(weather['main']['temp']).round()}°C',
                              style: GoogleFonts.oswald(
                                fontSize: 80.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              '${weather['weather'][0]['description']}',
                              style: GoogleFonts.lato(
                                fontSize: 24.0,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: Text(
                            'Enter a city to get the weather forecast.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 18.0,
                              color: Colors.white70,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
