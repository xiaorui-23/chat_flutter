
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 屏幕适配

/// 初始化
void initScreenUtil (context, {Size designSize = const Size(375, 750), bool splitScreenMode = true, bool minTextAdapt = true, bool scaleByHeight = true}) {
    ScreenUtil.init(
        context,
        designSize: designSize,
        splitScreenMode: splitScreenMode,
        minTextAdapt: minTextAdapt,
        scaleByHeight: scaleByHeight
    );
}

/// 实例
ScreenUtil _screenUtil = ScreenUtil();


/// 宽度
double sw (double width) => _screenUtil.setWidth(width);

/// 高度
double sh (double height) => _screenUtil.setHeight(height);

/// 同高/同宽，比如 四方形
double sz (double size) => sw(size);

/// 字体
double sf (double fontSize) => _screenUtil.setSp(fontSize);

/// 圆角
double sr(double r) => _screenUtil.radius(r);
