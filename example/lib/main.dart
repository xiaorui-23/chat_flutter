
import 'package:flutter/material.dart';
import 'package:chat_flutter/chat_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
    const MyApp({super.key});

    @override
    State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    FocusNode? _focusNode;

    List<ChatViewItem> chatRecordList = [];

    @override
    void initState() {

        super.initState();
        
        chatRecordList = [
            const ChatViewItem(
                itemBody: "hello",
            ),
            const ChatViewItem(
                senderRight: false,
                itemBody: "Hi",
            ),
            const ChatViewItem(
                itemBody: "不显示头像",
                isAvatarShow: false,
                isOpenTextSelect: true
            ),
            const ChatViewItem(
                itemBodyType: ChatViewItemRecordBodyType.audio,
            ),
            const ChatViewItem(
                audioTimelength: 10,
                itemBodyType: ChatViewItemRecordBodyType.audio,
            ),
            const ChatViewItem(
                senderRight: false,
                itemBody: "Hi, 就阿萨德理解啊睡了多久啊是 啊可是建档立卡上的结论是",
            ),
            const ChatViewItem(
                customItem: Text('自定义消息主体'),
            ),
            ChatViewItem(
                isOpenTextSelect: true,
                itemBody: "我是长按文字会出现菜单的文字",
                createSelectableTextCallback:(focusNode) {
                    _focusNode = focusNode;
                },
            ),
            const ChatViewItem(
                senderRight: false,
                avatarPath: "https://img1.baidu.com/it/u=3007048469,3759326707&fm=253&fmt=auto&app=120&f=JPEG?w=889&h=500",
                itemBodyRecordTime: '2023-12-13',
                itemBody: "带记录时间",
            ),
            ChatViewItem(
                itemBodyType: ChatViewItemRecordBodyType.image,
                itemBody: "https://pic35.photophoto.cn/20150511/0034034892281415_b.jpg",
                previewImageLongPressMenu: const ['保存'],
                onPreviewImageTapMenu:(data, index, menuList) {
                    debugPrint("$data $index $menuList");
                },
                // customPreviewImageCallback:(imagePath) {
                //     print(imagePath);
                // },
                // customLongPress:(context) {
                //     print('customLongPress');
                // },
            ),
            const ChatViewItem(
                senderRight: false,
                itemBodyType: ChatViewItemRecordBodyType.image,
                itemBody: "https://img1.baidu.com/it/u=3007048469,3759326707&fm=253&fmt=auto&app=120&f=JPEG?w=889&h=500",
            ),
            const ChatViewItem(
                senderRight: false,
                itemBodyType: ChatViewItemRecordBodyType.image,
                itemBody: "https://img1.baidu.com",
            ),
            const ChatViewItem(
                senderRight: false,
                avatarPath: "https://img1.baidu.com/it/u=3007048469,3759326707&fm=253&fmt=auto&app=120&f=JPEG?w=889&h=500",
                itemBody: "头像网络图片",
            ),
            const ChatViewItem(
                avatarPath: "assets/logo.png",
                itemBody: "头像本地图片",
            ),
            const ChatViewItem(
                itemBodyType: ChatViewItemRecordBodyType.file,
                itemBody: "我是文件名称",
            ),
        ];
    }
    

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            home: Scaffold(
                appBar: AppBar(
                    centerTitle: true,
                    // title: const Text('chat_flutter 插件展示案例'),
                ),
                backgroundColor: const Color.fromARGB(255, 239, 238, 234),
                body: GestureDetector(
                    onTap: () {
                        if (_focusNode != null){
                            _focusNode!.unfocus();
                        }
                    },
                    child: Column(
                        children: [
                            Expanded(
                                child: ChatViewWidget(
                                    isNeedScrollBottom: true,
                                    // isOpenPreviewImage: true,
                                    children: chatRecordList,
                                    onCreated: (chatViewWidgetController) {},
                                )
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}

