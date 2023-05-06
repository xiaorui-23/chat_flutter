

import 'package:chat_flutter/utils/screenutil/screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

/// 视频组件盒子

class VideoBox extends StatefulWidget {
    /// 视频资源地址
    final String videoPath;
    /// 消息主体背景色
    final Color backgroundColor;
    /// 未播放自定义 widget
    final Widget? notPlayingWidget;
    /// 播放错误自定义 widget
    final Widget? playingFailWidget;
    /// 在界面展示时是否自动播放
    final bool autoPlaying;
    /// 视频加载错误回调
    final void Function(Object error)? videoLoadFailCallback;

    const VideoBox({
        super.key,
        required this.videoPath,
        required this.backgroundColor,
        this.autoPlaying = true,
        this.notPlayingWidget,
        this.playingFailWidget,
        this.videoLoadFailCallback
    });

    @override
    State<VideoBox> createState() => _VideoBoxState();
}

class _VideoBoxState extends State<VideoBox> {
    /// 视频播放控制器
    VideoPlayerController? _videoBoxController;
    /// 初始化加载状态
    Future<void>? _videoBoxInitializeVideoPlayerFuture;
    /// 视频加载失败状态
    Object? _videoLoadFailError;
    /// 播放状态
    bool _videoIsPLaying = false;
    /// 是否已经播放过
    bool _videoPlayed = false;

    @override
    void initState() {
        super.initState();

        _videoBoxController = VideoPlayerController.network(widget.videoPath);

        _videoBoxInitializeVideoPlayerFuture = _videoBoxController?.initialize();
    }

    @override
    void dispose() {
        _videoBoxController?.removeListener(_videoBoxControllerBody);
        _videoBoxController?.dispose();
        
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: () {
                if (_videoLoadFailError == null) {
                    _fullScreenPlayVideo ();
                }
            },
            child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Container(
                    color: const Color.fromRGBO(0, 0, 0, 0.9),
                    child: FutureBuilder(
                        future: _videoBoxInitializeVideoPlayerFuture,
                        builder: (context, snapshot) {
                            // 加载完成
                            if (snapshot.connectionState == ConnectionState.done) {
                                _videoLoadFailError = snapshot.error;

                                // 执行错误回调
                                if (_videoLoadFailError != null && widget.videoLoadFailCallback != null){
                                    widget.videoLoadFailCallback!(_videoLoadFailError!);
                                }
            
                                // 自动播放视频
                                if (_videoLoadFailError == null && !_videoPlayed && widget.autoPlaying){
                                    Future.delayed(const Duration(milliseconds: 1000), () {
                                        if (mounted){
                                            _playVideo ();
            
                                            setState(() {
                                                
                                            });
                                        }
                                    });
                                }
            
                                return Stack(
                                    children: [
                                        // 视频
                                        VideoPlayer(_videoBoxController!),
                                        // 播放按钮
                                        if (!_videoIsPLaying)
                                            Positioned(
                                                child: Center(
                                                    child: snapshot.error == null ? widget.notPlayingWidget ?? Icon(
                                                        Icons.play_circle_outline_rounded,
                                                        size: sf(30),
                                                        color: Colors.white,
                                                    ) : widget.playingFailWidget ?? Icon(
                                                        Icons.cancel_outlined,
                                                        size: sf(30),
                                                        color: Colors.white,
                                                    ),
                                                )
                                            ),
                                        // 
                                    ],
                                );
                            }
                            // 加载中
                            return Container(
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(),
                            );
                        },
                    ),
                ),
            ),
        );
    }

    /// 播放视频
    void _playVideo () {
        // 静音播放
        _videoBoxController?.setVolume(0);
        // 播放
        _videoBoxController?.play();
        // 修改播放状态
        _videoIsPLaying = (_videoBoxController != null && _videoBoxController!.value.isPlaying);
        _videoPlayed = true;

        _videoBoxController?.addListener(_videoBoxControllerBody);
    }

    /// 播放控制器监听内容
    void _videoBoxControllerBody () {
        if (_videoBoxController != null && !_videoBoxController!.value.isPlaying){

            _videoIsPLaying = _videoBoxController!.value.isPlaying;
            
            if (mounted) setState(() {});
        }
    }

    /// 全屏播放视频
    void _fullScreenPlayVideo () {
        showModalBottomSheet(
            isScrollControlled: true,
            enableDrag: false,
            context: context, 
            builder: (ctx) => _FullScreenPlayVideoBox (
                videoPath: widget.videoPath,
                notPlayingWidget: widget.notPlayingWidget,
                playingFailWidget: widget.playingFailWidget,
                position: _videoBoxController?.value.position
            )
        );
    }
}

