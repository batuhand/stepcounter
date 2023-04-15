class StepModel {
  int? stepCount;
  int? date;

  StepModel({this.stepCount, this.date});

  StepModel.fromJson(Map<String, dynamic> json) {
    stepCount = json['stepCount'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stepCount'] = this.stepCount;
    data['date'] = this.date;
    return data;
  }
}