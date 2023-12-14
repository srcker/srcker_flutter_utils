import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:srcker_utils/blob/wave_drawable.dart';

// 自定义绘制器，用于绘制波浪效果的动画
class WavePaint extends CustomPainter {
    final List<WaveDrawable> waves; // 波浪列表
    final double height; // 绘制区域高度
    final double width; // 绘制区域宽度
    final double scale; // 缩放比例
    final double speed; // 波浪移动速度
    final double amplitude; // 波浪振幅
    final bool autoScale; // 是否自动缩放
    final bool overCircle; // 是否在圆上方显示波浪
    final bool centerCircle; // 是否在圆中心显示波浪
    final List<Color>? colors; // 波浪颜色
    final List<Color>? circleColors; // 圆的颜色

    // 构造函数，初始化各种参数
    WavePaint({
        required this.waves,
        required this.colors,
        required this.width,
        required this.height,
        required this.scale,
        required this.speed,
        required this.amplitude,
        required this.autoScale,
        required this.overCircle,
        required this.centerCircle,
        required this.circleColors,
    });

    // 实现绘制逻辑
    @override
    void paint(Canvas canvas, Size size) {
        Paint cPaint = Paint()..style = PaintingStyle.fill; // 圆的绘制画笔
        Paint bPaint = Paint()..style = PaintingStyle.fill; // 波浪的绘制画笔

        double cX = width / 2; // 圆心横坐标
        double cY = height / 2; // 圆心纵坐标

        // 设置圆的颜色
        if (circleColors == null) {
            cPaint.color = Colors.blue;
        } else if (circleColors!.isEmpty) {
            cPaint.color = Colors.blue;
        } else if (circleColors!.length == 1) {
            cPaint.color = circleColors![0];
        } else {
            cPaint.shader = ui.Gradient.linear(
                const Offset(0.0, 0.0),
                Offset(width, height),
                circleColors!,
            );
        }

        // 如果需要在圆上方显示波浪，则先绘制圆
        if (centerCircle && overCircle) {
            canvas.save();
            canvas.drawCircle(Offset(cX, cY), waves[0].minRadius, cPaint);
            canvas.restore();
        }

        // 遍历波浪列表，设置各种属性并绘制波浪
        for (WaveDrawable wave in waves) {
            // 设置波浪的最大和最小半径
            if (wave.maxRadius < 0) {
                double max = width / 2 / 1.25;
                wave.setMaxRadius(max);
            }
            if (wave.minRadius < 0) {
                double min = width / 2 / 1.5;
                wave.setMinRadius(min);
            }

            wave.setAmplitude(amplitude); // 设置波浪振幅
            wave.setScale(scale); // 设置波浪缩放比例
            wave.setMaxSpeed(speed); // 设置波浪最大速度
            wave.setAutoScale(autoScale); // 设置是否自动缩放

            // 设置波浪颜色
            if (colors != null) {
                wave.setColors(colors!);
            }

            canvas.save();
            wave.draw(canvas, bPaint, Size(cX, cY)); // 绘制波浪
            canvas.restore();
        }

        // 如果需要在圆中心显示波浪，则绘制圆
        if (centerCircle && !overCircle) {
            canvas.save();
            canvas.drawCircle(Offset(cX, cY), waves[0].minRadius, cPaint);
            canvas.restore();
        }
    }

    // 是否需要重新绘制
    @override
    bool shouldRepaint(covariant CustomPainter oldDelegate) {
        return true;
    }
}
