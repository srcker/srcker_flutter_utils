import 'package:flutter/material.dart';
import 'dart:math' as math show sin, pi, sqrt;

class RippleWave extends StatefulWidget {
    const RippleWave({
        Key? key,
        this.color = Colors.teal,
        this.duration = const Duration(milliseconds: 1500),
        this.repeat = true,
        required this.child,
        this.childTween,
        this.animationController,
    }) : super(key: key);

    /// 波纹的颜色
    final Color color;

    /// 波纹内部的小部件
    final Widget child;

    /// 小部件的 Tween 效果
    final Tween<double>? childTween;

    /// 动画的持续时间
    final Duration duration;

    /// 是否重复播放动画，默认为 true
    final bool repeat;

    /// 可选的动画控制器，用于手动启动或停止动画
    final AnimationController? animationController;

    @override
    RippleWaveState createState() => RippleWaveState();
}

class RippleWaveState extends State<RippleWave> with TickerProviderStateMixin {
    late AnimationController _controller;

    @override
    void initState() {
        super.initState();
        _controller = widget.animationController ?? AnimationController( duration: widget.duration, vsync: this);
        if (widget.repeat) {
            _controller.repeat();
        } else if (widget.animationController == null) {
            _controller.forward();
            Future.delayed(widget.duration).then((value) => _controller.stop());
        }
    }

    @override
    void dispose() {
        _controller.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return CustomPaint(
            painter: _RipplePainter(
                _controller,
                color: widget.color,
            ),
            child: Center(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            gradient: RadialGradient(
                                colors: <Color>[
                                    widget.color,
                                    Colors.transparent,
                                ],
                            ),
                        ),
                        child: ScaleTransition(
                            scale: widget.childTween != null? widget.childTween!.animate(
                                CurvedAnimation(
                                    parent: _controller,
                                    curve: _CurveWave(),
                                ),
                            ): Tween(begin: 0.9, end: 1.0).animate(
                                CurvedAnimation(
                                    parent: _controller,
                                    curve: _CurveWave(),
                                ),
                            ),
                            child: widget.child,
                        ),
                    ),
                ),
            ),
        );
    }
}

class _CurveWave extends Curve {
    @override
    double transform(double t) {
        if (t == 0 || t == 1) {
            return t;
        }
        return math.sin(t * math.pi);
    }
}

class _RipplePainter extends CustomPainter {

    _RipplePainter(this.animation, { required this.color}) : super(repaint: animation);
    final Color color;
    final Animation<double> animation;

    void circle(Canvas canvas, Rect rect, double value) {
        final double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
        final Color newColor = color.withOpacity(opacity);
        final double size = rect.width / 2;
        final double area = size * size;
        final double radius = math.sqrt(area * value / 4);
        final Paint paint = Paint()..color = newColor;
        canvas.drawCircle(rect.center, radius, paint,);
    }

    @override
    void paint(Canvas canvas, Size size) {
        final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height,);
        for (int wave = 0; wave <= 5; wave++) {
            circle(canvas, rect, wave + animation.value);
        }
    }

    @override
    bool shouldRepaint(_RipplePainter oldDelegate) => true;
}
