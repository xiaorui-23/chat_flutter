
import 'package:chat_flutter/utils/parameter_model_set/parameter_model_set.dart';
import 'package:chat_flutter/widgets/image_box/image_box.dart';
import 'package:chat_flutter/widgets/video_box/video_box.dart';
import 'package:flutter/material.dart';
import 'package:chat_flutter/utils/chat_view_item_record_body_type/chat_view_item_record_body_type.dart';
import 'package:chat_flutter/utils/screenutil/screenutil.dart';
import 'package:chat_flutter/widgets/audio_box/audio_box.dart';
import 'package:chat_flutter/widgets/custom_selection_area/custom_selection_area.dart';

/// 内容主体
class ChatViewItemRecordBody extends StatefulWidget {
    
    /// 内容
    final String itemBody;
    /// 自定义记录 item 主体
    final Widget? customItem;
    /// 当前记录内容类型
    final ChatViewItemRecordBodyType itemBodyType;
    /// 背景色
    final Color backgroundColor;
    /// 是否为 右侧 己方
    final bool senderRight;
    /// 内容主体约束
    final BoxConstraints? chatViewItemRecordBodyBoxConstraints;
    /// 内容主体点击事件
    final void Function(ChatViewItemRecordBodyType type)? itemBodyTap;
    /// 文件、图片、音频 点击事件
    final void Function(ChatViewItemRecordBodyType type)? itemBodyMediaTap;

    /// 文本类型配置内容
    final ChatViewItemTextTypeModel textTypeModel;
    /// 图片类型配置内容
    final ChatViewItemImageTypeModel imageTypeModel;
    /// 视频类型配置内容
    final ChatViewItemVideoTypeModel videoTypeModel;
    /// 文件类型配置内容
    final ChatViewItemFileTypeModel fileTypeModel;
    /// 音频类型配置内容
    final ChatViewItemAudioTypeModel audioTypeModel;

    const ChatViewItemRecordBody({
        super.key,
        required this.senderRight,
        required this.itemBody,
        required this.textTypeModel,
        required this.imageTypeModel,
        required this.fileTypeModel,
        required this.videoTypeModel,
        required this.audioTypeModel,
        required this.itemBodyType,
        required this.backgroundColor,

        this.customItem,
        this.chatViewItemRecordBodyBoxConstraints,
        this.itemBodyTap,
        this.itemBodyMediaTap,
    });

    
    @override
    State<ChatViewItemRecordBody> createState() => _ChatViewItemRecordBodyState();
}

