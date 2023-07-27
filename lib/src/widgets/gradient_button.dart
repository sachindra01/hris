import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final double width;
  final double elevation;
  final Color color;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Gradient? linearGradient;
  final Color? fontColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 50,
    this.width = 200,
    this.elevation = 0.0,
    this.color = Colors.deepPurple,
    this.borderRadius = 4,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.linearGradient,
    this.fontColor,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: linearGradient ??
          const LinearGradient(
            // colors: [Colors.deepPurple, Colors.purple],
            // begin: Alignment.topCenter,
            // end: Alignment.bottomCenter,
            colors: [
            Color.fromARGB(255, 230, 149, 45),
            Color.fromARGB(255, 223, 104, 144),
              ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: elevation,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          animationDuration: const Duration(milliseconds: 200),
          shadowColor: Colors.transparent,
          minimumSize: Size(width, height),
          maximumSize: Size(width, height),
          side: BorderSide.none,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: fontColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