/// 全屏播放视频
class _FullScreenPlayVideoBox extends StatefulWidget {
    /// 视频资源地址
    final String videoPath;
    /// 未播放自定义 widget
    final Widget? notPlayingWidget;
    /// 播放错误自定义 widget
    final Widget? playingFailWidget;
    /// 当前播放的时长
    final Duration? position;

    const _FullScreenPlayVideoBox({
        required this.videoPath,
        this.notPlayingWidget,
        this.playingFailWidget,
        this.position
    });

    @override
    State<_FullScreenPlayVideoBox> createState() => _FullScreenPlayVideoBoxState();
}

class _FullScreenPlayVideoBoxState extends State<_FullScreenPlayVideoBox> {
    /// 视频播放控制器
    VideoPlayerController? _fullScreenPlayVideoBoxController;
    /// 初始化加载状态
    Future<void>? _fullScreenPlayVideoBoxInitializeVideoPlayerFuture;
    /// 视频加载失败状态
    Object? _videoLoadFailError;
    /// 播放状态
    bool _videoIsPLaying = false;
    /// 是否已经播放过
    bool _videoPlayed = false;
    /// 静音状态
    bool _muteStatus = true;
    /// 当前横屏状态
    bool _horizontalScreenStatus = false;
    /// 当前语言代码-默认英语
    String? _currentLocaleLanguageCountryCode = 'US';

    @override
    void initState() {
        super.initState();
        
        //不加这个强制横/竖屏会报错
        WidgetsFlutterBinding.ensureInitialized(); 
        SystemChrome.setPreferredOrientations([
            // 强制竖屏
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown
        ]);

        _fullScreenPlayVideoBoxController = VideoPlayerController.network(widget.videoPath);

        _fullScreenPlayVideoBoxInitializeVideoPlayerFuture = _fullScreenPlayVideoBoxController?.initialize();

        _fullScreenPlayVideoBoxController?.addListener(_videoBoxControllerBody);
    }

