import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:speak/utils/globals.dart';

class Iconed extends StatefulWidget {
  const Iconed({super.key, required this.icon, required this.callbackUp, required this.callbackDown, this.iconSize = 15});
  final IconData icon;
  final void Function() callbackUp;
  final void Function() callbackDown;
  final double iconSize;
  @override
  State<Iconed> createState() => _IconedState();
}

class _IconedState extends State<Iconed> {
  bool _borderState = false;
  bool _colorState = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressDown: (LongPressDownDetails details) async {
        setState(() => _colorState = true);
        await Future.delayed(300.ms);
        setState(() => _borderState = true);
        widget.callbackDown();
      },
      onLongPressUp: () async {
        setState(() => _colorState = false);
        await Future.delayed(300.ms);
        setState(() => _borderState = false);
        widget.callbackUp();
      },
      onTapUp: (TapUpDetails details) async {
        setState(() => _colorState = false);
        await Future.delayed(500.ms);
        setState(() => _borderState = false);
      },
      onTapDown: (TapDownDetails details) async {
        setState(() => _colorState = true);
        await Future.delayed(300.ms);
        setState(() => _borderState = true);
      },
      child: AnimatedContainer(
        duration: 500.ms,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(border: Border.all(width: 1, color: _borderState ? orange : orange.withOpacity(.6)), shape: BoxShape.circle, color: _colorState ? orange : transparent),
        child: Icon(widget.icon, size: widget.iconSize, color: _colorState ? secondaryColor : white),
      ),
    );
  }
}
