

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:chat_flutter/utils/chat_view_item_record_body_type/chat_view_item_record_body_type.dart';
import 'package:chat_flutter/utils/screenutil/screenutil.dart';
import 'package:chat_flutter/widgets/avatar/avatar.dart';
import 'package:chat_flutter/widgets/chat_view_item_record_body/chat_view_item_record_body.dart';

/// 记录项 item
class ChatViewItem extends StatelessWidget {
    /// 内容
    final dynamic itemBody;
    /// 音频时长
    /// * 展示单位：s
    final int audioTimelength;
    /// 播放状态
    final bool audioPlayStatus;
    /// 自定义记录 item 主体
    final Widget? customItem;
    /// 记录时间
    final String? itemBodyRecordTime;
    /// 是否为 右侧 己方
    final bool senderRight;
    /// 头像地址
    final String? avatarPath;
    /// 默认头像地址
    final String? defaultAvatarPath;
    /// 是否展示头像
    final bool isAvatarShow;
    /// 头像大小
    final double? avatarSize;
    /// 头像颜色
    final Color? avatarColor;
    /// 自定义头像
    final Widget? customAvatar;
    /// 当前记录内容类型
    /// * 默认为文本
    final ChatViewItemRecordBodyType itemBodyType;
    /// 记录主体的背景色
    final Color backgroundColor;
    /// 自定义头像盒子
    final Widget? customAvatarWidget;
    /// 记录主体的文字样式
    final TextStyle? itemBodyTextStyle;
    /// 是否打开长按文字菜单
    final bool isOpenTextSelect;
    /// 文本选择控制器
    final TextSelectionControls? selectionControls;
    /// 自定义时间记录 widget
    final Widget? customRecordTimeWidget;
    /// 自定义时间记录样式
    final TextStyle? customRecordTimeStyle;
    /// 显示的工具菜单
    final Widget Function(BuildContext context, SelectableRegionState selectableRegionState)? contextMenuBuilder;
    /// 内容主体点击事件
    final Function()? itemBodyTap;
    /// 文件、图片、音频 点击事件
    final Function(ChatViewItemRecordBodyType type)? itemBodyMediaTap;
    /// 长按文字菜单选择回调
    final Function(SelectedContent?)? onSelectionChanged;
    /// 头像点击回调
    final Function()? avatarTap;
    /// 可选文字内容 widget 创建时的回调
    final Function(FocusNode focusNode)? createSelectableTextCallback;

    const ChatViewItem({
        super.key,
        this.itemBody,
        this.audioTimelength = 0,
        this.audioPlayStatus = false,
        this.senderRight = true,
        this.avatarPath,
        this.defaultAvatarPath,
        this.isAvatarShow = true,
        this.selectionControls,
        this.avatarSize,
        this.avatarColor,
        this.customAvatar,
        this.itemBodyType = ChatViewItemRecordBodyType.text,
        this.backgroundColor = Colors.white,
        this.avatarTap,
        this.itemBodyTextStyle,
        this.itemBodyTap,
        this.itemBodyMediaTap,
        this.contextMenuBuilder,
        this.isOpenTextSelect = true,
        this.onSelectionChanged,
        this.customAvatarWidget,
        this.itemBodyRecordTime,
        this.createSelectableTextCallback,
        this.customItem,
        this.customRecordTimeWidget,
        this.customRecordTimeStyle
    });

    @override
    Widget build(BuildContext context) {
        return Column(
            children: [
                // 记录时间
                if (customRecordTimeWidget != null) customRecordTimeWidget!,
                if(itemBodyRecordTime != null)
                    Container(
                        width: sw(375),
                        margin: EdgeInsets.only(
                            top: sh(10),
                            bottom: sh(10)
                        ),
                        alignment: Alignment.center,
                        child: Text(
                            itemBodyRecordTime!,
                            textAlign: TextAlign.center,
                            style: customRecordTimeStyle ?? TextStyle(
                                fontSize: sf(14),
                                color: const Color.fromARGB(255, 183, 182, 182)
                            ),
                        ),
                    ),
                // 内容主体
                SizedBox(
                    width: sw(375),
                    child: Row(
                        mainAxisAlignment: senderRight ? MainAxisAlignment.end : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            // 对方
                            if (!senderRight)
                                Container(
                                    margin: EdgeInsets.only(
                                        top: sh(10)
                                    ),
                                    child: customAvatar ?? Avatar(
                                        avatarPath: avatarPath,
                                        defaultAvatarPath: defaultAvatarPath,
                                        isAvatarShow: isAvatarShow,
                                        avatarSize: avatarSize,
                                        avatarColor: avatarColor,
                                        avatarTap: avatarTap,
                                        customAvatarWidget: customAvatarWidget
                                    ),
                                ),
                            // 消息内容
                            ChatViewItemRecordBody(
                                senderRight: senderRight,
                                itemBodyType: itemBodyType,
                                backgroundColor: backgroundColor,
                                itemBody: itemBody,
                                itemBodyMediaTap: itemBodyMediaTap,
                                isOpenTextSelect: isOpenTextSelect,
                                contextMenuBuilder: contextMenuBuilder,
                                onSelectionChanged: onSelectionChanged,
                                createSelectableTextCallback: createSelectableTextCallback,
                                customItem: customItem,
                                audioPlayStatus: audioPlayStatus,
                                audioTimelength: audioTimelength,
                            ),
                            // 己方
                            if (senderRight)
                                Container(
                                    margin: EdgeInsets.only(
                                        top: sh(10)
                                    ),
                                    child: customAvatar ?? Avatar(
                                        avatarPath: avatarPath,
                                        defaultAvatarPath: defaultAvatarPath,
                                        isAvatarShow: isAvatarShow,
                                        avatarSize: avatarSize,
                                        avatarColor: avatarColor,
                                        avatarTap: avatarTap,
                                        customAvatarWidget: customAvatarWidget
                                    ),
                                ),
                            // 
                        ],
                    ),
                ),
                // 
            ],
        );
    }
}

