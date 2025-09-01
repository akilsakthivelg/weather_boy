//import 'package:flutter/material.dart';

String getCurrentTemperature(List<dynamic> data,List<int> currentTime,int startTime,) {
  int differenceTime = currentTime[0] - startTime;
  double differencePercent = 0;
  double temp, temp1, temp2;
  //int index = 0;
  int i = 0;
  temp1 = data[i]['main']['temp'];
  temp2 = data[i + 1]['main']['temp'];
  temp = temp1;
  double tempDifference = temp2 - temp1;
  while (true) {
    if (differenceTime < 3) {
      //index = i;
      break;
    }
    i++;
    startTime += 3;
    differenceTime = currentTime[0] - startTime;
    temp1 = data[i]['main']['temp'];
    temp2 = data[i + 1]['main']['temp'];
    tempDifference = temp2 - temp1;
    temp = temp1;
  }
  differencePercent = (60 * differenceTime + currentTime[1]) / 180;
  
  temp += tempDifference * differencePercent;
  return (temp - 273).toStringAsFixed(2);
}
