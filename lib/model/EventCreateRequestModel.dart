class EventCreateRequestModel {
  final String eventTitle;
  final String? eventDescription;
  final String? priority;
  final String startTime;
  final String endTime;
  final bool? recurring;

  EventCreateRequestModel({
    required this.eventTitle,
    this.eventDescription,
    this.priority,
    required this.startTime,
    required this.endTime,
    this.recurring,
  });

  Map<String, dynamic> toJson() {
    return {
      'eventTitle': eventTitle,
      'eventDescription': eventDescription,
      'priority': priority,
      'startTime': startTime,
      'endTime': endTime,
      'recurring': recurring,
    };
  }
}
