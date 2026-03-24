/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/start-stop-continue/
enum StartStopContinue {
  start,
  stop,
  continueValue,
}

const _startStopContinueMap = {
  'start': StartStopContinue.start,
  'stop': StartStopContinue.stop,
  'continue': StartStopContinue.continueValue,
};

StartStopContinue parseStartStopContinue(String str) =>
    _startStopContinueMap[str]!;

const startStopContinueToString = {
  StartStopContinue.start: 'start',
  StartStopContinue.stop: 'stop',
  StartStopContinue.continueValue: 'continue',
};
