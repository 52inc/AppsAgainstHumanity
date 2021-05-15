// import 'package:appsagainsthumanity/app.dart';
import 'package:flutter/material.dart';
import 'package:appsagainsthumanity/internal.dart';

class HomeOutlineButton extends StatelessWidget {
  final Widget icon;
  final String text;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onTap;

  HomeOutlineButton({
    @required this.icon,
    @required this.text,
    this.textColor = AppColors.primaryVariant,
    this.borderColor = AppColors.primaryVariant,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Material(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
          side: BorderSide(
            color: borderColor,
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Container(
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  child: icon,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8, right: 24),
                  child: Text(
                    text,
                    style: context.theme.textTheme.subtitle2.copyWith(
                      color: textColor,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
