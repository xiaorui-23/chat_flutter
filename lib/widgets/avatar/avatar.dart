
import 'package:flutter/material.dart';
import 'package:chat_flutter/utils/screenutil/screenutil.dart';

/// 头像
class Avatar extends StatelessWidget {

    /// 头像地址
    final String? avatarPath;
    /// 默认头像地址
    final String? defaultAvatarPath;
    /// 是否展示头像
    final bool isAvatarShow;
    /// 默认头像地址
    final double? avatarSize;
    /// 默认头像地址
    final Color? avatarColor;
    /// 自定义头像盒子
    final Widget? customAvatarWidget;
    /// 头像点击回调
    final void Function()? avatarTap;

    const Avatar({
        super.key,
        this.avatarPath,
        this.defaultAvatarPath,
        this.isAvatarShow = true,
        this.avatarSize,
        this.avatarColor,
        this.avatarTap,
        this.customAvatarWidget
    });

    /// 头像地址处理
    /// * [_avatarPath] 头像地址
    /// * [_defaultAvatarPath] 默认头像地址
    ImageProvider _handlerAvatarPath (String? tempAvatarPath, String? tampDefaultAvatarPath) {
        // 当前是否使用默认地址
        bool isUseDefaultAvatarPath = true;
        // 当前地址是否是 assets 地址
        bool isAssetsPath = true;
        // 当前需要使用的地址
        String currentUsePath = tempAvatarPath ?? tampDefaultAvatarPath ?? '';

        // 判断当前地址是否使用默认地址
        if (tempAvatarPath != null){
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
    
    ImageProvider get _imageProvider => _handlerAvatarPath (avatarPath, defaultAvatarPath);

    @override
    Widget build(BuildContext context) {
        if (!isAvatarShow){
            return Container();
        }

        return GestureDetector(
            onTap: avatarTap,
            child: customAvatarWidget ?? Container(
                width: avatarSize ?? sz(45),
                height: avatarSize ?? sz(45),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(avatarSize ?? sz(45))
                ),
                child: Image(
                    width: avatarSize ?? sz(45),
                    height: avatarSize ?? sz(45),
                    fit: BoxFit.cover,
                    image: _imageProvider,
                    errorBuilder:(context, error, stackTrace) {
                        return Icon(
                            Icons.account_circle,
                            size: avatarSize ?? sz(45),
                            color: avatarColor,
                        );
                    },
                ),
            ),
        );
    }
}


