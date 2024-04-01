import 'package:flutter/material.dart';
import 'dart:math';

class DottedLoadingIndicator extends StatefulWidget {
  const DottedLoadingIndicator({super.key});

  @override
  _DottedLoadingIndicatorState createState() => _DottedLoadingIndicatorState();
}

class _DottedLoadingIndicatorState extends State<DottedLoadingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      child: Stack(
        children: List.generate(8, (index) =>
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  return Transform.rotate(
                    angle: index / 8 * 2 * pi,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: const EdgeInsets.all(5.0),
                        width: 5.0,
                        height: 5.0,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity((8 - index - (_controller.value * 8).round()) % 8 / 8),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

