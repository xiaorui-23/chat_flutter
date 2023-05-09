
import 'package:chat_flutter/utils/parameter_model_set/parameter_model_set.dart';
import 'package:chat_flutter/widgets/image_box/image_box.dart';
import 'package:chat_flutter/widgets/video_box/video_box.dart';
import 'package:flutter/material.dart';
import 'package:chat_flutter/utils/chat_view_item_record_body_type/chat_view_item_record_body_type.dart';
import 'package:chat_flutter/utils/screenutil/screenutil.dart';
import 'package:chat_flutter/widgets/audio_box/audio_box.dart';
import 'package:chat_flutter/widgets/custom_selection_area/custom_selection_area.dart';

/// 内容主体
class ChatViewItemRecordBody extends StatelessWidget {
    
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

    
    /// 图片加载失败状态
    /// * true 为加载失败
    static final Map<String, int> _imageLoadFailStatus = {'value': 0};

    @override
    Widget build(BuildContext context) {
        return StatefulBuilder(
            builder: (buildContext, setState) {
                return Container(
                    padding: EdgeInsets.only(
                        top: sh(10),
                        bottom: sh(10)
                    ),
                    child: Stack(
                        children: [
                            customItem ?? Container(
                                margin: EdgeInsets.only(
                                    right: sw(senderRight ? 15 : 0),
                                    left: sw(!senderRight ? 15 : 0)
                                ),
                                padding: _excludeContentType(itemBodyType) && _imageLoadFailStatus['value'] == 0 ? null :  EdgeInsets.only(
                                    left: sw(10),
                                    right: sw(10),
                                    top: sh(10),
                                    bottom: sh(10)
                                ),
                                constraints: chatViewItemRecordBodyBoxConstraints ?? BoxConstraints(
                                    maxWidth: sw(170),
                                    minHeight: sh(35),
                                ),
                                decoration: _excludeContentType(itemBodyType) && _imageLoadFailStatus['value'] == 0 ? null : BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.all(Radius.circular(sr(10))),
                                ),
                                child: GestureDetector(
                                    onTap: () {
                                        if(itemBodyTap != null){
                                            itemBodyTap!(itemBodyType);
                                        }
                                    },
                                    child: _typeHandlerWidget(
                                        onImageError: (exception, stackTrace) {
                                            _imageLoadFailStatus['value'] = 1;
                            
                                            if (buildContext.mounted){
                                                setState(() {});
                                            }
                                        },
                                    )
                                ),
                            ),
                            // 箭头图标
                            if (customItem == null && (_imageLoadFailStatus['value'] == 1 || !_excludeContentType(itemBodyType)))
                                Positioned(
                                    top: sh(7),
                                    right: senderRight ? sw(-5) : null,
                                    left: !senderRight ? sw(-5) : null,
                                    child: ClipRect(
                                        clipper: _ClipperPath(
                                            senderRight: senderRight
                                        ),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                border:  Border(
                                                    bottom: BorderSide(
                                                        width: sw(10),
                                                        color: Colors.transparent,
                                                    ),
                                                    top: BorderSide(
                                                        width: sw(10),
                                                        color: Colors.transparent,
                                                    ),
                                                    left: BorderSide(
                                                        width: sw(10),
                                                        color: senderRight ? backgroundColor : Colors.transparent,
                                                    ),
                                                    right: BorderSide(
                                                        width: sw(10),
                                                        color: !senderRight ? backgroundColor : Colors.transparent,
                                                    )
                                                )
                                            ),
                                        ),
                                    )
                                ),
                            // 
                        ],
                    ),
                );
            }
        );
    }

    /// 根据 记录类型返回对应 widget
    Widget _typeHandlerWidget ({Function(Object exception, StackTrace? stackTrace)? onImageError}) {
        // 图片
        if (itemBodyType == ChatViewItemRecordBodyType.image) {
            return GestureDetector(
                onTap: () {
                    if (itemBodyMediaTap != null){
                        itemBodyMediaTap!(ChatViewItemRecordBodyType.image);
                    }
                },
                child: ImageBox(
                    imageLoadFailStatus: _imageLoadFailStatus['value'] == 1,
                    imagePath: itemBody,
                    imageTypeModel: imageTypeModel,
                    onImageError: onImageError,
                ),
            );
        }
        // 文件
        else if (itemBodyType == ChatViewItemRecordBodyType.file) {
            return GestureDetector(
                onTap: () {
                    if (itemBodyMediaTap != null){
                        itemBodyMediaTap!(ChatViewItemRecordBodyType.file);
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
                                itemBody,
                                softWrap: true,
                                style: textTypeModel.itemBodyTextStyle ?? TextStyle (
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
        else if (itemBodyType == ChatViewItemRecordBodyType.audio) {
            return GestureDetector(
                onTap: () {
                    if (itemBodyMediaTap != null){
                        itemBodyMediaTap!(ChatViewItemRecordBodyType.audio);
                    }
                },
                child: AudioBox(
                    audioTimelength: audioTypeModel.audioTimelength,
                    audioPlayStatus: audioTypeModel.audioPlayStatus,
                ),
            );
        }
        // 视频
        else if (itemBodyType == ChatViewItemRecordBodyType.video) {
            return GestureDetector(
                onTap: () {
                    if (itemBodyMediaTap != null){
                        itemBodyMediaTap!(ChatViewItemRecordBodyType.video);
                    }
                },
                child: VideoBox(
                    videoPath: itemBody,
                    backgroundColor: backgroundColor,
                    autoPlaying: videoTypeModel.autoPlaying,
                    notPlayingWidget: videoTypeModel.notPlayingWidget,
                    playingFailWidget: videoTypeModel.playingFailWidget,
                    isOpenFullScreenPlay: videoTypeModel.isOpenFullScreenPlay,
                    videoLoadFailCallback: videoTypeModel.videoLoadFailCallback,
                ),
            );
        }
        // 文字
        else {
            return CustomSelectionArea(
                isOpen: textTypeModel.isOpenTextSelect && itemBodyType == ChatViewItemRecordBodyType.text,
                itemBodyTextStyle: textTypeModel.itemBodyTextStyle,
                onSelectionChanged: textTypeModel.onSelectionChanged,
                contextMenuBuilder: textTypeModel.contextMenuBuilder,
                selectionControls: textTypeModel.selectionControls,
                createSelectableTextCallback: textTypeModel.createSelectableTextCallback,
                child: Text(
                    itemBody,
                    textAlign: TextAlign.left,
                    softWrap: true,
                    style: textTypeModel.itemBodyTextStyle ?? TextStyle(
                        fontSize: sf(15),
                        color: Colors.black
                    )
                )
            );
        }
    }
}


/// 需要排除样式内容显示的内容类型
/// true 表示属于需要排除的样式的内容类型
bool _excludeContentType (ChatViewItemRecordBodyType type) => [ChatViewItemRecordBodyType.image, ChatViewItemRecordBodyType.video].contains(type);

/// 裁切
class _ClipperPath extends CustomClipper<Rect>{
    /// 是否为己方
    /// * true 为己方
    final bool senderRight;

    _ClipperPath({
        required this.senderRight
    });

    @override
    Rect getClip(Size size) => Rect.fromLTRB(
        sw(!senderRight ? 10 : 0), 
        0, 
        senderRight ? size.width - sw(10) : size.width, 
        size.height
    );

    @override
    bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}



