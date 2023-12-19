import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive/hive.dart';

const Color secondaryColor = Color.fromARGB(255, 40, 44, 52);
const Color gray = Color.fromARGB(255, 51, 56, 66);
const Color transparent = Colors.transparent;
const Color white = Color.fromARGB(255, 204, 204, 204);
const Color orange = Color.fromARGB(255, 254, 131, 104);

final List<String> months = <String>['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];

final FlutterTts flutterTts = FlutterTts();

Box? translationsBox;

final Map<String, String> languageMap = <String, String>{
  'Albanian': 'sq-AL',
  'Arabic': 'ar',
  'Bengali (Bangladesh)': 'bn-BD',
  'Bengali (India)': 'bn-IN',
  'Bosnian': 'bs-BA',
  'Bulgarian': 'bg-BG',
  'Cantonese (Hong Kong)': 'yue-HK',
  'Catalan': 'ca-ES',
  'Chinese (Simplified)': 'zh-CN',
  'Chinese (Traditional)': 'zh-TW',
  'Croatian': 'hr-HR',
  'Czech': 'cs-CZ',
  'Danish': 'da-DK',
  'Dutch (Belgium)': 'nl-BE',
  'Dutch (Netherlands)': 'nl-NL',
  'English (Australia)': 'en-AU',
  'English (India)': 'en-IN',
  'English (Nigeria)': 'en-NG',
  'English (United Kingdom)': 'en-GB',
  'English (United States)': 'en-US',
  'Estonian': 'et-EE',
  'Filipino (Tagalog)': 'fil-PH',
  'Finnish': 'fi-FI',
  'French (Canada)': 'fr-CA',
  'French (France)': 'fr-FR',
  'German (Germany)': 'de-DE',
  'Greek': 'el-GR',
  'Gujarati': 'gu-IN',
  'Hebrew': 'he-IL',
  'Hindi': 'hi-IN',
  'Hungarian': 'hu-HU',
  'Icelandic': 'is-IS',
  'Indonesian': 'id-ID',
  'Italian': 'it-IT',
  'Japanese': 'ja-JP',
  'Javanese': 'jv-ID',
  'Kannada': 'kn-IN',
  'Khmer': 'km-KH',
  'Korean': 'ko-KR',
  'Latvian': 'lv-LV',
  'Lithuanian': 'lt-LT',
  'Malay': 'ms-MY',
  'Malayalam': 'ml-IN',
  'Marathi': 'mr-IN',
  'Nepali': 'ne-NP',
  'Norwegian (Bokmål)': 'nb-NO',
  'Polish': 'pl-PL',
  'Portuguese (Brazil)': 'pt-BR',
  'Portuguese (Portugal)': 'pt-PT',
  'Punjabi (India)': 'pa-IN',
  'Romanian': 'ro-RO',
  'Russian': 'ru-RU',
  'Serbian': 'sr',
  'Sinhala': 'si-LK',
  'Slovak': 'sk-SK',
  'Slovenian': 'sl-SI',
  'Spanish (Spain)': 'es-ES',
  'Spanish (United States)': 'es-US',
  'Sundanese': 'su-ID',
  'Swahili': 'sw-KE',
  'Swedish': 'sv-SE',
  'Tamil': 'ta-IN',
  'Telugu': 'te-IN',
  'Thai': 'th-TH',
  'Turkish': 'tr-TR',
  'Ukrainian': 'uk-UA',
  'Urdu': 'ur-PK',
  'Vietnamese': 'vi-VN',
  'Welsh': 'cy-GB',
};
