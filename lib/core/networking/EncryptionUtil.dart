import 'dart:convert';
import 'package:jose/jose.dart';

class EncryptionUtil {
  static String secretKey = "p2bnwyUsk6mFNyW87kAVnnSqhfRwcojGdtS/7TZ8P18=";

  static String makeEncryptOfJson(Map<String, dynamic> jsonObject) {
    var claims = JsonWebTokenClaims.fromJson(jsonObject);
    var builder = JsonWebSignatureBuilder();
    builder.jsonContent = claims.toJson();
    builder.addRecipient(JsonWebKey.fromJson({"kty": "oct", "k": secretKey}),
        algorithm: 'HS256');
    var jws = builder.build();
    return jws.toCompactSerialization();
  }

  static Future<Map<String, dynamic>> makeDecryptOfJson(String str) async {
    var jwe = JsonWebEncryption.fromCompactSerialization(str);
    var jwk = JsonWebKey.fromJson({"kty": "oct", "k": secretKey});
    var keyStore = JsonWebKeyStore()..addKey(jwk);
    var payload = await jwe.getPayload(keyStore);
    Map<String, dynamic> jsonObject = json.decode(payload.stringContent);
    return jsonObject;
  }
}
