import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:untitled/models/StepModel.dart';
import 'package:untitled/providers/step_provider.dart';
import 'package:vibration/vibration.dart';
import 'package:intl/intl.dart';
import 'achievement_bar.dart';
import 'reeder_icon_data.dart';

class StepBox extends StatefulWidget {
  const StepBox({Key? key}) : super(key: key);

  @override
  State<StepBox> createState() => _StepBoxState();
}

class _StepBoxState extends State<StepBox> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';

  @override
  void initState() {
    super.initState();
    initPlatformState();
    Provider.of<StepProvider>(context, listen: false).getWeeklySteps();
  }

  void onStepCount(StepCount event) {
    Provider.of<StepProvider>(context, listen: false).stepController.insertStep(
        StepModel(
            stepCount: event.steps,
            date: event.timeStamp.millisecondsSinceEpoch));
    Provider.of<StepProvider>(context, listen: false)
        .updateTodayStep(event.steps);

    setState(() {
      _steps = event.steps.toString();
    });
    Vibration.vibrate(duration: 100);
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.now();
    return Provider.of<StepProvider>(context).loading
        ? CircularProgressIndicator()
        : Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.green[400],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              height: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Adım",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.keyboard_arrow_right)
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ReederIconData(
                    avatarColor: Colors.grey[300]!,
                    icon: const Icon(
                      Icons.directions_walk,
                      color: Colors.blue,
                    ),
                    text: Provider.of<StepProvider>(context)
                        .weeklySteps[0]
                        .toString()),
                ReederIconData(
                    avatarColor: Colors.green[100]!,
                    icon: const Icon(
                      Icons.location_on_outlined,
                      color: Colors.green,
                    ),
                    text: "1.2 KM"),
                ReederIconData(
                    avatarColor: Colors.red[100]!,
                    icon: const Icon(
                      Icons.local_fire_department,
                      color: Colors.red,
                    ),
                    text: "55 Kal.")
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: AchievementBar(todaysStepCount: 4200),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                      label: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: Row(children: [
                      Text("Adım"),
                      Icon(Icons.keyboard_arrow_down)
                    ]),
                  )),
                  Chip(
                      label: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: Row(children: [
                      Text("Son 7 gün"),
                      Icon(Icons.keyboard_arrow_down)
                    ]),
                  ))
                ],
              ),
            ),
            SfCartesianChart(
                // Initialize category axis
                primaryXAxis: CategoryAxis(),
                series: <LineSeries<SalesData, String>>[
                  LineSeries<SalesData, String>(
                      // Bind data source
                      dataSource: <SalesData>[
                        SalesData(
                            DateFormat('EEEE').format(DateTime(date.year,date.month,date.day-4)),
                            Provider.of<StepProvider>(context,listen:false)
                                .weeklySteps[4]
                                .toDouble()),
                        SalesData(
                            DateFormat('EEEE').format(DateTime(date.year,date.month,date.day-3)),
                            Provider.of<StepProvider>(context,listen:false)
                                .weeklySteps[3]
                                .toDouble()),
                        SalesData(
                            DateFormat('EEEE').format(DateTime(date.year,date.month,date.day-2)),
                            Provider.of<StepProvider>(context,listen:false)
                                .weeklySteps[2]
                                .toDouble()),
                        SalesData(
                            DateFormat('EEEE').format(DateTime(date.year,date.month,date.day-1)),
                            Provider.of<StepProvider>(context,listen:false)
                                .weeklySteps[1]
                                .toDouble()),
                        SalesData(
                            'Today',
                            Provider.of<StepProvider>(context,listen:false)
                                .weeklySteps[0]
                                .toDouble())
                      ],
                      xValueMapper: (SalesData sales, _) => sales.year,
                      yValueMapper: (SalesData sales, _) => sales.sales)
                ]),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