    @override
    void dispose() {
        // 恢复竖屏状态
        _verticalHorizontalScreenSwitching();

        _fullScreenPlayVideoBoxController?.removeListener(_videoBoxControllerBody);
        _fullScreenPlayVideoBoxController?.dispose();

        
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {

        _getLocaleLanguage();

        return GestureDetector(
            onTap: () {
                if (!_horizontalScreenStatus){
                    Navigator.pop(context);
                }
            },
            child: Container(
                color: Colors.black,
                child: Column(
                    children: [
                        // 顶部安全区
                        SizedBox(
                            width: sw(375),
                            height: getMediaQueryInfo(context).bottom,
                        ),
                        // 内容
                        Expanded(
                            child: !_horizontalScreenStatus ? 
                                // 竖屏
                                Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                        // 视频内容
                                        AspectRatio(
                                            aspectRatio: 4 / 3,
                                            child: FutureBuilder(
                                                future: _fullScreenPlayVideoBoxInitializeVideoPlayerFuture,
                                                builder: (context, snapshot) {
                                                    // 加载完成
                                                    if (snapshot.connectionState == ConnectionState.done) {
                                                        _videoLoadFailError = snapshot.error;
                                        
                                                        // 自动播放视频
                                                        if (_videoLoadFailError == null && !_videoPlayed){
                                                            Future.delayed(const Duration(milliseconds: 1000), () {
                                                                if (mounted){
                                                                    _playVideo ();
                                                                    
                                                                    setState(() {
                                                                        
                                                                    });
                                                                }
                                                            });
                                                        }
                                                                    
                                                        return Stack(
                                                            children: [
                                                                // 视频
                                                                VideoPlayer(_fullScreenPlayVideoBoxController!),
                                                                // 播放按钮
                                                                if (!_videoIsPLaying && !_fullScreenPlayVideoBoxController!.value.isPlaying)
                                                                    Positioned(
                                                                        child: Center(
                                                                            child: snapshot.error == null ? GestureDetector(
                                                                                onTap: () {
                                                                                    if (_fullScreenPlayVideoBoxController!.value.isPlaying){
                                                                                        _fullScreenPlayVideoBoxController?.pause();
                                                                                        _videoIsPLaying = false;
                                                                                    } else {
                                                                                        _fullScreenPlayVideoBoxController?.play();
                                                                                        _videoIsPLaying = true;
                                                                                    }
                                        
                                                                                    setState(() {
                                                                                    
                                                                                    });
                                                                                },
                                                                                child: widget.notPlayingWidget ?? Icon(
                                                                                    Icons.play_circle_outline_rounded,
                                                                                    size: sf(30),
                                                                                    color: Colors.white,
                                                                                ),
                                                                            ) : widget.playingFailWidget ?? Icon(
                                                                                Icons.cancel_outlined,
                                                                                size: sf(30),
                                                                                color: Colors.white,
                                                                            ),
                                                                        )
                                                                    ),
                                                                // 
                                                            ],
                                                        );
                                                    }
                                                    // 加载中
                                                    return const Center(
                                                        child: CircularProgressIndicator(),
                                                    );
                                                },
                                            ),
                                        ),
                                        // 工具栏
                                        if (_fullScreenPlayVideoBoxController != null)
                                            Container(
                                                width: sw(375),
                                                margin: EdgeInsets.only(
                                                    top: sh(10)
                                                ),
                                                child: Row(
                                                    children: [
                                                        // 暂停/播放
                                                        GestureDetector(
                                                            onTap: () {
                                                                if (_fullScreenPlayVideoBoxController!.value.isPlaying){
                                                                    _fullScreenPlayVideoBoxController?.pause();
                                                                    _videoIsPLaying = false;
                                                                } else {
                                                                    _fullScreenPlayVideoBoxController?.play();
                                                                    _videoIsPLaying = true;
                                                                }

                                                                setState(() {
                                                                
                                                                });
                                                            },
                                                            child: Icon(
                                                                _fullScreenPlayVideoBoxController!.value.isPlaying ? Icons.pause_circle_outline_rounded : Icons.play_circle_outline_rounded,
                                                                color: Colors.white,
                                                                size: sf(28),
                                                            ),
                                                        ),
                                                        // 进度条
                                                        Expanded(
                                                            child: Container(
                                                                margin: EdgeInsets.only(
                                                                    left: sw(10),
                                                                    right: sw(10)
                                                                ),
                                                                child: SliderTheme(
                                                                    data: SliderThemeData(
                                                                        thumbShape: RoundSliderThumbShape(
                                                                            enabledThumbRadius: sf(7)
                                                                        ),
                                                                        trackShape: _CustomRoundedRectSliderTrackShape()
                                                                    ),
                                                                    child: Slider(
                                                                        max: _fullScreenPlayVideoBoxController!.value.duration.inMilliseconds.truncateToDouble(),
                                                                        value: _fullScreenPlayVideoBoxController!.value.position.inMilliseconds.truncateToDouble(),
                                                                        onChanged: (newRating) {
                                                                            _fullScreenPlayVideoBoxController?.seekTo(Duration(milliseconds: newRating.truncate()));
                                                                            
                                                                            if (!_fullScreenPlayVideoBoxController!.value.isPlaying && mounted){
                                                                                _fullScreenPlayVideoBoxController?.play();
                                                                                _videoIsPLaying = true;
                                                                                setState(() {
                                                                                    
                                                                                });
                                                                            }
                                                                        },
                                                                    ),
                                                                ),
                                                            ),
                                                        ),
                                                        // 播放进度
                                                        Container(
                                                            margin: EdgeInsets.only(
                                                                left: sw(5)
                                                            ),
                                                            child: Text(
                                                                _timeLengthSplit(_fullScreenPlayVideoBoxController!.value.position, _fullScreenPlayVideoBoxController!.value.duration),
                                                                style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: sf(12)
                                                                ),
                                                            ),
                                                        ),
                                                        // 静音/未静音
                                                        GestureDetector(
                                                            onTap: () {
                                                                if (_muteStatus){
                                                                    _muteStatus = false;
                                                                    _fullScreenPlayVideoBoxController?.setVolume(0.5);
                                                                } else {
                                                                    _muteStatus = true;
                                                                    _fullScreenPlayVideoBoxController?.setVolume(0);
                                                                }

                                                                setState(() {
                                                                
                                                                });
                                                            },
                                                            child: Container(
                                                                margin: EdgeInsets.only(
                                                                    left: sw(5)
                                                                ),
                                                                child: Icon(
                                                                    _muteStatus ? Icons.volume_off_sharp : Icons.volume_up,
                                                                    color: Colors.white,
                                                                    size: sf(24),
                                                                ),
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                            ),
                                        // 横屏播放
                                        GestureDetector(
                                            onTap: () {
                                                if (!_horizontalScreenStatus) {
                                                    _verticalHorizontalScreenSwitching(status: 0);
                                                    _horizontalScreenStatus = true;
                                                }
                                            },
                                            child: Container(
                                                width: sw(['zh', 'CH'].contains(_currentLocaleLanguageCountryCode) ? 80 : 150),
                                                height: sh(30),
                                                margin: EdgeInsets.only(
                                                    top: sh(20)
                                                ),
                                                decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    border: Border.all(
                                                        width: sz(1),
                                                        color: Colors.white
                                                    ),
                                                    borderRadius: BorderRadius.circular(sr(30))
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                    _localeLanguageHorizontalScreenMessage(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: sf(12)
                                                    ),
                                                ),
                                            ),
                                        ),
                                        // 
                                    ],
                                ) 
                                : 
                                // 横屏
                                Stack(
                                    children: [
                                        // 视频内容
                                        if (_horizontalScreenStatus)
                                            SizedBox(
                                                width: sh(700),
                                                // aspectRatio: 16 / 9,
                                                child: FutureBuilder(
                                                    future: _fullScreenPlayVideoBoxInitializeVideoPlayerFuture,
                                                    builder: (context, snapshot) {
                                                        // 加载完成
                                                        if (snapshot.connectionState == ConnectionState.done) {
                                                            _videoLoadFailError = snapshot.error;
                                            
                                                            // 自动播放视频
                                                            if (_videoLoadFailError == null && !_videoPlayed){
                                                                Future.delayed(const Duration(milliseconds: 1000), () {
                                                                    if (mounted){
                                                                        _playVideo ();
                                                                        
                                                                        setState(() {
                                                                            
                                                                        });
                                                                    }
                                                                });
                                                            }
                                                                        
                                                            return Stack(
                                                                children: [
                                                                    // 视频
                                                                    VideoPlayer(_fullScreenPlayVideoBoxController!),
                                                                    // 播放按钮
                                                                    if (!_videoIsPLaying && !_fullScreenPlayVideoBoxController!.value.isPlaying)
                                                                        Positioned(
                                                                            child: Center(
                                                                                child: snapshot.error == null ? GestureDetector(
                                                                                    onTap: () {
                                                                                        if (_fullScreenPlayVideoBoxController!.value.isPlaying){
                                                                                            _fullScreenPlayVideoBoxController?.pause();
                                                                                            _videoIsPLaying = false;
                                                                                        } else {
                                                                                            _fullScreenPlayVideoBoxController?.play();
                                                                                            _videoIsPLaying = true;
                                                                                        }
                                            
                                                                                        setState(() {
                                                                                        
                                                                                        });
                                                                                    },
                                                                                    child: widget.notPlayingWidget ?? Icon(
                                                                                        Icons.play_circle_outline_rounded,
                                                                                        size: sf(35),
                                                                                        color: Colors.white,
                                                                                    ),
                                                                                ) : widget.playingFailWidget ?? Icon(
                                                                                    Icons.cancel_outlined,
                                                                                    size: sf(30),
                                                                                    color: Colors.white,
                                                                                ),
                                                                            )
                                                                        ),
                                                                    // 
                                                                ],
                                                            );
                                                        }
                                                        // 加载中
                                                        return const Center(
                                                            child: CircularProgressIndicator(),
                                                        );
                                                    },
                                                ),
                                            ),
                                        // 工具栏
                                        if (_fullScreenPlayVideoBoxController != null)
                                            Positioned(
                                                left: 0,
                                                bottom: 0,
                                                child: Container(
                                                    width: sh(700),
                                                    padding: EdgeInsets.only(
                                                        left: sh(10),
                                                        right: sh(10)
                                                    ),
                                                    decoration: const BoxDecoration(
                                                        color: Color.fromRGBO(0, 0, 0, 0.2)
                                                    ),
                                                    child: Row(
                                                        children: [
                                                            // 暂停/播放
                                                            GestureDetector(
                                                                onTap: () {
                                                                    if (_fullScreenPlayVideoBoxController!.value.isPlaying){
                                                                        _fullScreenPlayVideoBoxController?.pause();
                                                                        _videoIsPLaying = false;
                                                                    } else {
                                                                        _fullScreenPlayVideoBoxController?.play();
                                                                        _videoIsPLaying = true;
                                                                    }
                                                
                                                                    setState(() {
                                                                    
                                                                    });
                                                                },
                                                                child: Icon(
                                                                    _fullScreenPlayVideoBoxController!.value.isPlaying ? Icons.pause_circle_outline_rounded : Icons.play_circle_outline_rounded,
                                                                    color: Colors.white,
                                                                    size: sf(35),
                                                                ),
                                                            ),
                                                            // 进度条
                                                            Expanded(
                                                                child: Container(
                                                                    margin: EdgeInsets.only(
                                                                        left: sh(10),
                                                                        right: sh(10)
                                                                    ),
                                                                    child: SliderTheme(
                                                                        data: SliderThemeData(
                                                                            thumbShape: RoundSliderThumbShape(
                                                                                enabledThumbRadius: sf(7)
                                                                            ),
                                                                            trackShape: _CustomRoundedRectSliderTrackShape()
                                                                        ),
                                                                        child: Slider(
                                                                            max: _fullScreenPlayVideoBoxController!.value.duration.inMilliseconds.truncateToDouble(),
                                                                            value: _fullScreenPlayVideoBoxController!.value.position.inMilliseconds.truncateToDouble(),
                                                                            onChanged: (newRating) {
                                                                                _fullScreenPlayVideoBoxController?.seekTo(Duration(milliseconds: newRating.truncate()));
                                                                                
                                                                                if (!_fullScreenPlayVideoBoxController!.value.isPlaying && mounted){
                                                                                    _fullScreenPlayVideoBoxController?.play();
                                                                                    _videoIsPLaying = true;
                                                                                    setState(() {
                                                                                        
                                                                                    });
                                                                                }
                                                                            },
                                                                        ),
                                                                    ),
                                                                ),
                                                            ),
                                                            // 播放进度
                                                            Container(
                                                                margin: EdgeInsets.only(
                                                                    left: sh(5)
                                                                ),
                                                                child: Text(
                                                                    _timeLengthSplit(_fullScreenPlayVideoBoxController!.value.position, _fullScreenPlayVideoBoxController!.value.duration),
                                                                    style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: sf(15)
                                                                    ),
                                                                ),
                                                            ),
                                                            // 静音/未静音
                                                            GestureDetector(
                                                                onTap: () {
                                                                    if (_muteStatus){
                                                                        _muteStatus = false;
                                                                        _fullScreenPlayVideoBoxController?.setVolume(0.5);
                                                                    } else {
                                                                        _muteStatus = true;
                                                                        _fullScreenPlayVideoBoxController?.setVolume(0);
                                                                    }
                                                
                                                                    setState(() {
                                                                    
                                                                    });
                                                                },
                                                                child: Container(
                                                                    margin: EdgeInsets.only(
                                                                        left: sh(5)
                                                                    ),
                                                                    child: Icon(
                                                                        _muteStatus ? Icons.volume_off_sharp : Icons.volume_up,
                                                                        color: Colors.white,
                                                                        size: sf(25),
                                                                    ),
                                                                ),
                                                            ),
                                                            // 竖屏切换
                                                            GestureDetector(
                                                                onTap: () {
                                                                    if (_horizontalScreenStatus){

                                                                        _horizontalScreenStatus = false;

                                                                        setState(() {
                                                                        
                                                                        });

                                                                        // 修改当前横竖屏状态
                                                                        _verticalHorizontalScreenSwitching();

                                                                    }
                                                                    
                                                                },
                                                                child: Container(
                                                                    margin: EdgeInsets.only(
                                                                        left: sh(5)
                                                                    ),
                                                                    child: Icon(
                                                                        Icons.crop_rotate_rounded,
                                                                        color: Colors.white,
                                                                        size: sf(25),
                                                                    ),
                                                                ),
                                                            ),
                                                            // 
                                                        ],
                                                    ),
                                                ),
                                            ),
                                        // 
                                    ],
                                )
                        ),
                        // 底部安全区
                        SizedBox(
                            width: sw(375),
                            height: getMediaQueryInfo(context).bottom,
                        ),
                    ],
                )
            )
        );
    }

