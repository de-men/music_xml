/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/data-types/step/
enum Step {
  A,
  B,
  C,
  D,
  E,
  F,
  G,
}

Step parseStep(String str) =>
    Step.values.firstWhere((e) => e.toString() == 'Step.$str');
