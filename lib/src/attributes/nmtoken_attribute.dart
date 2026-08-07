import '../data_types/nmtoken.dart';
import 'token_attribute.dart';

/// An attribute whose value is an [NmToken], such as the `number` of a
/// `<lyric>`.
class NmTokenAttr extends TokenAttr {
  final NmToken token;

  NmTokenAttr(String name, this.token) : super(name, token.value);

  factory NmTokenAttr.parse(String name, String value) =>
      NmTokenAttr(name, NmToken(value));
}
