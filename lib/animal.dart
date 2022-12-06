import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:krava/evaluationChart.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'main.dart';
import 'utils.dart';
import 'map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

class Animal extends StatefulWidget {
  const Animal({super.key});

  @override
  State<Animal> createState() => _AnimalState();
}

class _AnimalState extends State<Animal> {
  Queue<Message> messages = Queue();
  Queue<ImprovedMarker> myMarkers = Queue();
  Queue<ActivityStatus> activityData = Queue();
  double battery = 0;
  int messNumber = 0;

  @override
  void initState() {
    /// The client has a change notifier object(see the Observable class) which we then listen to to get
    /// notifications of published updates to each subscribed topic.
    mqtt.client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      /// The above may seem a little convoluted for users only interested in the
      /// payload, some users however may be interested in the received publish message,
      /// lets not constrain ourselves yet until the package has been in the wild
      /// for a while.
      /// The payload is a byte buffer, this will be specific to the topic
      print(
          'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      print('');
      setState(() {
        messNumber++;
        Message mess = Message.FromString(pt);
        messages.addFirst(mess);
        for (var item in myMarkers.take(10)) {
          item.opacity -= 0.1;
        }
        myMarkers
            .addFirst(ImprovedMarker(coordinates: LatLng(mess.lat, mess.lon)));
        activityData.addFirst(
          ActivityStatus(time: mess.time, activities: mess.activities),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //print("myMarkers length: ${myMarkers.length}");
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(" Sync: ${messages.first.time}"),
            Row(
              children: [
                Transform.rotate(
                    child: Icon(Icons.battery_5_bar_sharp, size: 50),
                    angle: math.pi / 2),
                Text(
                  '${(messages.first.battery / 4400.0 * 100).toInt()} %',
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ],
        ),
        Map(
          markers: myMarkers
              .take(10)
              .map((e) => e.getMarker(context))
              .toList()
              .reversed
              .toList(),
        ),
        SizedBox(
          height: 30,
        ),
        EvaluationChart(
          activityStatus: activityData.take(8).toList(),
        ),
      ],
    );
  }
}
