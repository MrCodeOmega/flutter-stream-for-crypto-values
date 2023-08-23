class StreamData {
  String name;
  String price;
  String image;

  StreamData.fromJson(Map<String, dynamic> json)
      : name = json["symbol"],
        price = json["lastPrice"],
        image = json["lowPrice"];

  Map<String, dynamic> toJson() =>
      {"symbol": name, "lastPrice": price, "lowPrice": image};
}
