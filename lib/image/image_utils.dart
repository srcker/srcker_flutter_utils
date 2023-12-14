	import 'dart:convert';
	import 'dart:io';
	import 'dart:typed_data';
	import 'package:flutter/services.dart';
	import 'package:flutter/material.dart';

/// 图片工具类
class ImageUtils {
	///将base64流转化为图片
	static MemoryImage base64ToImage(String base64String) {
		return MemoryImage(
		base64Decode(base64String),
		);
	}

	///将base64流转化为Uint8List对象
	static Uint8List base64ToUnit8list(String base64String) {
		return base64Decode(base64String);
	}

	///将图片file转化为base64
	static String fileToBase64(File imgFile) {
		return base64Encode(imgFile.readAsBytesSync());
	}


	///将asset图片转化为base64
	Future assetImageToBase64(String path) async {
		ByteData bytes = await rootBundle.load(path);
		return base64.encode(Uint8List.view(bytes.buffer));
	}

}
