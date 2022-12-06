import 'package:flutter/material.dart';
import 'package:krava/utils.dart';
import 'package:stacked_chart/stacked_chart.dart';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stacked_chart/stacked_chart.dart';

enum WeekDay { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

class EvaluationChart extends StatefulWidget {
  List<ActivityStatus> activityStatus = [];
  EvaluationChart({super.key, required this.activityStatus});

  @override
  _EvaluationChartState createState() => _EvaluationChartState();
}

class _EvaluationChartState extends State<EvaluationChart> {
  @override
  Widget build(BuildContext context) {
    return StackedChart(
      data: widget.activityStatus,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      size: const Size(340, 220),
      showLabel: true,
      enableShadow: true,
      buffer: 0,
      barWidth: 20,
    );
  }
}

class BookingStatus extends ChartData<LabelData, int>
    implements Comparable<BookingStatus> {
  final DateTime dateTime;
  final Map<String, int> bookings;
  final VoidCallback? onPressed;

  static Map<LabelData, int> convertBookingToMapOfLabelDataInt(
      Map<String, int> bookings) {
    final Map<LabelData, int> convertedData = {};
    bookings.entries
        .map((e) => convertedData.addAll({LabelData(e.key): e.value}))
        .toList();
    return convertedData;
  }

  int get totalBookingCount =>
      bookings.values.reduce((total, value) => total = total + value);

  BookingStatus(
      {required this.dateTime, this.bookings = const {}, this.onPressed})
      : super(
          labelWithValue: convertBookingToMapOfLabelDataInt(bookings),
          barLabel: dateTime.day.toString(),
          onPressed: onPressed,
        );

  @override
  int compareTo(BookingStatus other) => dateTime.compareTo(other.dateTime);
}

class ActivityStatus extends ChartData<LabelData, int>
    implements Comparable<ActivityStatus> {
  static Map<ACTIVITY, Color> activityColors = {
    ACTIVITY.GROUND: Colors.black,
    ACTIVITY.STILL: Colors.blue,
    ACTIVITY.RUMINATE: Colors.brown,
    ACTIVITY.GRAZE: Colors.greenAccent,
    ACTIVITY.WALK: Colors.red,
    ACTIVITY.UNKNOWN: Colors.yellow,
  };
  final String time;
  final Map<ACTIVITY, int> activities;
  final String name;
  final VoidCallback? onPressed;

  static Map<LabelData, int> convertActivitiesToMapOfLabelDataInt(
      Map<ACTIVITY, int> activities) {
    final Map<LabelData, int> convertedData = {};
    activities.entries
        .map((e) => convertedData.addAll({
              LabelData(e.key.toString().split('.')[1],
                  ActivityStatus.activityColors[e.key]): e.value
            }))
        .toList();
    return convertedData;
  }

  int get totalBookingCount =>
      activities.values.reduce((total, value) => total = total + value);

  ActivityStatus(
      {required this.time,
      required this.name,
      this.activities = const {},
      this.onPressed})
      : super(
          labelWithValue: convertActivitiesToMapOfLabelDataInt(activities),
          barLabel: time,
          onPressed: onPressed,
        );

  @override
  int compareTo(ActivityStatus other) => time.compareTo(other.time);
}
