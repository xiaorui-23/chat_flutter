
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 屏幕适配


/// ScreenUtil 初始化
void screenUtilInit (
    BuildContext context, { 
        Size designSize = const Size(375, 750), 
        bool splitScreenMode = false,
        bool minTextAdapt = false,
        bool scaleByHeight = false,
    }
) => ScreenUtil.init(context, designSize: designSize, splitScreenMode: splitScreenMode, scaleByHeight: scaleByHeight);

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

/// 获取页面边距信息，如：状态栏高度、底部安全区高度等
EdgeInsets getMediaQueryInfo (BuildContext context) => MediaQuery.of(context).padding;
