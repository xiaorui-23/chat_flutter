
import 'package:flutter/material.dart';
import 'package:chat_flutter/utils/screenutil/screenutil.dart';

/// 头像
class Avatar extends StatefulWidget {
    Avatar({
        super.key,
        this.avatarPath,
        this.defaultAvatarPath,
        this.isAvatarShow = true,
        this.avatarSize,
        this.avatarColor,
        this.avatarTap,
        this.customAvatarWidget
    });

    /// 头像地址
    String? avatarPath;
    /// 默认头像地址
    String? defaultAvatarPath;
    /// 是否展示头像
    bool isAvatarShow;
    /// 默认头像地址
    double? avatarSize;
    /// 默认头像地址
    Color? avatarColor;
    /// 自定义头像盒子
    Widget? customAvatarWidget;
    /// 头像点击回调
    Function()? avatarTap;

    @override
    State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
    
    /// 头像加载失败状态
    bool _avatarErrorStatus = false;

    /// 头像地址处理
    /// * [_avatarPath] 头像地址
    /// * [_defaultAvatarPath] 默认头像地址
    ImageProvider _handlerAvatarPath (String? _avatarPath, String? _defaultAvatarPath) {
        // 当前是否使用默认地址
        bool isUseDefaultAvatarPath = true;
        // 当前地址是否是 assets 地址
        bool isAssetsPath = true;
        // 当前需要使用的地址
        String currentUsePath = _avatarPath ?? _defaultAvatarPath ?? '';

        // 判断当前地址是否使用默认地址
        if (_avatarPath != null){
            isUseDefaultAvatarPath = false;
        }
        
        // 判断地址是否为网络地址
        if (!isUseDefaultAvatarPath) {
            isAssetsPath = !(currentUsePath.startsWith('http://') || currentUsePath.startsWith('https://'));
        }

        //  输出 assets 的 ImageProvider
        if (isAssetsPath) {
            return AssetImage(currentUsePath);
        }

        //  输出 network 的 ImageProvider
        return NetworkImage(currentUsePath);
    }
    
    @override
    Widget build(BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, setState) {
                return widget.isAvatarShow ? GestureDetector(
                    onTap: widget.avatarTap,
                    child: widget.customAvatarWidget ?? Container(
                        width: widget.avatarSize ?? sz(45),
                        height: widget.avatarSize ?? sz(45),
                        decoration: (widget.avatarPath != null || widget.defaultAvatarPath != null || !_avatarErrorStatus) ? BoxDecoration(
                            image:  DecorationImage(
                                fit: BoxFit.cover,
                                image: _handlerAvatarPath (widget.avatarPath, widget.defaultAvatarPath),
                                onError: (exception, stackTrace) {
                                    _avatarErrorStatus = true;

                                    Future.delayed(const Duration(milliseconds: 300), () {
                                        if(mounted) {
                                            setState(() {});
                                        }
                                    });
                                },
                            ),
                            borderRadius: BorderRadius.circular(widget.avatarSize ?? sz(45))
                        ) : null,
                        child: ((widget.avatarPath == null && widget.defaultAvatarPath == null) || _avatarErrorStatus) ? Icon(
                            Icons.account_circle,
                            size: widget.avatarSize ?? sz(45),
                            color: widget.avatarColor,
                        ) : null,
                    ),
                ) : Container();
            }
        );
    }
}