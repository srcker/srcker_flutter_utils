import 'package:flutter/material.dart';
import 'package:srcker_utils/blob/wave_drawable.dart';
import 'package:srcker_utils/blob/wave_paint.dart';

class WaveBlob extends StatefulWidget {
    // 子部件
    final Widget child;

    /// 波浪的缩放。仅在 autoScale 设置为 false 时起作用
    final double scale;

    /// 波浪动画的速度。介于 1.0 到 10.0 之间
    final double speed;

    /// 波浪的振幅。介于 0.0 到 8500.0 之间
    final double amplitude;

    /// 波浪的数量。介于 1 到 5 之间
    final int blobCount;

    /// 如果设置为 true，则波浪会自动缩放。默认设置为 true
    final bool autoScale;

    /// 设置为 true 以在中心圆上绘制波浪
    final bool overCircle;

    /// 中心圆的状态
    final bool centerCircle;

    /// 波浪的渐变颜色
    final List<Color>? colors;

    /// 中心圆的颜色。为梯度设置两种或更多颜色
    final List<Color>? circleColors;

    const WaveBlob({
        super.key,
        required this.child,
        this.scale = 1.0,
        this.speed = 8.6,
        this.amplitude = 4250.0,
        this.blobCount = 2,
        this.autoScale = true,
        this.overCircle = true,
        this.centerCircle = true,
        this.circleColors,
        this.colors,
    });

    @override
    State<WaveBlob> createState() => _WaveBlobState();
}

class _WaveBlobState extends State<WaveBlob> {
    List<WaveDrawable> blobs = [];

    @override
    void initState() {
        super.initState();

        var length = widget.blobCount > 5 ? 5 : widget.blobCount;
        for (int i = 0; i < length; i++) {
            blobs.add(WaveDrawable(8 + i));
        }
    }

    @override
    Widget build(BuildContext context) {
        return LayoutBuilder(
            builder: (context, constraints) {
                bool hasInfiniteDimension = (constraints.maxWidth == double.infinity || constraints.maxHeight == double.infinity);

                if (hasInfiniteDimension) {
                    ErrorWidget.builder = (error) => Container();
                    throw ("Can't get Infinite width or height. Please set dimensions for BlobWave widget");
                }

                return CustomPaint(
                    painter: WavePaint(
                        waves: blobs,
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        scale: widget.scale,
                        amplitude: widget.amplitude,
                        autoScale: widget.autoScale,
                        overCircle: widget.overCircle,
                        centerCircle: widget.centerCircle,
                        circleColors: widget.circleColors,
                        colors: widget.colors,
                        speed: widget.speed,
                    ),
                    child: widget.child,
                );
            },
        );
    }
}
