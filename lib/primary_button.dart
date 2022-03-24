import 'package:flutter/material.dart';
import 'package:ussd_sdk/utils/constants.dart';

class PrimaryButton extends StatelessWidget {
  // Our primary button widget [to be reused]
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final bool block;
  final Color color;
  final Color textColor;

  const PrimaryButton({Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.block = false,
    this.color = CustomColor.PRIMARY,
    this.textColor = CustomColor.LIGHT_GREY,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: block ? double.infinity : null,
      child: FlatButton(
        onPressed: onPressed,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
              )
            : FittedBox(
                child: Text(
                  text,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2),
                ),
              ),
        color: color,
      ),
    );
  }
}
