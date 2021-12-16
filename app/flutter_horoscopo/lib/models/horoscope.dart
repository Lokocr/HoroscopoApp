class Horoscope {
  // Create all props.
  // final String horoscope;
  // final String date;
  // final String sign;
  final String date_range;
  final String current_date;
  final String description;
  final String compatibility;
  final String mood;
  final String color;
  final String lucky_number;
  final String lucky_time;
  late String sign;

  // Create the constructor.
  Horoscope({
    // @required this.horoscope,
    // @required this.date,
    // @required this.sign,
    required this.date_range,
    required this.current_date,
    required this.compatibility,
    required this.color,
    required this.lucky_number,
    required this.lucky_time,
    required this.description,
    required this.mood,
    sign,
  });

  factory Horoscope.fromJson(Map<String, dynamic> json) {
    return Horoscope(
      date_range: json['date_range'],
      current_date: json['current_date'],
      compatibility: json['compatibility'],
      color: json['color'],
      lucky_number: json['lucky_number'],
      lucky_time: json['lucky_time'],
      description: json['description'],
      mood: json['mood'],
    );
  }
}
