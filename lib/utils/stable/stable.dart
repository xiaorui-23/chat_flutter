
import 'dart:async';

/// 类型
typedef FnType = void Function();

/// 防抖/节流 工具方法
class Stable {
    static const int _delay = 300;
    static Timer? _timer;
    
    /// 防抖
    /// * [fn] 执行的回调
    /// * [delay] 时间。默认：300。单位：ms
    static void debounce(FnType fn, {int? delay}) {

        if (_timer != null) {
            _timer!.cancel();
            _timer = null;
        }

        _timer = Timer(Duration(milliseconds: delay ?? _delay), fn);
    }
}
