import 'dart:io';

import 'package:music_xml/music_xml.dart';
import 'package:music_xml/src/data_types/font_weight.dart';
import 'package:music_xml/src/data_types/left_center_right.dart';
import 'package:music_xml/src/data_types/valign.dart';
import 'package:music_xml/src/data_types/xlink.dart';
import 'package:music_xml/src/element/credit.dart';
import 'package:music_xml/src/element/credit_type.dart';
import 'package:test/test.dart';

// https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/credit-element/
final asset = File('test/assets/credit-element.xml');

void main() {
  test('<credit> with credit-type and credit-words', () {
    final document = MusicXmlDocument.parse(asset.readAsStringSync());

    final credits = document.score.credits;
    expect(credits.length, 2);

    final title = credits[0];
    expect(title.page, 1);
    expect(title.creditTypes.first.creditTypeValue, CreditTypeValue.title);
    expect(title.creditTypes.first.content, 'title');
    expect(title.creditWords.first.content, 'Sonata, Op. 27, No. 2');
    expect(title.creditWords.first.defaultX, 683);
    expect(title.creditWords.first.defaultY, 1725);
    expect(title.creditWords.first.fontSize!.numericSize, 24);
    expect(title.creditWords.first.fontWeight, FontWeight.bold);
    expect(title.creditWords.first.halign, LeftCenterRight.center);
    expect(title.creditWords.first.valign, Valign.top);

    final composer = credits[1];
    expect(
        composer.creditTypes.first.creditTypeValue, CreditTypeValue.composer);
    expect(composer.creditWords.first.content, 'Ludwig van Beethoven');
    expect(composer.creditWords.first.halign, LeftCenterRight.right);
  });

  // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/credit-image-element/
  test('<credit-image>', () {
    final imageAsset = File('test/assets/credit-image-element.xml');
    final document = MusicXmlDocument.parse(imageAsset.readAsStringSync());

    final credit = document.score.credits.single;
    expect(credit.page, 1);
    expect(credit.isImageCredit, isTrue);
    expect(credit.creditImage!.source, 'images/mmlogo.png');
    expect(credit.creditImage!.type, 'image.png');
    expect(credit.creditImage!.defaultX, 572);
    expect(credit.creditImage!.defaultY, 96);
  });

  // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/credit-symbol-element/
  test('<credit-symbol> mixed with credit-words', () {
    final symbolAsset = File('test/assets/credit-symbol-element.xml');
    final document = MusicXmlDocument.parse(symbolAsset.readAsStringSync());

    final credit = document.score.credits.single;
    expect(credit.isImageCredit, isFalse);

    expect(credit.contents.length, 5);
    expect(credit.contents[0], isA<CreditWordsContent>());
    expect((credit.contents[0] as CreditWordsContent).creditWords.content,
        'Practice with');
    expect(credit.contents[1], isA<CreditSymbolContent>());
    expect((credit.contents[1] as CreditSymbolContent).creditSymbol.content,
        'fClef');
    expect(
        (credit.contents[2] as CreditWordsContent).creditWords.content, 'and');
    expect((credit.contents[3] as CreditSymbolContent).creditSymbol.content,
        'cClef');
    expect((credit.contents[4] as CreditWordsContent).creditWords.content,
        'clefs as well.');

    expect(credit.creditWords.length, 3);
    expect(credit.creditSymbols.length, 2);
  });

  // https://www.w3.org/2021/06/musicxml40/musicxml-reference/examples/link-element/
  test('<link> in credit', () {
    final linkAsset = File('test/assets/link-element.xml');
    final document = MusicXmlDocument.parse(linkAsset.readAsStringSync());

    final credit = document.score.credits.single;
    expect(credit.links.length, 1);
    expect(credit.links.first.href, 'https://www.w3.org/');
    expect(credit.links.first.show, XLinkShow.newWindow);
    expect(credit.creditWords.first.content, 'Visit W3C');
  });

  test('score without <credit> has empty credits list', () {
    final noCredits = File('test/assets/pitch-element.xml');
    final document = MusicXmlDocument.parse(noCredits.readAsStringSync());

    expect(document.score.credits, isEmpty);
  });
}
