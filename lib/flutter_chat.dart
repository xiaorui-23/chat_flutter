
library flutter_chat;

import 'package:flutter/widgets.dart';
import 'package:flutter_chat/utils/screenutil/screenutil.dart';
import 'package:flutter_chat/widgets/chatViewItem/chatViewItem.dart';



export 'package:flutter_chat/widgets/chatViewItem/chatViewItem.dart';
export 'package:flutter_chat/utils/chatViewItemRecordBodyType/chatViewItemRecordBodyType.dart';


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

        return Container(
            child: ListView.builder(
                controller: _chatViewWidgetController,
                padding: const EdgeInsets.all(0),
                physics: const AlwaysScrollableScrollPhysics(),
                reverse: true,
                shrinkWrap: true,
                itemCount: (widget.children ?? []).length,
                itemBuilder: (BuildContext context, int index) => widget.children![index]
            ),
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

