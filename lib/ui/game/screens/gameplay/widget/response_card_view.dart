import 'package:appsagainsthumanity/data/features/cards/model/response_card.dart';
import 'package:flutter/material.dart';
import 'package:appsagainsthumanity/internal.dart';

class ResponseCardView extends StatelessWidget {
  final ResponseCard card;
  final Widget child;

  static const textPadding = 20.0;

  ResponseCardView({
    Key key,
    @required this.card,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Material(
        color: AppColors.responseCardBackground,
        shadowColor: AppColors.responseCardBackground,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black12,
            width: 1.0,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        elevation: 4,
        child: Column(
          children: [
            _buildText(context, card.text),
            if (child != null)
              Expanded(
                child: child,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildText(BuildContext context, String text) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.all(textPadding),
      child: Text(
        text,
        style: context.theme.textTheme.headline5.copyWith(
          color: Colors.black87,
        ),
      ),
    );
  }
}

Widget buildResponseCardStack(List<ResponseCard> cards) {
  if (cards.isNotEmpty) {
    var nextCard = cards.first;
    var remaining = cards.sublist(1);
    return ResponseCardView(
      key: ValueKey(nextCard),
      card: nextCard,
      child: remaining.isNotEmpty
        ? buildResponseCardStack(remaining)
        : null,
    );
  } else {
    return null;
  }
}
