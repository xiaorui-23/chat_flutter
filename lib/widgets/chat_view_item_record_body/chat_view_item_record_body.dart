import 'dart:math' as math;
import 'package:chat_flutter/utils/chat_image_list/chat_image_list.dart';
import 'package:chat_flutter/utils/preview_image/preview_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:chat_flutter/utils/chat_view_item_record_body_type/chat_view_item_record_body_type.dart';
import 'package:chat_flutter/utils/screenutil/screenutil.dart';
import 'package:chat_flutter/widgets/audio_box/audio_box.dart';
import 'package:chat_flutter/widgets/custom_selection_area/custom_selection_area.dart';

/// 内容主体
class ChatViewItemRecordBody extends StatefulWidget {
    
    /// 内容
    final dynamic itemBody;
    /// 自定义记录 item 主体
    final Widget? customItem;
    /// 当前记录内容类型
    final ChatViewItemRecordBodyType itemBodyType;
    /// 背景色
    final Color backgroundColor;
    /// 是否为 右侧 己方
    final bool senderRight;
    /// 是否打开长按文字菜单
    final bool isOpenTextSelect;
    /// 记录主体的文字样式
    final TextStyle? itemBodyTextStyle;
    /// 音频时长
    final int audioTimelength;
    /// 播放状态
    final bool audioPlayStatus;
    /// 文本选择控制器
    final TextSelectionControls? selectionControls;
    /// 内容主体约束
    final BoxConstraints? chatViewItemRecordBodyBoxConstraints;
    /// 预览图片长按显示菜单
    final List<String>? previewImageLongPressMenu;
    /// 预览图片菜单点击回调
    final void Function(String data, int index, List<String> menuList)? onPreviewImageTapMenu;
    /// 自定义预览图片回调
    final void Function(String imagePath)? customPreviewImageCallback;
    /// 自定义长按显示菜单回调
    final void Function(BuildContext context)? customLongPress;
    /// 长按文字菜单选择回调
    final void Function(SelectedContent?)? onSelectionChanged;
    /// 内容主体点击事件
    final void Function(ChatViewItemRecordBodyType type)? itemBodyTap;
    /// SelectableText 创建时
    final void Function(FocusNode focusNode)? createSelectableTextCallback;
    /// 文件、图片、音频 点击事件
    final void Function(ChatViewItemRecordBodyType type)? itemBodyMediaTap;
    /// 显示的工具菜单
    final Widget Function(BuildContext, SelectableRegionState)? contextMenuBuilder;

    const ChatViewItemRecordBody({
        super.key,
        this.senderRight = true,
        this.itemBodyType = ChatViewItemRecordBodyType.text,
        this.backgroundColor = Colors.white,
        this.itemBody,
        this.customItem,
        this.itemBodyTextStyle,
        this.chatViewItemRecordBodyBoxConstraints,
        this.itemBodyTap,
        this.itemBodyMediaTap,
        this.selectionControls,
        this.isOpenTextSelect = false,
        this.previewImageLongPressMenu,
        this.onPreviewImageTapMenu,
        this.onSelectionChanged,
        this.contextMenuBuilder,
        this.audioTimelength = 0,
        this.audioPlayStatus = false,
        this.createSelectableTextCallback,
        this.customPreviewImageCallback,
        this.customLongPress
    });

    
    @override
    State<ChatViewItemRecordBody> createState() => _ChatViewItemRecordBodyState();
}

