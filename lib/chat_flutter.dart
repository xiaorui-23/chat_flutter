
library chat_flutter;

import 'package:chat_flutter/utils/chat_image_list/chat_image_list.dart';
import 'package:flutter/widgets.dart';
import 'package:chat_flutter/utils/screenutil/screenutil.dart';
import 'package:chat_flutter/widgets/chat_view_item/chat_view_item.dart';
export 'package:chat_flutter/widgets/chat_view_item/chat_view_item.dart';
export 'package:chat_flutter/utils/chat_view_item_record_body_type/chat_view_item_record_body_type.dart';


/// 聊天记录页面容器
class ChatViewWidget extends StatefulWidget {

    /// 记录列表
    final List<ChatViewItem>? children;
    /// 初始渲染时是否滑动到底部
    final bool isNeedScrollBottom;
    /// 是否开启图片预览
    final bool isOpenPreviewImage;
    /// 创建完成时
    final void Function(ScrollController chatViewWidgetController)? onCreated;

    const ChatViewWidget({
        super.key,
        this.children,
        this.isNeedScrollBottom = false,
        this.isOpenPreviewImage = false,
        this.onCreated
    });

    @override
    State<ChatViewWidget> createState() => _ChatViewWidgetState();
}

class _ChatViewWidgetState extends State<ChatViewWidget> {
    final ScrollController _chatViewWidgetController = ScrollController();

    /// 记录列表
    List<ChatViewItem>? _children = [];

    @override
    void initState() {
        super.initState();

        Future.delayed(const Duration(milliseconds: 600), () {
            if (widget.onCreated != null){
                widget.onCreated!(_chatViewWidgetController);
            }
        });
    }

    @override
    void dispose() {
        _chatViewWidgetController.dispose();

        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        initScreenUtil(context);

        // 对一些需要在构建时需要进行修改的参数进行修改
        _buildModifyParam ();

        // 根据 初始渲染时是否需要滑动到底部 状态进行设置
        _initStateScrollBottom ();
        

        return ListView.builder(
            controller: _chatViewWidgetController,
            padding: const EdgeInsets.all(0),
            physics: const AlwaysScrollableScrollPhysics(),
            reverse: widget.isNeedScrollBottom,
            shrinkWrap: true,
            itemCount: (_children ?? []).length,
            itemBuilder: (BuildContext context, int index) => _children![index]
        );
    }

    /// 根据 初始渲染时是否需要滑动到底部 状态进行设置
    void _initStateScrollBottom () {
        _children = widget.children;

        if (!widget.isNeedScrollBottom){
            return;
        }

        _children = widget.children!.reversed.toList();

    }

    /// 对一些需要在构建时需要进行修改的参数进行修改
    void _buildModifyParam () {
        // 修改当前图片可预览状态
        ChatImageList.modyfyIsOpenPreviewImage(status: widget.isOpenPreviewImage);
        // 修改当前翻转状态
        ChatImageList.modifyIsNeedScrollBottom(widget.isNeedScrollBottom);
        // 在每次构建主体时清除所有内容
        ChatImageList.clearImageList();
    }

}

