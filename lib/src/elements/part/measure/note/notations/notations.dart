import 'package:xml/xml.dart';

import '../../../../../local.dart';
import 'accidental_mark.dart';
import 'articulations.dart';
import 'dynamics.dart';
import 'fermata.dart';
import 'ornaments.dart';
import 'slur.dart';
import 'technical.dart';
import 'tied.dart';
import 'tuplet.dart';

/// https://www.w3.org/2021/06/musicxml40/musicxml-reference/elements/notations/
class Notations extends XmlElement {
  // TODO: support attributes: id, print-object
  // TODO: support children: glissando, slide, arpeggiate, non-arpeggiate,
  //       other-notation, footnote, level
  final List<Tied> tieds;
  final List<Slur> slurs;
  final List<Tuplet> tuplets;
  final List<Fermata> fermatas;
  final List<Articulations> articulations;
  final List<Ornaments> ornaments;
  final List<Dynamics> dynamics;
  final List<Technical> technicals;
  final List<AccidentalMark> accidentalMarks;

  factory Notations.parse(XmlElement element) {
    final tieds = <Tied>[];
    final slurs = <Slur>[];
    final tuplets = <Tuplet>[];
    final fermatas = <Fermata>[];
    final articulations = <Articulations>[];
    final ornaments = <Ornaments>[];
    final dynamics = <Dynamics>[];
    final technicals = <Technical>[];
    final accidentalMarks = <AccidentalMark>[];

    element.childElements.forEach((e) {
      switch (e.name.local) {
        case Local.tied:
          tieds.add(Tied.parse(e));
          break;
        case Local.slur:
          slurs.add(Slur.parse(e));
          break;
        case Local.tuplet:
          tuplets.add(Tuplet.parse(e));
          break;
        case Local.fermata:
          fermatas.add(Fermata.parse(e));
          break;
        case Local.articulations:
          articulations.add(Articulations.parse(e));
          break;
        case Local.ornaments:
          ornaments.add(Ornaments.parse(e));
          break;
        case Local.dynamics:
          dynamics.add(Dynamics.parse(e));
          break;
        case Local.technical:
          technicals.add(Technical.parse(e));
          break;
        case Local.accidentalMark:
          accidentalMarks.add(AccidentalMark.parse(e));
          break;
      }
    });

    return Notations(
      tieds: tieds,
      slurs: slurs,
      tuplets: tuplets,
      fermatas: fermatas,
      articulations: articulations,
      ornaments: ornaments,
      dynamics: dynamics,
      technicals: technicals,
      accidentalMarks: accidentalMarks,
    );
  }

  Notations({
    this.tieds = const [],
    this.slurs = const [],
    this.tuplets = const [],
    this.fermatas = const [],
    this.articulations = const [],
    this.ornaments = const [],
    this.dynamics = const [],
    this.technicals = const [],
    this.accidentalMarks = const [],
  }) : super.tag(
          Local.notations,
          children: [
            ...tieds,
            ...slurs,
            ...tuplets,
            ...fermatas,
            ...articulations,
            ...ornaments,
            ...dynamics,
            ...technicals,
            ...accidentalMarks,
          ],
        );
}
