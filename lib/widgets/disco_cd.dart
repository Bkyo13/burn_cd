import 'package:flutter/material.dart';

/// Un CD que gira mientras [girando] sea true.
class DiscoCd extends StatefulWidget {
  final double tamano;
  final bool girando;

  const DiscoCd({super.key, required this.tamano, this.girando = false});

  @override
  State<DiscoCd> createState() => _DiscoCdState();
}

class _DiscoCdState extends State<DiscoCd> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    if (widget.girando) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant DiscoCd oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.girando && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.girando && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hueco = widget.tamano * 0.22;
    return RotationTransition(
      turns: _controller,
      child: Container(
        width: widget.tamano,
        height: widget.tamano,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: SweepGradient(
            colors: [
              Color(0xFFB0BEC5),
              Color(0xFFE1BEE7),
              Color(0xFF80DEEA),
              Color(0xFFFFF59D),
              Color(0xFFF8BBD0),
              Color(0xFFB0BEC5),
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Container(
          width: hueco,
          height: hueco,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF0D0D1A),
            border: Border.all(color: Colors.white54, width: 2),
          ),
        ),
      ),
    );
  }
}
