import 'package:chat_flutter/utils/chat_image_list/chat_image_list.dart';
import 'package:chat_flutter/utils/screenutil/screenutil.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

/// 预览图片
/// * [context] BuildContext
/// * [imageList] 图片列表
/// * [index] 当前加载展示图片索引
/// * [menuList] 菜单列表
/// * [onTapMenu] 点击菜单选项的回调
/// * [customLongPress] 自定义长按显示菜单回调
void previewImage(
    {int index = 0,
    List<String>? menuList,
    required BuildContext context,
    required List<ChatImageListUtils> imageList,
    void Function(String data, int index, List<String> menuList)? onTapMenu,
    void Function(BuildContext context)? customLongPress}) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: _PreviewImageWidget(
                imageList: imageList,
                index: index,
                menuList: menuList,
                onTapMenu: onTapMenu,
                customLongPress: customLongPress),
          ));
}

class _PreviewImageWidget extends StatefulWidget {
  /// 图片列表
  final List<ChatImageListUtils> imageList;

  /// 当前加载展示图片索引
  final int index;

  /// 菜单列表
  final List<String>? menuList;

  /// 点击菜单选项的回调
  final void Function(String data, int index, List<String> menuList)? onTapMenu;

  /// 自定义长按显示菜单回调
  final void Function(BuildContext context)? customLongPress;

  const _PreviewImageWidget(
      {required this.imageList,
      this.menuList,
      this.onTapMenu,
      this.customLongPress,
      this.index = 0});

  @override
  State<_PreviewImageWidget> createState() => _PreviewImageWidgetState();
}

class _PreviewImageWidgetState extends State<_PreviewImageWidget> {
  /// pageView 控制器
  PageController? previewImageWidgetPageController;

  @override
  void initState() {
    super.initState();

    if (widget.index != 0) {
      previewImageWidgetPageController =
          PageController(initialPage: widget.index);
    }
  }

  @override
  void dispose() {
    previewImageWidgetPageController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: sw(375),
      height: sh(750),
      child: PageView.builder(
          controller: previewImageWidgetPageController,
          physics: widget.imageList.length > 1
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          itemCount: widget.imageList.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
                onLongPress: () {
                  if (widget.customLongPress != null) {
                    widget.customLongPress!(context);

                    return;
                  }

                  longPressShowMenu(
                      menuList: widget.menuList, onTapMenu: widget.onTapMenu);
                },
                child: PhotoView(
                    imageProvider: widget.imageList[index].imageProvider),
              )),
    );
  }

  /// 长按图片显示菜单
  /// * [menuList] 菜单列表
  /// * [onTapMenu] 点击菜单选项的回调
  void longPressShowMenu(
      {List<String>? menuList,
      void Function(String data, int index, List<String> menuList)?
          onTapMenu}) {
    if (menuList == null || menuList.isEmpty) {
      return;
    }

    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        useSafeArea: true,
        constraints: BoxConstraints(
            minWidth: sw(375),
            maxWidth: sw(375),
            maxHeight: sh(200),
            minHeight: sh(50)),
        builder: (context) => SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int index = 0, len = menuList.length;
                      index < len;
                      index++)
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);

                        if (onTapMenu != null) {
                          onTapMenu(menuList[index], index, menuList);
                        }
                      },
                      child: Container(
                        width: sw(355),
                        margin: EdgeInsets.only(top: sh(index == 0 ? 0 : 8)),
                        padding: EdgeInsets.only(
                            top: sh(10),
                            right: sw(20),
                            bottom: sh(10),
                            left: sw(20)),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(sr(10))),
                        alignment: Alignment.center,
                        child: Text(
                          menuList[index],
                          style: TextStyle(fontSize: sf(16)),
                        ),
                      ),
                    ),
                  //
                ],
              ),
            ));
  }
}
