import 'dart:ui';

import 'package:flutter/material.dart';

class ColorUtils {



	static Color hexToColor(String color) {
		if (color == null || color.length != 7 || int.tryParse(color.substring(1, 7), radix: 16) == null) {
			return Colors.black;
		}
		var parse = int.parse(color.substring(1, 7), radix: 16);
		var hexColor = Color(parse + 0xFF000000);
		return hexColor;
	}



}
