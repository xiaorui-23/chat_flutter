import 'package:flutter/material.dart';

/// 获取当前语言环境
/// * 默认 CH
class GetLanguageEnvironment {
  /// 当前语言环境
  static String? _currentLanguageEnv = 'CH';

  /// 当前语言环境
  static String? get currentLanguageEnv => _currentLanguageEnv;

  /// 设置当前语言环境
  static void _setCurrentLanguageEnv(String? languageEnv) =>
      _currentLanguageEnv = languageEnv;

  /// 根据当前语言环境进行转换获取值
  static String getLanguageEnvConvertValue(String value) {
    String newValue = '';
    switch (_currentLanguageEnv) {
      case 'US':
        newValue = _mapInfo['US'][value] ?? value;
        break;
      case 'CH':
      default:
        newValue = value;
        break;
    }

    return newValue;
  }

  /// 获取当前语言环境
  static getCurrentLanguageEnv(context) {
    Locale v = Localizations.localeOf(context);

    // 设置当前语言环境
    _setCurrentLanguageEnv(v.countryCode);
  }
}

/// 当前值对应语言环境对应值
/// * 所有默认值全部为中文

Map<String, dynamic> _mapInfo = {
  'US': {'图片加载失败': 'Image loading failed'}
};
