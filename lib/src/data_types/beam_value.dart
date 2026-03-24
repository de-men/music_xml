/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/beam-value/
enum BeamValue {
  begin,
  continueBeam,
  end,
  forwardHook,
  backwardHook,
}

const _beamValueMap = {
  'begin': BeamValue.begin,
  'continue': BeamValue.continueBeam,
  'end': BeamValue.end,
  'forward hook': BeamValue.forwardHook,
  'backward hook': BeamValue.backwardHook,
};

BeamValue parseBeamValue(String str) => _beamValueMap[str]!;

const beamValueToString = {
  BeamValue.begin: 'begin',
  BeamValue.continueBeam: 'continue',
  BeamValue.end: 'end',
  BeamValue.forwardHook: 'forward hook',
  BeamValue.backwardHook: 'backward hook',
};