    /// 播放视频
    void _playVideo () {
        // 静音播放
        _fullScreenPlayVideoBoxController?.setVolume(0);
        // 播放
        _fullScreenPlayVideoBoxController?.play();
        
        // 继承在聊天界面展示的播放记录
        if (widget.position != null && widget.position != null && widget.position?.inMilliseconds != _fullScreenPlayVideoBoxController?.value.duration.inMilliseconds) {
            _fullScreenPlayVideoBoxController?.seekTo(widget.position!);
        }

        // 修改播放状态
        _videoIsPLaying = (_fullScreenPlayVideoBoxController != null && _fullScreenPlayVideoBoxController!.value.isPlaying);
        // 播放过状态
        _videoPlayed = true;
    }

    /// 播放控制器监听内容
    void _videoBoxControllerBody () {
        // 判断是否处于播放中，进行刷新页面 ui 进行进度条进度展示
        if (_fullScreenPlayVideoBoxController!.value.isPlaying && mounted){
            setState(() {
              
            });
        }

        // 判断播放状态并修改依赖状态
        if (_fullScreenPlayVideoBoxController != null && !_fullScreenPlayVideoBoxController!.value.isPlaying){

            _videoIsPLaying = false;
            
            if (mounted) setState(() {});
        } else {
            bool playing = _videoIsPLaying;
            _videoIsPLaying = true;

            if ((_videoIsPLaying != playing) && mounted) {
                setState(() {
                  
                });
            }
        }
    }

