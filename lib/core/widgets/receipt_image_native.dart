import 'dart:io';

import 'package:flutter/material.dart';

Widget receiptImage(
  String path, {
  double? height,
  double? width,
  BoxFit fit = BoxFit.cover,
  ImageErrorWidgetBuilder? errorBuilder,
}) => Image.file(
  File(path),
  height: height,
  width: width,
  fit: fit,
  errorBuilder: errorBuilder,
);
