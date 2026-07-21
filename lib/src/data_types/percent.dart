/// A percentage from 0 to 100.
///
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/percent/
class Percent {
  final double value;

  Percent(this.value) : assert(value >= 0 && value <= 100);

  factory Percent.parse(String text) => Percent(double.parse(text));

  @override
  String toString() => '$value';

  @override
  bool operator ==(Object other) => other is Percent && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
