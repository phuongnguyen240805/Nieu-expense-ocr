import 'dart:convert';

import 'package:flutter/material.dart';

Widget receiptImage(
  String path, {
  double? height,
  double? width,
  BoxFit fit = BoxFit.cover,
  ImageErrorWidgetBuilder? errorBuilder,
}) {
  if (path.startsWith('data:')) {
    return Image.memory(
      base64Decode(path.substring(path.indexOf(',') + 1)),
      height: height,
      width: width,
      fit: fit,
      errorBuilder: errorBuilder,
    );
  }
  return Image.network(
    path,
    height: height,
    width: width,
    fit: fit,
    errorBuilder: errorBuilder,
  );
}
