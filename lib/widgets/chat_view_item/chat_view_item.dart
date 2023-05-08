

import 'package:chat_flutter/utils/parameter_model_set/parameter_model_set.dart';
import 'package:flutter/material.dart';
import 'package:chat_flutter/utils/chat_view_item_record_body_type/chat_view_item_record_body_type.dart';
import 'package:chat_flutter/utils/screenutil/screenutil.dart';
import 'package:chat_flutter/widgets/avatar/avatar.dart';
import 'package:chat_flutter/widgets/chat_view_item_record_body/chat_view_item_record_body.dart';

/// 记录项 item
class ChatViewItem extends StatefulWidget {
  /// 内容
    final String? itemBody;
    /// 自定义记录 item 主体
    final Widget? customItem;
    /// 记录时间
    final String? itemBodyRecordTime;
    /// 是否为 右侧 己方
    /// * 默认值：true
    final bool senderRight;
    /// 当前记录内容类型
    /// * 默认为文本 -> ChatViewItemRecordBodyType.text
    final ChatViewItemRecordBodyType itemBodyType;
    /// 记录主体的背景色
    /// * 默认白色
    final Color backgroundColor;
    /// 自定义时间记录 widget
    final Widget? customRecordTimeWidget;
    /// 自定义时间记录样式
    final TextStyle? customRecordTimeStyle;
    /// 内容主体约束
    final BoxConstraints? chatViewItemRecordBodyBoxConstraints;

    /// 文本类型配置内容
    final ChatViewItemTextTypeModel? textTypeModel;
    /// 图片类型配置内容
    final ChatViewItemImageTypeModel? imageTypeModel;
    /// 视频类型配置内容
    final ChatViewItemVideoTypeModel? videoTypeModel;
    /// 文件类型配置内容
    final ChatViewItemFileTypeModel? fileTypeModel;
    /// 音频类型配置内容
    final ChatViewItemAudioTypeModel? audioTypeModel;
    
    /// 头像配置内容
    final ChatViewItemAvatarModel? avatarModel;

    /// 内容主体点击事件
    final void Function(ChatViewItemRecordBodyType type)? itemBodyTap;
    /// 文件、图片、音频、视频 点击事件
    final void Function(ChatViewItemRecordBodyType type)? itemBodyMediaTap;
    
    const ChatViewItem({
        super.key,
        this.itemBody,
        this.senderRight = true,
        this.itemBodyType = ChatViewItemRecordBodyType.text,
        this.backgroundColor = Colors.white,
        this.textTypeModel,
        this.imageTypeModel,
        this.fileTypeModel,
        this.videoTypeModel,
        this.audioTypeModel,
        this.avatarModel,
        this.itemBodyTap,
        this.itemBodyMediaTap,
        this.itemBodyRecordTime,
        this.customItem,
        this.customRecordTimeWidget,
        this.customRecordTimeStyle,
        this.chatViewItemRecordBodyBoxConstraints,
    });

    @override
    State<ChatViewItem> createState() => _ChatViewItemState();
}

class _ChatViewItemState extends State<ChatViewItem> with AutomaticKeepAliveClientMixin {
    
    ChatViewItemAvatarModel get _avatarModel => widget.avatarModel ?? ChatViewItemAvatarModel();

    ChatViewItemTextTypeModel get _textTypeModel => widget.textTypeModel ?? ChatViewItemTextTypeModel();
    ChatViewItemImageTypeModel get _imageTypeModel => widget.imageTypeModel ?? ChatViewItemImageTypeModel();
    ChatViewItemVideoTypeModel get _videoTypeModel => widget.videoTypeModel ?? ChatViewItemVideoTypeModel();
    // 暂不支持额外参数
    ChatViewItemFileTypeModel get _fileTypeModel => widget.fileTypeModel ?? ChatViewItemFileTypeModel();
    ChatViewItemAudioTypeModel get _audioTypeModel => widget.audioTypeModel ?? ChatViewItemAudioTypeModel();

    @override
    bool get wantKeepAlive => true;

    @override
    Widget build(BuildContext context) {
        super.build(context);
        
        return Column(
            children: [
                // 记录时间
                if (widget.customRecordTimeWidget != null) widget.customRecordTimeWidget!,
                if(widget.itemBodyRecordTime != null)
                    Container(
                        width: sw(375),
                        margin: EdgeInsets.only(
                            top: sh(10),
                            bottom: sh(10)
                        ),
                        alignment: Alignment.center,
                        child: Text(
                            widget.itemBodyRecordTime!,
                            textAlign: TextAlign.center,
                            style: widget.customRecordTimeStyle ?? TextStyle(
                                fontSize: sf(14),
                                color: const Color.fromARGB(255, 183, 182, 182)
                            ),
                        ),
                    ),
                // 内容主体
                SizedBox(
                    width: sw(375),
                    child: Row(
                        mainAxisAlignment: widget.senderRight ? MainAxisAlignment.end : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            // 对方
                            if (!widget.senderRight)
                                Container(
                                    margin: EdgeInsets.only(
                                        top: sh(10)
                                    ),
                                    child: _avatarModel.customAvatar ?? Avatar(
                                        avatarPath: _avatarModel.avatarPath,
                                        defaultAvatarPath: _avatarModel.defaultAvatarPath,
                                        isAvatarShow: _avatarModel.isAvatarShow,
                                        avatarSize: _avatarModel.avatarSize,
                                        avatarColor: _avatarModel.avatarColor,
                                        avatarTap: _avatarModel.avatarTap,
                                        customAvatarWidget: _avatarModel.customAvatarWidget
                                    ),
                                ),
                            // 消息内容
                            ChatViewItemRecordBody(
                                senderRight: widget.senderRight,
                                itemBodyType: widget.itemBodyType,
                                backgroundColor: widget.backgroundColor,
                                itemBody: (widget.itemBody ?? '').toString(),
                                itemBodyTap: widget.itemBodyTap,
                                itemBodyMediaTap: widget.itemBodyMediaTap,
                                chatViewItemRecordBodyBoxConstraints: widget.chatViewItemRecordBodyBoxConstraints,
                                customItem: widget.customItem,
        
                                textTypeModel: _textTypeModel,
                                audioTypeModel: _audioTypeModel,
                                imageTypeModel: _imageTypeModel,
                                videoTypeModel: _videoTypeModel,
                                fileTypeModel: _fileTypeModel,
                            ),
                            // 己方
                            if (widget.senderRight)
                                Container(
                                    margin: EdgeInsets.only(
                                        top: sh(10)
                                    ),
                                    child: _avatarModel.customAvatar ?? Avatar(
                                        avatarPath: _avatarModel.avatarPath,
                                        defaultAvatarPath: _avatarModel.defaultAvatarPath,
                                        isAvatarShow: _avatarModel.isAvatarShow,
                                        avatarSize: _avatarModel.avatarSize,
                                        avatarColor: _avatarModel.avatarColor,
                                        avatarTap: _avatarModel.avatarTap,
                                        customAvatarWidget: _avatarModel.customAvatarWidget
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

