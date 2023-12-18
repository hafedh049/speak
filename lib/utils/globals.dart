import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

const Color backgroundColor = Color.fromARGB(255, 33, 37, 43);
const Color secondaryColor = Color.fromARGB(255, 40, 44, 52);
const Color gray = Color.fromARGB(255, 51, 56, 66);
const Color transparent = Colors.transparent;
const Color white = Color.fromARGB(255, 204, 204, 204);
const Color orange = Color.fromARGB(255, 254, 131, 104);

final List<String> months = <String>['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];

Box? translationsBox;

final Map<String, String> languageMap = <String, String>{
  "Croatian": "hr-HR",
  "Korean": "ko-KR",
  "Marathi": "mr-IN",
  "Russian": "ru-RU",
  "Chinese (Traditional)": "zh-TW",
  "Hungarian": "hu-HU",
  "Swahili": "sw-KE",
  "Thai": "th-TH",
  "Urdu": "ur-PK",
  "Norwegian (Bokmål)": "nb-NO",
  "Danish": "da-DK",
  "Turkish": "tr-TR",
  "Estonian": "et-EE",
  "Portuguese (Portugal)": "pt-PT",
  "Vietnamese": "vi-VN",
  "English (United States)": "en-US",
  "Albanian": "sq-AL",
  "Swedish": "sv-SE",
  "Arabic": "ar",
  "Sundanese": "su-ID",
  "Bengali (Bangladesh)": "bn-BD",
  "Bosnian": "bs-BA",
  "Gujarati": "gu-IN",
  "Kannada": "kn-IN",
  "Greek": "el-GR",
  "Hindi": "hi-IN",
  "Hebrew": "he-IL",
  "Finnish": "fi-FI",
  "Bengali (India)": "bn-IN",
  "Khmer": "km-KH",
  "French (France)": "fr-FR",
  "Ukrainian": "uk-UA",
  "Punjabi (India)": "pa-IN",
  "English (Australia)": "en-AU",
  "Dutch (Netherlands)": "nl-NL",
  "French (Canada)": "fr-CA",
  "Latvian": "lv-LV",
  "Serbian": "sr",
  "Portuguese (Brazil)": "pt-BR",
  "German (Germany)": "de-DE",
  "Malayalam": "ml-IN",
  "Sinhala": "si-LK",
  "Czech": "cs-CZ",
  "Icelandic": "is-IS",
  "Polish": "pl-PL",
  "Catalan": "ca-ES",
  "Slovak": "sk-SK",
  "Italian": "it-IT",
  "Filipino (Tagalog)": "fil-PH",
  "Lithuanian": "lt-LT",
  "Nepali": "ne-NP",
  "Malay": "ms-MY",
  "English (Nigeria)": "en-NG",
  "Dutch (Belgium)": "nl-BE",
  "Chinese (Simplified)": "zh-CN",
  "Spanish (Spain)": "es-ES",
  "Japanese": "ja-JP",
  "Tamil": "ta-IN",
  "Bulgarian": "bg-BG",
  "Welsh": "cy-GB",
  "Cantonese (Hong Kong)": "yue-HK",
  "Spanish (United States)": "es-US",
  "English (India)": "en-IN",
  "Javanese": "jv-ID",
  "Indonesian": "id-ID",
  "Telugu": "te-IN",
  "Romanian": "ro-RO",
  "English (United Kingdom)": "en-GB",
};
