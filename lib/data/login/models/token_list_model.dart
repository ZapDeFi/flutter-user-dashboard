import 'dart:convert';

class TokenListModel {
  TokenListModel({
    required this.tokens,
  });

  final List<TokensModel> tokens;

  factory TokenListModel.fromJson(String str) =>
      TokenListModel.fromMap(json.decode(str) as Map<String, dynamic>);

  factory TokenListModel.fromMap(Map<String, dynamic> json) => TokenListModel(
          tokens: List<TokensModel>.from(
        (json["tokens"] as List?)
                ?.cast<Map<String, dynamic>>()
                .map((x) => TokensModel.fromMap(x)) ??
            [],
      ));

  Map<String, dynamic> toMap() => {
        'tokens': List<dynamic>.from(tokens.map((x) => x.toMap())),
      };
}

class TokensModel {
  TokensModel({
    required this.chainId,
    required this.name,
    required this.address,
    required this.decimals,
    required this.symbol,
    required this.logoURI,
  });

  final int chainId;
  final String name;
  final String address;
  final int decimals;
  final String symbol;
  final String logoURI;

  factory TokensModel.fromJson(String str) =>
      TokensModel.fromMap(json.decode(str) as Map<String, dynamic>);

  factory TokensModel.fromMap(Map<String, dynamic> json) => TokensModel(
        chainId: json['chainId'] as int,
        name: json['name'] as String,
        address: json['address'] as String,
        decimals: json['decimals'] as int,
        symbol: json['symbol'] as String,
        logoURI: json['logoURI'] as String,
      );

  Map<String, dynamic> toMap() => {
        'chainId': chainId,
        'name': name,
        'address': address,
        'decimals': decimals,
        'symbol': symbol,
        'logoURI': logoURI,
      };
}
