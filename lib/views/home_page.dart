import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:untitled/models/StepModel.dart';
import 'package:untitled/providers/step_provider.dart';
import 'package:untitled/widgets/achievement_bar.dart';
import 'package:untitled/widgets/reeder_icon_data.dart';
import 'package:untitled/widgets/step_box.dart';
import 'package:vibration/vibration.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<StepProvider>(context, listen: false).initStepDB();

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
                Provider.of<StepProvider>(context).loading
                    ? CircularProgressIndicator()
                    : StepBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
