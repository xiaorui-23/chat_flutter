

import 'package:chat_flutter/utils/screenutil/screenutil.dart';
import 'package:flutter/material.dart';

/// 参数合集 Model 类型 


/// 文本 model
class ChatViewItemTextTypeModel {
    /// 文本选择控制器
    final TextSelectionControls? selectionControls;
    /// 是否打开长按文字菜单
    /// * 默认值：true
    final bool isOpenTextSelect;
    /// 记录主体的文字样式
    final TextStyle? itemBodyTextStyle;
    /// 显示的工具菜单
    final Widget Function(BuildContext context, EditableTextState editableTextState)? contextMenuBuilder;
    /// 长按文字菜单选择回调
    final void Function(TextSelection selection, SelectionChangedCause? cause)? onSelectionChanged;
    /// 可选文字内容 widget 创建时的回调
    final void Function(FocusNode focusNode)? createSelectableTextCallback;

    ChatViewItemTextTypeModel ({
        this.createSelectableTextCallback,
        this.isOpenTextSelect = true,
        this.onSelectionChanged,
        this.contextMenuBuilder,
        this.itemBodyTextStyle,
        this.selectionControls,
    });

}

/// 图片 model
class ChatViewItemImageTypeModel {
    /// 预览图片长按显示菜单
    final List<String>? previewImageLongPressMenu;
    /// 预览图片菜单点击回调
    final void Function(String data, int index, List<String> menuList)? onPreviewImageTapMenu;
    /// 自定义预览图片回调
    final void Function(String imagePath)? customPreviewImageCallback;
    /// 自定义长按显示菜单回调
    final void Function(BuildContext context)? customLongPress;

    ChatViewItemImageTypeModel ({
        this.previewImageLongPressMenu,
        this.customPreviewImageCallback,
        this.customLongPress,
        this.onPreviewImageTapMenu
    });
}

/// 视频 model
class ChatViewItemVideoTypeModel {

    /// 未播放自定义 widget
    final Widget? notPlayingWidget;
    /// 播放错误自定义 widget
    final Widget? playingFailWidget;
    /// 在界面展示时是否自动播放
    /// * 默认值：true
    final bool autoPlaying;
    /// 是否启用全屏播放
    /// * 默认值：true
    final bool isOpenFullScreenPlay;
    /// 视频加载错误回调
    final void Function(Object error)? videoLoadFailCallback;

    ChatViewItemVideoTypeModel({
        this.autoPlaying = true,
        this.isOpenFullScreenPlay = true,
        this.notPlayingWidget,
        this.playingFailWidget,
        this.videoLoadFailCallback,
    });
}

/// 文件 model
class ChatViewItemFileTypeModel {
    /// 文件大小
    final double fileSize;

    ChatViewItemFileTypeModel({
        this.fileSize = 0.0
    });
}

/// 音频 model
class ChatViewItemAudioTypeModel {
    /// 音频时长
    /// * 默认值：0
    /// * 展示单位：s
    final int audioTimelength;
    /// 播放状态
    /// * 默认值：false
    final bool audioPlayStatus;

    ChatViewItemAudioTypeModel({
        this.audioTimelength = 0,
        this.audioPlayStatus = false,
    });
}


/// 头像 model
class ChatViewItemAvatarModel {
    /// 头像地址
    final String? avatarPath;
    /// 默认头像地址
    final String? defaultAvatarPath;
    /// 是否展示头像
    /// * 默认值：true
    final bool isAvatarShow;
    /// 头像大小
    final double? avatarSize;
    /// 头像颜色
    final Color? avatarColor;
    /// 自定义头像
    final Widget? customAvatar;
    /// 自定义头像盒子
    final Widget? customAvatarWidget;
    /// 头像点击回调
    final void Function()? avatarTap;

    ChatViewItemAvatarModel({
        this.avatarPath,
        this.defaultAvatarPath,
        this.isAvatarShow = true,
        this.avatarSize,
        this.avatarColor,
        this.customAvatar,
        this.customAvatarWidget,
        this.avatarTap
    });
}

/// 公共参数 model 
class CommonParamModel {
    /// 自定义加载过度 Progress
    /// * 当为传递自定义时采用默认
    ProgressIndicator? progressIndicator;
    /// 默认加载过度 Progress
    ProgressIndicator defaultProgressIndicator = CircularProgressIndicator (strokeWidth: sf(2));
    /// 是否开启过渡加载
    /// * true 为开启
    bool isOpenTransitionLoad;

    CommonParamModel({
        this.progressIndicator,
        this.isOpenTransitionLoad = true
    });
}


