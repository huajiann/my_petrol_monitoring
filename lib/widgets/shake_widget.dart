import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

/// A generic widget that applies a horizontal shake animation to its child.
///
/// Wrap any widget with [ShakeWidget] and call [ShakeWidgetState.shake()]
/// to trigger the animation, or use [autoShake] to shake on mount.
/// Use [repeatInterval] to repeat the shake periodically.
class ShakeWidget extends StatefulWidget {
  final Widget child;
  final double shakeOffset;
  final int shakeCount;
  final Duration duration;
  final bool autoShake;
  final Duration autoShakeDelay;
  final Duration? repeatInterval;

  const ShakeWidget({
    super.key,
    required this.child,
    this.shakeOffset = 3.0,
    this.shakeCount = 3,
    this.duration = const Duration(milliseconds: 500),
    this.autoShake = false,
    this.autoShakeDelay = Duration.zero,
    this.repeatInterval,
  });

  @override
  ShakeWidgetState createState() => ShakeWidgetState();
}

class ShakeWidgetState extends State<ShakeWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _offsetAnimation;
  Timer? _repeatTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _offsetAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.autoShake) {
      Future.delayed(widget.autoShakeDelay, () {
        if (mounted) {
          shake();
          _startRepeatTimer();
        }
      });
    }
  }

  @override
  void didUpdateWidget(ShakeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.autoShake && widget.repeatInterval != null && _repeatTimer == null) {
      _startRepeatTimer();
    } else if (!widget.autoShake || widget.repeatInterval == null) {
      _cancelRepeatTimer();
    }
  }

  void _startRepeatTimer() {
    _cancelRepeatTimer();
    if (widget.repeatInterval != null) {
      _repeatTimer = Timer.periodic(widget.repeatInterval!, (_) {
        if (mounted) shake();
      });
    }
  }

  void _cancelRepeatTimer() {
    _repeatTimer?.cancel();
    _repeatTimer = null;
  }

  @override
  void dispose() {
    _cancelRepeatTimer();
    _controller.dispose();
    super.dispose();
  }

  /// Trigger the shake animation programmatically.
  void shake() {
    _controller.forward(from: 0.0);
  }

  double _shakeOffset(double progress) {
    return sin(progress * pi * 2 * widget.shakeCount) * widget.shakeOffset;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeOffset(_offsetAnimation.value), 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
