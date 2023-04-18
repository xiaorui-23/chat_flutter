

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:chat_flutter/utils/chat_view_item_record_body_type/chat_view_item_record_body_type.dart';
import 'package:chat_flutter/utils/screenutil/screenutil.dart';
import 'package:chat_flutter/widgets/avatar/avatar.dart';
import 'package:chat_flutter/widgets/chat_view_item_record_body/chat_view_item_record_body.dart';

/// 记录项 item
class ChatViewItem extends StatelessWidget {

    ChatViewItem({
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
        this.customItem
    });

    /// 内容
    dynamic itemBody;
    /// 音频时长
    /// * 展示单位：s
    int audioTimelength;
    /// 播放状态
    bool audioPlayStatus;
    /// 自定义记录 item 主体
    Widget? customItem;
    /// 记录时间
    String? itemBodyRecordTime;
    /// 是否为 右侧 己方
    bool senderRight;
    /// 头像地址
    String? avatarPath;
    /// 默认头像地址
    String? defaultAvatarPath;
    /// 是否展示头像
    bool isAvatarShow;
    /// 头像大小
    double? avatarSize;
    /// 头像颜色
    Color? avatarColor;
    /// 自定义头像
    Widget? customAvatar;
    /// 当前记录内容类型
    /// * 默认为文本
    ChatViewItemRecordBodyType itemBodyType;
    /// 记录主体的背景色
    Color backgroundColor;
    /// 自定义头像盒子
    Widget? customAvatarWidget;
    /// 记录主体的文字样式
    TextStyle? itemBodyTextStyle;
    /// 是否打开长按文字菜单
    bool isOpenTextSelect;
    /// 文本选择控制器
    TextSelectionControls? selectionControls;
    /// 显示的工具菜单
    Widget Function(BuildContext context, SelectableRegionState selectableRegionState)? contextMenuBuilder;
    /// 内容主体点击事件
    Function()? itemBodyTap;
    /// 文件、图片、音频 点击事件
    Function(ChatViewItemRecordBodyType type)? itemBodyMediaTap;
    /// 长按文字菜单选择回调
    Function(SelectedContent?)? onSelectionChanged;
    /// 头像点击回调
    Function()? avatarTap;
    /// 可选文字内容 widget 创建时的回调
    Function(FocusNode focusNode)? createSelectableTextCallback;


    @override
    Widget build(BuildContext context) {
        return Container(
            child: Row(
                mainAxisAlignment: senderRight ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    // 对方
                    if (!senderRight)
                        Container(
                            margin: EdgeInsets.only(
                                top: sh(itemBodyRecordTime != null ? 45 : 10)
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
                        itemBodyRecordTime: itemBodyRecordTime,
                        createSelectableTextCallback: createSelectableTextCallback,
                        customItem: customItem,
                        audioPlayStatus: audioPlayStatus,
                        audioTimelength: audioTimelength,
                    ),
                    // 己方
                    if (senderRight)
                        Container(
                            margin: EdgeInsets.only(
                                top: sh(itemBodyRecordTime != null ? 45 : 10)
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
        );
    }
}

