import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  const InputWidget({
    Key? key,
    required this.validator,
    required this.label,
    this.inputAction = TextInputAction.next,
    this.inputType = TextInputType.text,
    this.obscure = false,
    this.readOnly = false,
    required this.onSaved,
    // ignore: avoid_types_as_parameter_names
    this.initialValue,
    this.padding,
    this.maxLines = 1,
  }) : super(key: key);

  final String? Function(String?)? validator;
  final String label;
  final TextInputAction inputAction;
  final TextInputType inputType;
  final bool obscure;
  final bool readOnly;
  final void Function(dynamic) onSaved;
  final dynamic initialValue;
  final dynamic padding;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      obscureText: obscure,
      readOnly: readOnly,
      maxLines: maxLines,
      textInputAction: TextInputAction.next,
      keyboardType: inputType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 17),
        fillColor: Colors.white,
        labelStyle: const TextStyle(color: Color(0xff718096), fontSize: 18),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
      onSaved: onSaved,
      onChanged: (_) {},
    );
  }
}
