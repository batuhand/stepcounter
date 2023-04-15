import 'package:flutter/cupertino.dart';
import 'package:untitled/controllers/step_db_controller.dart';
import 'package:untitled/models/StepModel.dart';

class StepProvider extends ChangeNotifier {
  bool loading = false;
  StepModel todaysStep = StepModel();
  List<int> weeklySteps = [];
  StepDbController stepController = StepDbController();

  initStepDB() {
    loading = true;
    stepController.init().then((value) {
      loading = false;
      notifyListeners();
    });
  }

  getWeeklySteps() async {
    loading = true;
    DateTime today = DateTime.now();
    notifyListeners();
    for (var i = 0; i < 7; i++) {
      var result = await stepController
          .getStepsAt(DateTime(today.year, today.month, today.day - i));

      weeklySteps.add(result);
    }
    loading = false;
    notifyListeners();
  }

  updateTodayStep(int stepCount) {
    weeklySteps[0] = weeklySteps[0] + 1;
  }
}
