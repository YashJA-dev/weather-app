import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:weather/configs/app_colors.dart';

class AdaptiveCircularLoading extends StatelessWidget {
  final double? size;
  final Color? color;

  const AdaptiveCircularLoading({Key? key, this.size, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Platform.isIOS
          ? CupertinoActivityIndicator(
              radius: size ?? 15,
              color: AppColors.white,
            )
          : CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(color ?? AppColors.primary),
              strokeWidth: size != null ? size! / 10 : 4.0,
            ),
    );
  }
}
