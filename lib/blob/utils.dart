import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:vector_math/vector_math_64.dart';

class Utils {
    static final Matrix4 _matrix = Matrix4.identity();
    static final Random _random = Random();
    static const double maxAmplitude = 8500;
    static const double maxScale = 1.3;

    // 获取一个随机整数
    static int get randomNumber => _random.nextInt(1 << 32) - (1 << 31);

    // 创建渐变着色器
    static Shader createShader(
        double x,
        double y,
        List<Color>? colors, {double? angle,}) {
        return LinearGradient(
            tileMode: TileMode.clamp,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors ??
                [
                    const Color(0xff2BCEFF).withOpacity(0.3),
                    const Color(0xff0976E3).withOpacity(0.3),
                ],
        ).createShader(
            Rect.fromCircle(center: Offset(x, y), radius: 50.0),
        );
    }

    // 转换点坐标
    static Vector4 transformPoint(
        Vector4 point,
        double cX,
        double cY,
        double degree,
    ) {
        _matrix.setIdentity();
        _matrix.translate(cX, cY);
        _matrix.rotateZ(radians(degree));
        _matrix.translate(-cX, -cY);
        return _matrix.transform(point);
    }
}