class _ChatViewItemRecordBodyState extends State<ChatViewItemRecordBody> {
    /// 图片加载失败状态
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
                    Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            Container(
                                margin: EdgeInsets.only(
                                    right: sw(widget.senderRight ? 23 : 0),
                                    left: sw(!widget.senderRight ? 23 : 0)
                                ),
                                constraints: BoxConstraints(
                                    minHeight: sh(45),
                                ),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: widget.senderRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                        // 内容主体
                                        widget.customItem ?? Container(
                                            constraints: widget.chatViewItemRecordBodyBoxConstraints ?? BoxConstraints(
                                                maxWidth: sw(170),
                                            ),
                                            decoration: excludeContentType(widget.itemBodyType) && !_imageLoadFailStatus ? null : BoxDecoration(
                                                color: widget.backgroundColor,
                                                borderRadius: BorderRadius.all(Radius.circular(sr(10))) 
                                            ),
                                            padding: excludeContentType(widget.itemBodyType) && !_imageLoadFailStatus ? null :  EdgeInsets.only(
                                                left: sw(10),
                                                right: sw(10),
                                                top: sh(10),
                                                bottom: sh(10)
                                            ),
                                            child: GestureDetector(
                                                onTap: () {
                                                    if(widget.itemBodyTap != null){
                                                        widget.itemBodyTap!(widget.itemBodyType);
                                                    }
                                                },
                                                child: widget.isOpenTextSelect && widget.itemBodyType == ChatViewItemRecordBodyType.text ? CustomSelectionArea(
                                                    itemBodyTextStyle: widget.itemBodyTextStyle,
                                                    onSelectionChanged: widget.onSelectionChanged,
                                                    contextMenuBuilder: widget.contextMenuBuilder,
                                                    selectionControls: widget.selectionControls,
                                                    createSelectableTextCallback: widget.createSelectableTextCallback,
                                                    child: _typeHandlerWidget(
                                                        onImageError: (exception, stackTrace) {
                                                            setState(() {});
                                                        },
                                                    ),
                                                ) : _typeHandlerWidget(
                                                    onImageError: (exception, stackTrace) {
                                                        setState(() {});
                                                    },
                                                )
                                            ),
                                        ),
                                        // 
                                    ],
                                ),
                            ),
                        ],
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
            
            // 图片内容
            final NetworkImage networkImage = NetworkImage('${widget.itemBody}');
            // 预览图片需要的内容
            final ChatImageListUtils chatImageListUtils = ChatImageListUtils(id: math.Random().nextInt(99) * DateTime.now().microsecondsSinceEpoch, imageProvider: networkImage);
            // 添加状态
            bool addStatus = false;
            
            double? width;
            double? height;

            try {

                networkImage.resolve(const ImageConfiguration()).addListener(ImageStreamListener((ImageInfo imageInfo, bool synchronousCall) { 

                    width = imageInfo.image.width * 1.0;
                    height = imageInfo.image.height * 1.0;

                    // 添加当前图片内容
                    if (!addStatus){
                        ChatImageList.addImageList(chatImageListUtils);
                    }
                    
                }));

            } catch (error) {
                debugPrint("chat_flutter 插件提示：图片 -> ${widget.itemBody} <- 信息获取失败");
            }

            Widget container = StatefulBuilder(
                builder: (context, setState) {

                    return GestureDetector(
                        onTap: () {
                            // 预览图片
                            if (!_imageLoadFailStatus && ChatImageList.isOpenPreviewImage) {

                                // 自定义预览回调
                                if (widget.customPreviewImageCallback != null){
                                    widget.customPreviewImageCallback!('${widget.itemBody}');
                                    return;
                                }

                                // 获取当前图片所在索引
                                int index = ChatImageList.indexWhereImageList((element) => element.id == chatImageListUtils.id);

                                List<ChatImageListUtils> listInfo = ChatImageList.imageList.reversed.toList();

                                previewImage(
                                    context: context, 
                                    imageList: listInfo,
                                    index: index,
                                    menuList: widget.previewImageLongPressMenu,
                                    onTapMenu: widget.onPreviewImageTapMenu,
                                    customLongPress: widget.customLongPress
                                );
                            }
                        },
                        child: Container(
                            width: _imageLoadFailStatus ? null : sz(width != null && width! > 160 ? 160 : width ?? 160),
                            height: _imageLoadFailStatus ? null : sz(height != null && height! > 160 ? 160 : height ?? 160),
                            decoration: BoxDecoration(
                                image: !_imageLoadFailStatus ? DecorationImage(
                                    fit: BoxFit.cover,
                                    image: networkImage,
                                    onError: (exception, stackTrace) {
                                        
                                        _imageLoadFailStatus = true;
                        
                                        if (onImageError != null){
                                            onImageError(exception, stackTrace);
                                        }
                                        
                                        setState((){});
                                    },
                                ) : null
                            ),
                            child: _imageLoadFailStatus ? Text(
                                '图片加载失败...',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: sf(15),
                                    color: Colors.black
                                ),
                            ) : null,
                        ),
                    );
                }
            );

            return GestureDetector(
                onTap: () {
                    if (widget.itemBodyMediaTap != null){
                        widget.itemBodyMediaTap!(ChatViewItemRecordBodyType.image);
                    }
                },
                child: container,
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
                                '${widget.itemBody ?? ""}',
                                softWrap: true,
                                style: widget.itemBodyTextStyle ?? TextStyle (
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
                    audioTimelength: widget.audioTimelength,
                    audioPlayStatus: widget.audioPlayStatus,
                ),
            );
        }
        // 文字
        else {
            return Text(
                '${widget.itemBody}',
                textAlign: TextAlign.left,
                softWrap: true,
                style: widget.itemBodyTextStyle ?? TextStyle(
                    fontSize: sf(15),
                    color: Colors.black
                ),
            );
        }
    }
}


/// 需要排除样式内容显示的内容类型
bool excludeContentType (ChatViewItemRecordBodyType type) => [ChatViewItemRecordBodyType.image].contains(type);



