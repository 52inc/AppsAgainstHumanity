import 'package:flutter/material.dart';
import 'package:appsagainsthumanity/internal.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback onPressed;

  const AuthButton({
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  AuthButton.withIcon({
    required this.text,
    required IconData iconData,
    required this.onPressed,
  }) : icon = Icon(
          iconData,
          color: Colors.black87,
        );

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.button,
      color: Colors.white,
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          alignment: Alignment.center,
          child: Row(
            children: <Widget>[
              icon,
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: context.theme.textTheme.subtitle1!.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
