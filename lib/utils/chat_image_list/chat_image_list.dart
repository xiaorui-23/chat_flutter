
import 'package:flutter/rendering.dart';

/// 图片记录集合 工具类

class ChatImageList {
    /// 初始渲染时是否滑动到底部
    static bool _isNeedScrollBottom = false;
    /// 初始渲染时是否滑动到底部
    static bool get isNeedScrollBottom => _isNeedScrollBottom;

    /// 当前是否开启图片预览状态
    static bool _isOpenPreviewImage = false;
    /// 当前是否开启图片预览状态
    static bool get isOpenPreviewImage => _isOpenPreviewImage;

    /// 图片记录集合
    static final List<ChatImageListUtils> _imageList = [];
    /// 图片记录集合
    static List<ChatImageListUtils> get imageList => _imageList;


    /// 修改当前可预览状态
    static void modyfyIsOpenPreviewImage ({required bool status}) => _isOpenPreviewImage = status;

    /// 修改 初始渲染时是否滑动到底部 状态
    static void modifyIsNeedScrollBottom (bool status) => _isNeedScrollBottom = status;

    /// 对当前图片记录集合进行操作
    
    /// 清空
    static void clearImageList () =>  _imageList.clear();

    /// 添加
    static void addImageList (ChatImageListUtils chatImageListUtils) => _imageList.add(chatImageListUtils);

    /// 索引查找
    static int indexWhereImageList (bool Function(ChatImageListUtils element) condition) {
        List<ChatImageListUtils> list = _imageList;
        
        list = _imageList.reversed.toList();

        return list.indexWhere(condition);
    }


}

/// 标记生成当前唯一内容
class ChatImageListUtils {
    /// 唯一 ID
    int id;
    /// 图片内容
    ImageProvider imageProvider;

    ChatImageListUtils({
        required this.id,
        required this.imageProvider
    });
}