import 'package:flutter/material.dart';
import 'package:personal_finance_app/constants/constants.dart';
import 'package:personal_finance_app/models/transaction/transactions.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem(
      {super.key, required this.transaction, required this.transactionType});

  final Transactions transaction;
  final String transactionType;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                widget.transactionType == 'expense'
                    ? 'assets/images/expense.png'
                    : 'assets/images/income.png',
                width: 40,
                fit: BoxFit.cover,
                color: widget.transactionType == 'expense'
                    ? Colors.red
                    : Colors.green,
              ),
              sizedBoxWidth(10),
              Expanded(
                child: Text(
                  widget.transaction.description,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  Text(
                    (widget.transactionType == 'expense')
                        ? '-${widget.transaction.amount.toString()} €'
                        : '+${widget.transaction.amount.toString()} €',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: (widget.transactionType == 'expense')
                              ? Colors.red
                              : Colors.green,
                        ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            widget.transaction.date,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }
}
