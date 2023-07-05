import 'package:flutter/material.dart';
import 'package:maps/utils/button.dart';

class MyButton extends StatefulWidget {
  const MyButton(
      {super.key,
      required label,
      buttonType = ButtonType.primary,
      required VoidCallback function,
      required icon})
      : _label = label,
        _buttonType = buttonType,
        _function = function,
        _icon = icon;
  final String _label;
  final ButtonType _buttonType;
  final VoidCallback _function;
  final IconData _icon;
  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
            widget._buttonType == ButtonType.primary
                ? Theme.of(context).primaryColor
                : Theme.of(context).primaryColorLight),
        minimumSize: MaterialStateProperty.all<Size>(
          Size(double.infinity, 48),
        ),
        foregroundColor: MaterialStateProperty.all(
          widget._buttonType == ButtonType.primary
              ? Colors.white
              : Theme.of(context).primaryColor,
        ),
      ),
      onPressed: () {
        widget._function();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget._icon),
          SizedBox(
            width: 10,
          ),
          Text(widget._label),
        ],
      ),
    );
  }
}
