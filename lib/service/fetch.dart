import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:fl_country/model/country.dart';

Future<List<Country>> fetchCountries() async {
  final response = await http.get('https://restcountries.eu/rest/v2/all');

  return compute(parseCountries, response.body);
}

List<Country> parseCountries(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Country>((json) => Country.fromJson(json)).toList();
}
