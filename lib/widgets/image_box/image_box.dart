
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
    NetworkImage get networkImage => NetworkImage(widget.imagePath);
    // 预览图片需要的内容
    ChatImageListUtils? chatImageListUtils;
    // 添加状态
    bool addStatus = false;
    /// 图片宽度
    double width = 160;
    /// 图片高度
    double height = 160;

    @override
    Widget build(BuildContext context) {
        return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
                // 图片内容
                GestureDetector(
                    onTap: () {
                        if (widget.imageLoadFailStatus) {
                            return;
                        }
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
                    child:FutureBuilder(
                        future: _getImageInfo(),
                        builder:(context, snapshot) {
                            if (snapshot.error == null && (snapshot.connectionState != ConnectionState.done || snapshot.data == null)) {
                                return SizedBox(
                                    width: sz(20),
                                    height: sz(20),
                                    child: CircularProgressIndicator(
                                        strokeWidth: sz(2),
                                    ),
                                );
                            }

                            width = snapshot.data!.image.width * 1.0;
                            height = snapshot.data!.image.height * 1.0;

                            return Container(
                                width: sz(width),
                                height: sz(height),
                                constraints: BoxConstraints(
                                    maxWidth: sz(160),
                                    maxHeight: sz(160)
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0)
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image(
                                    width: sz(width),
                                    height: sz(height),
                                    fit: BoxFit.cover,
                                    image: networkImage,
                                    errorBuilder: (context, error, stackTrace) {
                                        if (widget.onImageError != null){
                                            widget.onImageError!(error, stackTrace);
                                        }

                                        return Text(
                                            '图片加载失败...',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: sf(15),
                                                color: Colors.black
                                            ),
                                        );
                                    },
                                )
                            );
                        }
                    ),
                ),
                // 
            ],
        );
    }

    /// 获取图片信息
    Future<ImageInfo?> _getImageInfo () async {
        chatImageListUtils = ChatImageListUtils(id: math.Random().nextInt(99) * DateTime.now().microsecondsSinceEpoch, imageProvider: networkImage);
        ImageStream imageStream = networkImage.resolve(const ImageConfiguration());
        ImageInfo? imageInfoData;
        
        ImageStreamListener? listener;
        listener = ImageStreamListener((ImageInfo imageInfo, bool synchronousCall) { 
            // 添加当前图片内容
            if (!addStatus){
                ChatImageList.addImageList(chatImageListUtils!);
            }

            imageInfoData = imageInfo;

            imageStream.removeListener(listener!);
        });

        imageStream.addListener(listener);

        return imageInfoData;
    }
}