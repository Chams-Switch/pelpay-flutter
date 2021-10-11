import 'customer.dart';

class Transaction {
  late String integrationKey;
  late int amount;
  late String currency;
  late String merchantReference;
  late String narration;
  late String callbackUrl;
  late String productCode;
  late String splitCode;
  late bool shouldTokenise;
  late Map<String, dynamic> customer;
  Transaction(
      {required this.integrationKey,
      required this.amount,
      required this.merchantReference,
      required this.narration,
      required this.customer,
      this.callbackUrl = "",
      this.productCode = "",
      this.currency = "NGN",
      this.splitCode = "",
      this.shouldTokenise = false});

  Map<String, dynamic> toMap() => {
        "integrationKey": integrationKey,
        "amount": amount,
        "merchantReference": merchantReference,
        "narration": narration,
        "customer": customer,
        "callbackUrl": callbackUrl,
        "productCode": productCode,
        "currency": currency,
        "splitCode": splitCode,
        "shouldTokenise": shouldTokenise,
      };
}
