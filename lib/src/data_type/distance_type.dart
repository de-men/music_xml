/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/distance-type/
enum DistanceType {
  hyphen,
  beam,
  other,
}

const _distanceTypeMap = {
  'hyphen': DistanceType.hyphen,
  'beam': DistanceType.beam,
};

DistanceType parseDistanceType(String str) =>
    _distanceTypeMap[str] ?? DistanceType.other;
