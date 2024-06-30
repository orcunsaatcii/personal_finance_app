class Transactions {
  Transactions({
    required this.transactionId,
    required this.userId,
    required this.categoryId,
    required this.amount,
    required this.date,
    required this.description,
  });

  int transactionId;
  int userId;
  int categoryId;
  double amount;
  String date;
  String description;
}
