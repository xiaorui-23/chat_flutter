
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chat_flutter/chat_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
    const MyApp({super.key});

    @override
    State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    FocusNode? _focusNode;

    List<ChatViewItem> chatRecordList = [];

    ChatViewWidgetController? _chatViewWidgetController;

    @override
    void initState() {
        super.initState();

        // 模拟从接口获取到数据
        _getListInfo ();
    }
    

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            locale: const Locale('zh'),
            localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate
            ],
            supportedLocales: const [Locale('zh', 'CH')],
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
                                child: 
                                ChatViewWidget(
                                    isNeedScrollBottom: true,
                                    isOpenPreviewImage: true,
                                    children: chatRecordList,
                                    onCreated:(chatViewWidgetListViewController, chatViewWidgetController) {
                                        _chatViewWidgetController = chatViewWidgetController;
                                        // 模拟发送消息
                                        Future.delayed(const Duration(seconds: 3), () {
                                            chatViewWidgetController.add(const ChatViewItem(
                                                senderRight: false,
                                                itemBodyType: ChatViewItemRecordBodyType.image,
                                                itemBody: "https://pic35.photophoto.cn/20150511/0034034892281415_b.jpg",
                                            ));
                                        });

                                        // Timer.periodic(const Duration(seconds: 3), (timer) { 
                                        //     chatViewWidgetController.add(const ChatViewItem(
                                        //         senderRight: false,
                                        //         itemBodyType: ChatViewItemRecordBodyType.image,
                                        //         itemBody: "https://pic35.photophoto.cn/20150511/0034034892281415_b.jpg",
                                        //     ));
                                        // });
                                    },
                                )
                            ),
                        ],
                    ),
                ),
            ),
        );
    }

    /// 模拟接口请求
    void _getListInfo () {
        Future.delayed(const Duration(milliseconds: 1000), () {
            _chatViewWidgetController?.addAll([
                const ChatViewItem(
                    itemBody: "hello",
                ),
                const ChatViewItem(
                    senderRight: false,
                    itemBody: "Hi",
                ),
                ChatViewItem(
                    itemBody: "不显示头像",
                    avatarModel: ChatViewItemAvatarModel(
                        isAvatarShow: false,
                    ),
                    textTypeModel: ChatViewItemTextTypeModel(
                        isOpenTextSelect: true
                    ),
                ),
                ChatViewItem(
                    audioTypeModel: ChatViewItemAudioTypeModel(
                        audioTimelength: 10,
                    ),
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
                    textTypeModel: ChatViewItemTextTypeModel(
                        isOpenTextSelect: true,
                        createSelectableTextCallback:(focusNode) {
                            // _focusNode = focusNode;
                        },
                    ),
                    itemBody: "我是长按文字会出现菜单的文字",
                ),
                ChatViewItem(
                    senderRight: false,
                    avatarModel: ChatViewItemAvatarModel(
                        avatarPath: "https://img1.baidu.com/it/u=3007048469,3759326707&fm=253&fmt=auto&app=120&f=JPEG?w=889&h=500",
                    ),
                    itemBodyRecordTime: '2023-12-13',
                    itemBody: "带记录时间",
                ),
                ChatViewItem(
                    itemBodyType: ChatViewItemRecordBodyType.image,
                    itemBody: "https://pic35.photophoto.cn/20150511/0034034892281415_b.jpg",
                    imageTypeModel: ChatViewItemImageTypeModel(
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
                ),
                const ChatViewItem(
                    itemBodyType: ChatViewItemRecordBodyType.video,
                    // itemBody: 'https://video.shipin520.com/videos/27/20/14/a_px8biQt0w0Dp1563272014_10s.mp4',
                    itemBody: "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
                    // videoTypeModel: ChatViewItemVideoTypeModel(
                    //     videoLoadFailCallback: (error) {},
                    //     notPlayingWidget: const Text('not Playing Widget'),
                    //     playingFailWidget: const Text('playing Fail Widget'),
                    //     autoPlaying: true,
                    // ),
                ),
                const ChatViewItem(
                    senderRight: false,
                    itemBodyType: ChatViewItemRecordBodyType.image,
                    itemBody: "https://img1.baidu.com",
                ),
                ChatViewItem(
                    senderRight: false,
                    avatarModel: ChatViewItemAvatarModel(
                        avatarPath: "https://img1.baidu.com/it/u=3007048469,3759326707&fm=253&fmt=auto&app=120&f=JPEG?w=889&h=500",
                    ),
                    itemBody: "头像网络图片",
                ),
                ChatViewItem(
                    avatarModel: ChatViewItemAvatarModel(
                        avatarPath: "https://img1.baidu.com/it/u=30070484691,3759326707&fm=253&fmt=auto&app=120&f=JPEG?w=889&h=500",
                    ),
                    itemBody: "错误头像图片地址",
                ),
                ChatViewItem(
                    avatarModel: ChatViewItemAvatarModel(
                        avatarPath: "assets/logo.png",
                    ),    
                    itemBody: "头像本地图片",
                ),
                const ChatViewItem(
                    senderRight: false,
                    itemBodyType: ChatViewItemRecordBodyType.image,
                    itemBody: "https://img1.baidu.com/it/u=3007048469,3759326707&fm=253&fmt=auto&app=120&f=JPEG?w=889&h=500",
                ),
                const ChatViewItem(
                    itemBodyType: ChatViewItemRecordBodyType.file,
                    itemBody: "我是文件名称",
                ),
            ]);

        });
    
    }
}

