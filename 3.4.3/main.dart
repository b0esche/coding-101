void main() {
  List<Map<String, double?>> weatherData = [
    {'temp': 5.3, 'rain': 0.9, 'wind': null},
    {'temp': 4.5, 'rain': null, 'wind': 16.8},
    {'temp': null, 'rain': 3.8, 'wind': null}
  ];

  List<double> temps = [];
  List<double> rainValues = [];
  List<double> windValues = [];

  if (weatherData[0]['temp'] != null) temps.add(weatherData[0]['temp']!);
  if (weatherData[1]['temp'] != null) temps.add(weatherData[1]['temp']!);
  if (weatherData[2]['temp'] != null) temps.add(weatherData[2]['temp']!);

  if (weatherData[0]['rain'] != null) rainValues.add(weatherData[0]['rain']!);
  if (weatherData[1]['rain'] != null) rainValues.add(weatherData[1]['rain']!);
  if (weatherData[2]['rain'] != null) rainValues.add(weatherData[2]['rain']!);

  if (weatherData[0]['wind'] != null) windValues.add(weatherData[0]['wind']!);
  if (weatherData[1]['wind'] != null) windValues.add(weatherData[1]['wind']!);
  if (weatherData[2]['wind'] != null) windValues.add(weatherData[2]['wind']!);

  double tempSum = (temps.length > 0 ? temps[0] : 0) +
      (temps.length > 1 ? temps[1] : 0) +
      (temps.length > 2 ? temps[2] : 0);

  double rainSum = (rainValues.length > 0 ? rainValues[0] : 0) +
      (rainValues.length > 1 ? rainValues[1] : 0) +
      (rainValues.length > 2 ? rainValues[2] : 0);

  double windSum = (windValues.length > 0 ? windValues[0] : 0) +
      (windValues.length > 1 ? windValues[1] : 0) +
      (windValues.length > 2 ? windValues[2] : 0);

  double? avgTemp = temps.length > 0 ? tempSum / temps.length : null;
  double? avgRain = rainValues.length > 0 ? rainSum / rainValues.length : null;
  double? avgWind = windValues.length > 0 ? windSum / windValues.length : null;

  print('Durchschnittstemperatur: ${avgTemp ?? "keine Daten"} Grad');
  print('Durchschnittliche Niederschlagsmenge: ${avgRain ?? "keine Daten"} mm');
  print(
      'Durchschnittliche Windgeschwindigkeit: ${avgWind ?? "keine Daten"} km/h');
}