class _ChatViewItemRecordBodyState extends State<ChatViewItemRecordBody> {
    /// 图片加载失败状态
    /// * true 为加载失败
    bool _imageLoadFailStatus = false;

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: EdgeInsets.only(
                top: sh(10),
                bottom: sh(10)
            ),
            child: Stack(
                children: [
                    widget.customItem ?? Container(
                        margin: EdgeInsets.only(
                            right: sw(widget.senderRight ? 23 : 0),
                            left: sw(!widget.senderRight ? 23 : 0)
                        ),
                        padding: excludeContentType(widget.itemBodyType) && !_imageLoadFailStatus ? null :  EdgeInsets.only(
                            left: sw(10),
                            right: sw(10),
                            top: sh(10),
                            bottom: sh(10)
                        ),
                        constraints: widget.chatViewItemRecordBodyBoxConstraints ?? BoxConstraints(
                            maxWidth: sw(170),
                            minHeight: sh(35),
                        ),
                        decoration: excludeContentType(widget.itemBodyType) && !_imageLoadFailStatus ? null : BoxDecoration(
                            color: widget.backgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(sr(10))),
                        ),
                        child: GestureDetector(
                            onTap: () {
                                if(widget.itemBodyTap != null){
                                    widget.itemBodyTap!(widget.itemBodyType);
                                }
                            },
                            child: _typeHandlerWidget(
                                onImageError: (exception, stackTrace) {
                                    _imageLoadFailStatus = true;
                    
                                    if (mounted){
                                        setState(() {});
                                    }
                                },
                            )
                        ),
                    ),
                    // 箭头图标
                    if (widget.customItem == null && (!excludeContentType(widget.itemBodyType) || _imageLoadFailStatus))
                        Positioned(
                            top: sh(10),
                            right: widget.senderRight ? 0 : null,
                            left: !widget.senderRight ? 0 : null,
                            child: Container(
                                decoration: BoxDecoration(
                                    border:  Border(
                                        bottom: BorderSide(
                                            width: sw(12),
                                            color: Colors.transparent,
                                        ),
                                        top: BorderSide(
                                            width: sw(12),
                                            color: Colors.transparent,
                                        ),
                                        left: BorderSide(
                                            width: sw(12),
                                            color: widget.senderRight ? widget.backgroundColor : Colors.transparent,
                                        ),
                                        right: BorderSide(
                                            width: sw(12),
                                            color: !widget.senderRight ? widget.backgroundColor : Colors.transparent,
                                        )
                                    )
                                ),
                            )
                        ),
                    // 
                ],
            ),
        );
    }

    /// 根据 记录类型返回对应 widget
    Widget _typeHandlerWidget ({Function(Object exception, StackTrace? stackTrace)? onImageError}) {
        // 图片
        if (widget.itemBodyType == ChatViewItemRecordBodyType.image) {
            return GestureDetector(
                onTap: () {
                    if (widget.itemBodyMediaTap != null){
                        widget.itemBodyMediaTap!(ChatViewItemRecordBodyType.image);
                    }
                },
                child: ImageBox(
                    imageLoadFailStatus: _imageLoadFailStatus,
                    imagePath: widget.itemBody,
                    imageTypeModel: widget.imageTypeModel,
                    onImageError: onImageError,
                ),
            );
        }
        // 文件
        else if (widget.itemBodyType == ChatViewItemRecordBodyType.file) {
            return GestureDetector(
                onTap: () {
                    if (widget.itemBodyMediaTap != null){
                        widget.itemBodyMediaTap!(ChatViewItemRecordBodyType.file);
                    }
                },
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        // 图标
                        Icon(
                            Icons.file_open,
                            color: const Color(0xff1989fa),
                            size: sf(20),
                        ),
                        // 文字描述
                        Container(
                            constraints: BoxConstraints(
                                maxWidth: sw(120)
                            ),
                            margin: EdgeInsets.only(
                                left: sw(10)
                            ),
                            child: Text(
                                widget.itemBody,
                                softWrap: true,
                                style: widget.textTypeModel.itemBodyTextStyle ?? TextStyle (
                                    color: const Color(0xff1989fa),
                                    fontSize: sf(16)
                                ),
                            )
                        ),
                    ],
                ),
            );
        }
        // 音频
        else if (widget.itemBodyType == ChatViewItemRecordBodyType.audio) {
            return GestureDetector(
                onTap: () {
                    if (widget.itemBodyMediaTap != null){
                        widget.itemBodyMediaTap!(ChatViewItemRecordBodyType.audio);
                    }
                },
                child: AudioBox(
                    audioTimelength: widget.audioTypeModel.audioTimelength,
                    audioPlayStatus: widget.audioTypeModel.audioPlayStatus,
                ),
            );
        }
        // 视频
        else if (widget.itemBodyType == ChatViewItemRecordBodyType.video) {
            return GestureDetector(
                onTap: () {
                    if (widget.itemBodyMediaTap != null){
                        widget.itemBodyMediaTap!(ChatViewItemRecordBodyType.video);
                    }
                },
                child: VideoBox(
                    videoPath: widget.itemBody,
                    backgroundColor: widget.backgroundColor,
                    autoPlaying: widget.videoTypeModel.autoPlaying,
                    notPlayingWidget: widget.videoTypeModel.notPlayingWidget,
                    playingFailWidget: widget.videoTypeModel.playingFailWidget,
                    isOpenFullScreenPlay: widget.videoTypeModel.isOpenFullScreenPlay,
                    videoLoadFailCallback: widget.videoTypeModel.videoLoadFailCallback,
                ),
            );
        }
        // 文字
        else {
            return CustomSelectionArea(
                isOpen: widget.textTypeModel.isOpenTextSelect && widget.itemBodyType == ChatViewItemRecordBodyType.text,
                itemBodyTextStyle: widget.textTypeModel.itemBodyTextStyle,
                onSelectionChanged: widget.textTypeModel.onSelectionChanged,
                contextMenuBuilder: widget.textTypeModel.contextMenuBuilder,
                selectionControls: widget.textTypeModel.selectionControls,
                createSelectableTextCallback: widget.textTypeModel.createSelectableTextCallback,
                child: Text(
                    widget.itemBody,
                    textAlign: TextAlign.left,
                    softWrap: true,
                    style: widget.textTypeModel.itemBodyTextStyle ?? TextStyle(
                        fontSize: sf(15),
                        color: Colors.black
                    )
                )
            );
        }
    }
}


/// 需要排除样式内容显示的内容类型
bool excludeContentType (ChatViewItemRecordBodyType type) => [ChatViewItemRecordBodyType.image, ChatViewItemRecordBodyType.video].contains(type);



