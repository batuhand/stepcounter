import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:untitled/widgets/achievement_bar.dart';
import 'package:untitled/widgets/reeder_icon_data.dart';
import 'package:vibration/vibration.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    print(event);
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
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey[300]!,
                          child: const Icon(
                            Icons.person_2_outlined,
                            color: Colors.black,
                            size: 32,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Oğuzhan",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        Text(
                          "100",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.yellow,
                          child: Icon(
                            Icons.token_rounded,
                            color: Colors.orange,
                            size: 32,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Material(
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  "Adım",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
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
                                text: _steps),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3.0),
                                child: Row(children: [
                                  Text("Adım"),
                                  Icon(Icons.keyboard_arrow_down)
                                ]),
                              )),
                              Chip(
                                  label: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3.0),
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
                                    SalesData('Jan', 4000),
                                    SalesData('Feb', 5600),
                                    SalesData('Mar', 1200),
                                    SalesData('Apr', 2000),
                                    SalesData('Today', 4200)
                                  ],
                                  xValueMapper: (SalesData sales, _) =>
                                      sales.year,
                                  yValueMapper: (SalesData sales, _) =>
                                      sales.sales)
                            ]),
                        SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
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
