class Customer {
  late String customerId;
  late String customerLastName;
  late String customerFirstName;
  late String customerEmail;
  late String customerPhoneNumber;
  late String customerAddress;
  late String customerCity;
  late String customerStateCode;
  late String customerPostalCode;
  late String customerCountryCode;

  Customer({
    required this.customerId,
    required this.customerLastName,
    required this.customerFirstName,
    required this.customerEmail,
    required this.customerPhoneNumber,
    required this.customerAddress,
    required this.customerCity,
    required this.customerStateCode,
    required this.customerPostalCode,
    this.customerCountryCode = "NG",
  });

  Map<String, dynamic> toMap() => {
        "customerId": customerId,
        "customerLastName": customerLastName,
        "customerFirstName": customerFirstName,
        "customerEmail": customerEmail,
        "customerPhoneNumber": customerPhoneNumber,
        "customerAddress": customerAddress,
        "customerCity": customerCity,
        "customerStateCode": customerStateCode,
        "customerPostalCode": customerPostalCode,
        "customerCountryCode": customerCountryCode,
      };
}