    /// 将时长进行字符串切除
    String _timeLengthSplit (Duration position, Duration duration) {
        String p = '$position';
        String d = '$duration';

        p = p.split('.')[0].padLeft(8, '0');
        d = d.split('.')[0].padLeft(8, '0');

        return '$p/$d';
    }

    /// 竖屏/横屏 切换
    /// * [status] 1 竖屏，0 横屏
    void _verticalHorizontalScreenSwitching ({int status = 1}) {
        if (status == 1) {
            SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown
            ]);
        } else {
            SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight
            ]);
        }
    }

    /// 获取当前语言
    void _getLocaleLanguage () {
        Locale localeLanguage = Localizations.localeOf(context);
        _currentLocaleLanguageCountryCode = localeLanguage.countryCode;
    }

    /// 根据语言设置横屏提示语
    String _localeLanguageHorizontalScreenMessage () {
        switch (_currentLocaleLanguageCountryCode) {
            case 'zh':
            case 'CH':
                return '横屏播放';
            default:
                return 'Landscape playback'; 
        }
    }
}

/// 自定义轨道宽度
class _CustomRoundedRectSliderTrackShape extends RoundedRectSliderTrackShape {

    @override
    Rect getPreferredRect({
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        Offset offset = Offset.zero,
        bool isEnabled = false,
        bool isDiscrete = false,
    }) {
        
        final double trackHeight = sliderTheme.trackHeight!;
        final double trackWidth = parentBox.size.width;
        final double trackLeft = offset.dx;
        final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;

        return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
    }
}


