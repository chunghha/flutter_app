// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Country _$CountryFromJson(Map<String, dynamic> json) {
  return Country(
      name: json['name'] as String,
      capital: json['capital'] as String,
      population: json['population'] as int,
      subregion: json['subregion'] as String,
      flag: json['flag'] as String);
}

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'name': instance.name,
      'capital': instance.capital,
      'population': instance.population,
      'subregion': instance.subregion,
      'flag': instance.flag
    };
