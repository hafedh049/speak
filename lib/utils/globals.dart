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
