

import 'package:flutter/material.dart';
import 'package:chat_flutter/utils/screenutil/screenutil.dart';

/// 内容为 音频 的组件盒子
class AudioBox extends StatefulWidget {
    AudioBox({
        super.key,
        this.audioTimelength = 0,
        this.audioPlayStatus = false,
    });

    /// 音频时长
    int audioTimelength;
    /// 播放状态
    bool audioPlayStatus;

    @override
    State<AudioBox> createState() => _AudioBoxState();
}

class _AudioBoxState extends State<AudioBox> {

    @override
    Widget build(BuildContext context) {
        /// 图标切换状态
        bool iconSwitchStatus = false;

        /// 根据音频播放状态修改图标
        Widget audioFrequencyStatusWidget ({Function? callback}) {
            Future.delayed(const Duration(seconds: 1), (){
                if (widget.audioPlayStatus && callback != null){
                    callback();
                }
            });

            if (!widget.audioPlayStatus && iconSwitchStatus){
                iconSwitchStatus = false;
            }

            Icon icon = Icon(
                iconSwitchStatus ? Icons.volume_down : Icons.volume_up,
                size: sf(20), 
                color: const Color(0xff1989fa)
            );

            return icon;
        }

        return Container(
            child: Container(
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        StatefulBuilder(
                            builder: ((context, setState) {
                                return audioFrequencyStatusWidget(
                                    callback: () {
                                        iconSwitchStatus = !iconSwitchStatus;

                                        setState (() {
                                            
                                        });
                                    }
                                );
                            })
                        ),
                        // 间隙盒子
                        SizedBox(
                            width: sw(5),
                        ),
                        // 图标
                        Icon(Icons.multitrack_audio_outlined, size: sf(25), color: const Color(0xff1989fa)),
                        Transform.translate(
                            offset: Offset(sw(-8), 0),
                            child: Icon(Icons.multitrack_audio_rounded, size: sf(25), color: const Color(0xff1989fa)),
                        ),
                        // 时长
                        if (widget.audioTimelength > 0)
                            Container(
                                child: Text(
                                    "'${widget.audioTimelength}",
                                    style: TextStyle(
                                        fontSize: sf(15),
                                        color: Colors.black
                                    ),
                                ),
                            ),
                        // 
                    ],
                ),
            )
        );
    }
}