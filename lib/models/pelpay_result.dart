class PelpayResult {
  late bool isTransactionSuccessful;

  late String? adviceReference;

  late String? errorMessage;

  PelpayResult(
      {required this.isTransactionSuccessful,
      required this.adviceReference,
      required this.errorMessage});
}
