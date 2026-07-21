/// A rotation in degrees, from -180 to 180.
///
/// Used for stereo pan and other circular positions.
/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/rotation-degrees/
class RotationDegrees {
  final double value;

  RotationDegrees(this.value) : assert(value >= -180 && value <= 180);

  factory RotationDegrees.parse(String text) =>
      RotationDegrees(double.parse(text));

  @override
  String toString() => '$value';

  @override
  bool operator ==(Object other) =>
      other is RotationDegrees && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
