import 'dart:ui' as ui;
import 'package:chat_flutter/utils/chat_image_list/chat_image_list.dart';
import 'package:chat_flutter/utils/parameter_model_set/parameter_model_set.dart';
import 'package:chat_flutter/utils/screenutil/screenutil.dart';
import 'package:chat_flutter/utils/preview_image/preview_image.dart';
import 'package:flutter/material.dart';

/// 图片盒子

class ImageBox extends StatelessWidget {
  /// 图片路径
  final String imagePath;

  /// 获取到的图片信息
  final ui.Image? imageInfo;

  /// 图片内容
  final ImageProvider? imageProviderInfo;

  /// 图片类型配置内容
  final ChatViewItemImageTypeModel imageTypeModel;

  /// 图片可加载状态
  /// * true 为可加载
  final bool isImageLoad;

  /// 预览图片需要的内容
  final ChatImageListUtils? chatImageListUtils;

  const ImageBox(
      {super.key,
      required this.imagePath,
      required this.imageTypeModel,
      required this.isImageLoad,
      this.imageProviderInfo,
      this.imageInfo,
      this.chatImageListUtils});

  /// 图片宽度
  double get width => imageInfo == null ? 160 : imageInfo!.width * 1.0;

  /// 图片高度
  double get height => imageInfo == null ? 160 : imageInfo!.height * 1.0;

  /// 图片最大展示宽度
  double get maxWidth => 160;

  /// 图片最大展示高度
  double get maxHeight => 160;

  @override
  Widget build(BuildContext context) {
    if (!isImageLoad) {
      Container();
    }

    return GestureDetector(
        onTap: () {
          // 预览图片
          if (ChatImageList.isOpenPreviewImage) {
            // 自定义预览回调
            if (imageTypeModel.customPreviewImageCallback != null) {
              imageTypeModel.customPreviewImageCallback!(imagePath);
              return;
            }

            // 获取当前图片所在索引
            int index = ChatImageList.indexWhereImageList(
                (element) => element.id == chatImageListUtils!.id);

            List<ChatImageListUtils> listInfo =
                ChatImageList.imageList.reversed.toList();

            previewImage(
                context: context,
                imageList: listInfo,
                index: index,
                menuList: imageTypeModel.previewImageLongPressMenu,
                onTapMenu: imageTypeModel.onPreviewImageTapMenu,
                customLongPress: imageTypeModel.customLongPress);
          }
        },
        child: Container(
            width: sz(width),
            height: sz(height),
            constraints: BoxConstraints(
                maxWidth: sz(maxWidth), maxHeight: sz(maxHeight)),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),
            clipBehavior: Clip.antiAlias,
            child: Image(
              width: sz(width),
              height: sz(height),
              fit: BoxFit.cover,
              image: imageProviderInfo!,
            )));
  }
}
