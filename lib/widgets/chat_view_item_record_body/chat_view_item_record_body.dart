

import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:chat_flutter/utils/chat_image_list/chat_image_list.dart';
import 'package:chat_flutter/utils/get_language_environment/get_language_environment.dart';
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

    /// 过度 progressIndicator
    final CommonParamModel commonParamModel;

    const ChatViewItemRecordBody({
        super.key,
        required this.senderRight,
        required this.itemBody,

        required this.textTypeModel,
        required this.imageTypeModel,
        required this.fileTypeModel,
        required this.videoTypeModel,
        required this.audioTypeModel,

        required this.commonParamModel,

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
    /// 图片内容
    ImageProvider? get imageProviderInfo => widget.itemBodyType == ChatViewItemRecordBodyType.image ? NetworkImage(widget.itemBody) : null;

    /// ChatImageListUtils 图片添加状态
    /// * true 为已添加
    bool _addStatus = false;
    /// 预览图片需要的内容
    ChatImageListUtils? _chatImageListUtils;

    @override
    Widget build(BuildContext context) {
        return FutureBuilder(
            future: _typeHandlerWidget(),
            builder:(context, snapshot) {
                if (snapshot.data == null){
                    return Container(
                        alignment: Alignment.center,
                        child: widget.commonParamModel.isOpenTransitionLoad ? widget.commonParamModel.progressIndicator ?? widget.commonParamModel.defaultProgressIndicator : null,
                    );
                }

                return Container(
                    padding: EdgeInsets.only(
                        top: sh(10),
                        bottom: sh(10)
                    ),
                    child: Stack(
                        children: [
                            widget.customItem ?? Container(
                                margin: EdgeInsets.only(
                                    right: sw(widget.senderRight ? 15 : 0),
                                    left: sw(!widget.senderRight ? 15 : 0)
                                ),
                                padding: _excludeContentType(widget.itemBodyType) && snapshot.data!.isImageLoad ? null :  EdgeInsets.only(
                                    left: sw(10),
                                    right: sw(10),
                                    top: sh(10),
                                    bottom: sh(10)
                                ),
                                constraints: widget.chatViewItemRecordBodyBoxConstraints ?? BoxConstraints(
                                    maxWidth: sw(170),
                                    minHeight: sh(35),
                                ),
                                decoration: _excludeContentType(widget.itemBodyType) && snapshot.data!.isImageLoad ? null : BoxDecoration(
                                    color: widget.backgroundColor,
                                    borderRadius: BorderRadius.all(Radius.circular(sr(10))),
                                ),
                                child: GestureDetector(
                                    onTap: () {
                                        if(widget.itemBodyTap != null){
                                            widget.itemBodyTap!(widget.itemBodyType);
                                        }
                                    },
                                    child: !snapshot.data!.isImageLoad && widget.itemBodyType == ChatViewItemRecordBodyType.image ? 
                                        Text(
                                            '${GetLanguageEnvironment.getLanguageEnvConvertValue('图片加载失败')}...',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: sf(15),
                                                color: Colors.black
                                            ),
                                        )
                                        :
                                        snapshot.data!.widget 
                                ),
                            ),
                            // 箭头图标
                            if (widget.customItem == null && (!snapshot.data!.isImageLoad || !_excludeContentType(widget.itemBodyType)))
                                Positioned(
                                    top: sh(7),
                                    right: widget.senderRight ? sw(-5) : null,
                                    left: !widget.senderRight ? sw(-5) : null,
                                    child: ClipRect(
                                        clipper: _ClipperPath(
                                            senderRight: widget.senderRight
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
                                                        color: widget.senderRight ? widget.backgroundColor : Colors.transparent,
                                                    ),
                                                    right: BorderSide(
                                                        width: sw(10),
                                                        color: !widget.senderRight ? widget.backgroundColor : Colors.transparent,
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
    Future<_TypeRenderModel> _typeHandlerWidget () async {
        /// 类型 widget
        Widget widgets;
        /// 图片可加载状态
        /// * true 为可加载
        bool isImageLoad = true;


        // 图片
        if (widget.itemBodyType == ChatViewItemRecordBodyType.image) {
            // 获取到的图片信息
            ui.Image? imageInfo;

            try {
                imageInfo = await _getImageInfo ();
            } catch (error) {
                isImageLoad = false;
            }
            
            widgets = GestureDetector(
                onTap: () {
                    if (isImageLoad && widget.itemBodyMediaTap != null){
                        widget.itemBodyMediaTap!(ChatViewItemRecordBodyType.image);
                    }
                },
                child: ImageBox(
                    imagePath: widget.itemBody,
                    imageInfo: imageInfo,
                    imageProviderInfo: imageProviderInfo,
                    isImageLoad: isImageLoad,
                    imageTypeModel: widget.imageTypeModel,
                    chatImageListUtils: _chatImageListUtils,
                ),
            );
        }
        // 文件
        else if (widget.itemBodyType == ChatViewItemRecordBodyType.file) {
            widgets = GestureDetector(
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
            widgets = GestureDetector(
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
            widgets = GestureDetector(
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
                    progressIndicator: widget.commonParamModel.progressIndicator ?? widget.commonParamModel.defaultProgressIndicator,
                    isOpenFullScreenPlay: widget.videoTypeModel.isOpenFullScreenPlay,
                    videoLoadFailCallback: widget.videoTypeModel.videoLoadFailCallback,
                ),
            );
        }
        // 文字
        else {
            widgets = CustomSelectionArea(
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

        return _TypeRenderModel(
            widget: widgets, 
            isImageLoad: isImageLoad,
        );
    }

    /// 获取图片信息
    Future<ui.Image?> _getImageInfo () {
        if (imageProviderInfo == null) {
            return Future.value(null);
        }

        _chatImageListUtils = ChatImageListUtils(id: math.Random().nextInt(99) * DateTime.now().microsecondsSinceEpoch, imageProvider: imageProviderInfo!);
        ImageStream imageStream = imageProviderInfo!.resolve(ImageConfiguration.empty);
        
        Completer<ui.Image> completer = Completer<ui.Image>();

        // 监听错误
        void listenerError (exception, stackTrace) => completer.completeError(exception, stackTrace);

        // 监听文件流
        void listener (ImageInfo imageInfo, bool synchronousCall){
            // 添加当前图片内容
            if (!_addStatus){
                ChatImageList.addImageList(_chatImageListUtils!);
                _addStatus = true;
            }


            ui.Image image = imageInfo.image;
            // 获取到文件流
            completer.complete(image);
            // 移除监听器
            imageStream.removeListener(ImageStreamListener(listener, onError: listenerError));
        }

        // 添加监听器
        imageStream.addListener(ImageStreamListener(listener, onError: listenerError));

        return completer.future;
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

/// 类型渲染数据 model
class _TypeRenderModel {
    /// widget
    final Widget widget;
    /// 图片是否可加载
    /// * true 为可加载
    /// * itemBodyType == ChatViewItemRecordBodyType.image 有效
    final bool isImageLoad;


    const _TypeRenderModel ({
        required this.widget,
        required this.isImageLoad
    });
}

