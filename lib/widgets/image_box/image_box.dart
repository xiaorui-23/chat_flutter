
import 'dart:math' as math;
import 'package:chat_flutter/utils/chat_image_list/chat_image_list.dart';
import 'package:chat_flutter/utils/parameter_model_set/parameter_model_set.dart';
import 'package:chat_flutter/utils/screenutil/screenutil.dart';
import 'package:chat_flutter/utils/preview_image/preview_image.dart';
import 'package:flutter/material.dart';

/// 图片盒子

class ImageBox extends StatefulWidget {
    /// 图片路径
    final String imagePath;
    /// 图片加载失败状态
    /// * true 为加载失败
    final bool imageLoadFailStatus;
    /// 图片加载失败回调
    final Function(Object exception, StackTrace? stackTrace)? onImageError;
    /// 图片类型配置内容
    final ChatViewItemImageTypeModel imageTypeModel;

    const ImageBox({
        super.key,
        required this.imageLoadFailStatus,
        required this.imagePath,
        required this.imageTypeModel,
        this.onImageError
    });

    @override
    State<ImageBox> createState() => _ImageBoxState();
}

class _ImageBoxState extends State<ImageBox> {
    // 图片内容
    NetworkImage? networkImage;
    // 预览图片需要的内容
    ChatImageListUtils? chatImageListUtils;
    // 添加状态
    bool addStatus = false;
    /// 图片宽度
    double width = 160;
    /// 图片高度
    double height = 160;

    @override
    void initState() {
        super.initState();

        networkImage = NetworkImage(widget.imagePath);

        if (networkImage != null){
            chatImageListUtils = ChatImageListUtils(id: math.Random().nextInt(99) * DateTime.now().microsecondsSinceEpoch, imageProvider: networkImage!);
        }

        try {

            networkImage?.resolve(const ImageConfiguration()).addListener(ImageStreamListener((ImageInfo imageInfo, bool synchronousCall) { 

                width = imageInfo.image.width * 1.0;
                height = imageInfo.image.height * 1.0;

                // 添加当前图片内容
                if (!addStatus){
                    ChatImageList.addImageList(chatImageListUtils!);
                }

                setState(() {
                  
                });
                
            }));

        } catch (error) {
            debugPrint("chat_flutter 插件提示：图片 -> ${widget.imagePath} <- 信息获取失败");
        }
    }

    @override
    Widget build(BuildContext context) {
        return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
                // 加载失败
                if (widget.imageLoadFailStatus) 
                    Text(
                        '图片加载失败...',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: sf(15),
                            color: Colors.black
                        ),
                    )
                else 
                // 加载成功
                    GestureDetector(
                        onTap: () {
                            // 预览图片
                            if (ChatImageList.isOpenPreviewImage) {

                                // 自定义预览回调
                                if (widget.imageTypeModel.customPreviewImageCallback != null){
                                    widget.imageTypeModel.customPreviewImageCallback!(widget.imagePath);
                                    return;
                                }

                                // 获取当前图片所在索引
                                int index = ChatImageList.indexWhereImageList((element) => element.id == chatImageListUtils!.id);

                                List<ChatImageListUtils> listInfo = ChatImageList.imageList.reversed.toList();

                                previewImage(
                                    context: context, 
                                    imageList: listInfo,
                                    index: index,
                                    menuList: widget.imageTypeModel.previewImageLongPressMenu,
                                    onTapMenu: widget.imageTypeModel.onPreviewImageTapMenu,
                                    customLongPress: widget.imageTypeModel.customLongPress
                                );
                            }
                        },
                        child: Container(
                            width: sz(width),
                            height: sz(height),
                            constraints: BoxConstraints(
                                maxWidth: sz(160),
                                maxHeight: sz(160)
                            ),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: networkImage!,
                                    onError: widget.onImageError,
                                )
                            ),
                        ),
                    ),
                // 
            ],
        );
    }
}