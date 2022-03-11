import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';

var deviceDetailsDataListVar = [];
var deviceDetailsTitleListVar = [];
var deviceDetailsIconListVar = [];
int deviceDetailsListVarLength = 0;
bool systemDetailsGot = true;

double screenHeight = 0;
double screenWidth = 0;
bool themedata = false;

//ThemeProvider themeProvider;
var battery = Battery();
int percentage = 0;
String batteryStatus = "";
String batteryHealth = "";
Color batterycolor = const Color.fromARGB(255, 2, 241, 14);
String batteryCapacity = "";
String batteryLevel = "";
String chargingStatus = "";
String chargeTimeRemaining = "";
String currentAverage = "";
String currentNow = "";
String pluggedStatus = "";
String batteryPresence = "";
String scale = "";
String remainingEnergy = "";
String technology = "";
String temperature = "";
String voltage = "";
List<String> systemFeaturesList = [];

var batteryDetailsDataListVar = [];
var batteryDetailsTitleListVar = [];

class BatteryData {
  final int time;
  final int level;

  BatteryData(this.time, this.level);
}

String formatBatteryHealth(var health) {
  String batteryHealth;
  switch (health) {
    case "heath_good":
      batteryHealth = "Good";
      break;
    default:
      batteryHealth = "Unknown";
      break;
  }
  return batteryHealth;
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

void formatSystemFeature(List<String?> systemFeatures) {
  for (int i = 0; systemFeatures.length > i; i++) {
    if (systemFeatures[i] != null) {
      String str1, str2, str3 = "";
      str1 = systemFeatures[i].toString();
      if (str1.contains(".")) {
        str2 = str1.substring(0, str1.lastIndexOf('.'));

        str2 = str2.substring(0, str2.lastIndexOf('.'));
      } else {
        str2 = str1;
      }
      str3 = str1.substring(str2.length + 1);
      str3 = str3.replaceFirst(".", " ➜ ");
      systemFeaturesList.add(str3);
    }
  }
  //systemFeaturesList.add("str3");
  //systemFeaturesList = systemFeaturesList.toSet().toList();
}
