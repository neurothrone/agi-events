import 'package:flutter/material.dart';

class RippleAnimation extends StatefulWidget {
  const RippleAnimation({
    super.key,
    required this.color,
    required this.child,
  });

  final Color color;
  final Widget child;

  @override
  State<RippleAnimation> createState() => _RippleAnimationState();
}

class _RippleAnimationState extends State<RippleAnimation>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAnimationController();
  }

  void _initializeAnimationController() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    } else {
      _controller.stop();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double radiusMultiplier =
        MediaQuery.orientationOf(context) == Orientation.portrait ? 0.4 : 0.2;

    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: RipplePainter(
                color: widget.color,
                progress: _controller.value,
                radiusMultiplier: radiusMultiplier,
              ),
              child: Container(),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

class RipplePainter extends CustomPainter {
  RipplePainter({
    required this.progress,
    required this.color,
    required this.radiusMultiplier,
  });

  final double progress;
  final Color color;
  final double radiusMultiplier;

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width * radiusMultiplier * progress;

    final Paint paint = Paint()
      ..color = color.withAlpha((255 * (1 - progress)).toInt())
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      radius,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant RipplePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
