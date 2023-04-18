
library chat_flutter;

import 'package:flutter/widgets.dart';
import 'package:chat_flutter/utils/screenutil/screenutil.dart';
import 'package:chat_flutter/widgets/chat_view_item/chat_view_item.dart';



export 'package:chat_flutter/widgets/chat_view_item/chat_view_item.dart';
export 'package:chat_flutter/utils/chat_view_item_record_body_type/chat_view_item_record_body_type.dart';


/// 聊天记录页面容器
class ChatViewWidget extends StatefulWidget {
    ChatViewWidget({
        super.key,
        this.children,
        this.isNeedScrollBottom = false,
        this.onCreated
    });


    /// 记录列表
    List<ChatViewItem>? children = [];
    /// 初始渲染时是否滑动到底部
    bool isNeedScrollBottom;
    /// 创建完成时
    Function(ScrollController chatViewWidgetController)? onCreated;

    @override
    State<ChatViewWidget> createState() => _ChatViewWidgetState();
}

class _ChatViewWidgetState extends State<ChatViewWidget> {
    final ScrollController _chatViewWidgetController = ScrollController();

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

        // 根据 初始渲染时是否需要滑动到底部 状态进行设置
        _initStateScrollBottom();

        return ListView.builder(
            controller: _chatViewWidgetController,
            padding: const EdgeInsets.all(0),
            physics: const AlwaysScrollableScrollPhysics(),
            reverse: widget.isNeedScrollBottom,
            shrinkWrap: true,
            itemCount: (widget.children ?? []).length,
            itemBuilder: (BuildContext context, int index) => widget.children![index]
        );
    }

    /// 根据 初始渲染时是否需要滑动到底部 状态进行设置
    void _initStateScrollBottom () {
        if (!widget.isNeedScrollBottom){
            return;
        }

        widget.children = widget.children!.reversed.toList();

    }
}

