import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:dtpocketfm/pages/bottombar.dart';
import 'package:dtpocketfm/provider/playprovider.dart';
import 'package:dtpocketfm/utils/color.dart';
import 'package:dtpocketfm/utils/musicmanager.dart';
import 'package:dtpocketfm/utils/utils.dart';
import 'package:dtpocketfm/widget/musicutils.dart';
import 'package:dtpocketfm/widget/myimage.dart';
import 'package:dtpocketfm/widget/mynetworkimg.dart';
import 'package:dtpocketfm/widget/mytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';

AudioPlayer audioPlayer = AudioPlayer();

Stream<PositionData> get positionDataStream {
  return Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          audioPlayer.positionStream,
          audioPlayer.bufferedPositionStream,
          audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero))
      .asBroadcastStream();
}

final ValueNotifier<double> playerExpandProgress =
    ValueNotifier(playerMinHeight);

final MiniplayerController controller = MiniplayerController();

class MusicDetails extends StatefulWidget {
  final bool ishomepage;
  final String audioid, episodeid, userid, stoptime;
  const MusicDetails({
    Key? key,
    required this.ishomepage,
    required this.userid,
    required this.audioid,
    required this.episodeid,
    required this.stoptime,
  }) : super(key: key);

  @override
  State<MusicDetails> createState() => _MusicDetailsState();
}

class _MusicDetailsState extends State<MusicDetails> {
  final MusicManager _musicManager = MusicManager();
  int stoptime = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: black));
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PositionData>(
        stream: positionDataStream,
        builder: (context, snapshot) {
          final positionData = snapshot.data;
          stoptime = positionData?.position.inMilliseconds ?? 0;
          return Miniplayer(
            valueNotifier: playerExpandProgress,
            minHeight: playerMinHeight,
            duration: const Duration(seconds: 1),
            maxHeight: MediaQuery.of(context).size.height,
            controller: controller,
            elevation: 4,
            backgroundColor: colorPrimaryDark,
            onDismissed: () async {
              debugPrint("onDismissed");
              currentlyPlaying.value = null;
              final playprovider =
                  Provider.of<PlayProvider>(context, listen: false);
              debugPrint("userid=>${widget.userid}");
              debugPrint("audioid=>${widget.audioid}");
              debugPrint("episodeid=>${widget.episodeid}");
              await playprovider.getaddcontinueWatching(
                  widget.userid.toString(),
                  widget.audioid.toString(),
                  widget.episodeid.toString(),
                  stoptime.toString());

              currentlyPlaying.value = null;
              await audioPlayer.pause();
              await audioPlayer.stop();
              if (mounted) {
                debugPrint("setState");
                setState(() {});
              }
              _musicManager.clearMusicPlayer();
            },
            curve: Curves.easeInOutCubicEmphasized,
            builder: (height, percentage) {
              final bool miniplayer =
                  percentage < miniplayerPercentageDeclaration;
              if (!miniplayer) {
                return Scaffold(
                  backgroundColor: colorPrimaryDark,
                  body: SafeArea(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorPrimary,
                            colorAccent.withOpacity(0.40),
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildAppBar(),
                          Expanded(child: _buildMusicPage()),
                        ],
                      ),
                    ),
                  ),
                );
              }

              //Miniplayer
              final percentageMiniplayer = percentageFromValueInRange(
                  min: playerMinHeight,
                  max: MediaQuery.of(context).size.height,
                  value: height);

              final elementOpacity = 1 - 1 * percentageMiniplayer;
              final progressIndicatorHeight = 2 - 2 * percentageMiniplayer;

              return Scaffold(
                body: _buildMusicPanel(
                    height, elementOpacity, progressIndicatorHeight),
              );
            },
          );
        });
  }

  Widget _buildAppBar() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FittedBox(
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(7),
                child: MyImage(
                    height: 15,
                    width: 15,
                    imagePath: "ic_back.png",
                    fit: BoxFit.contain,
                    color: white),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: MyText(
              color: white,
              text: "PLAYING START",
              maxline: 1,
              fontsize: 16,
              overflow: TextOverflow.ellipsis,
              textalign: TextAlign.center,
              fontstyle: FontStyle.normal,
            ),
          ),
          const SizedBox(width: 45),
        ],
      ),
    );
  }

  Widget _buildMusicPage() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(27, 0, 27, 0),
                  child: StreamBuilder<PositionData>(
                    stream: positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      return ProgressBar(
                        progress: positionData?.position ?? Duration.zero,
                        buffered:
                            positionData?.bufferedPosition ?? Duration.zero,
                        total: positionData?.duration ?? Duration.zero,
                        progressBarColor: white,
                        baseBarColor: colorAccent,
                        bufferedBarColor: gray,
                        thumbColor: white,
                        barHeight: 4.0,
                        thumbRadius: 5.0,
                        timeLabelPadding: 5.0,
                        timeLabelType: TimeLabelType.totalTime,
                        timeLabelTextStyle: GoogleFonts.inter(
                          fontSize: 12,
                          fontStyle: FontStyle.normal,
                          color: white,
                          fontWeight: FontWeight.w700,
                        ),
                        onSeek: (duration) {
                          audioPlayer.seek(duration);
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Privious Audio Setup
                    StreamBuilder<SequenceState?>(
                      stream: audioPlayer.sequenceStateStream,
                      builder: (context, snapshot) => IconButton(
                        iconSize: 30,
                        icon: const Icon(
                          Icons.skip_previous_rounded,
                          color: white,
                        ),
                        onPressed: audioPlayer.hasPrevious
                            ? audioPlayer.seekToPrevious
                            : null,
                      ),
                    ),
                    const SizedBox(width: 15),
                    // 10 Second Privious
                    StreamBuilder<PositionData>(
                      stream: positionDataStream,
                      builder: (context, snapshot) {
                        final positionData = snapshot.data;
                        return InkWell(
                            onTap: () {
                              tenSecNextOrPrevious(
                                  positionData?.position.inSeconds.toString() ??
                                      "",
                                  false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: MyImage(
                                  width: 30,
                                  height: 30,
                                  imagePath: "ic_tenprevious.png"),
                            ));
                      },
                    ),
                    const SizedBox(width: 15),
                    // Pause and Play Controll
                    StreamBuilder<PlayerState>(
                      stream: audioPlayer.playerStateStream,
                      builder: (context, snapshot) {
                        final playerState = snapshot.data;
                        final processingState = playerState?.processingState;
                        final playing = playerState?.playing;
                        if (processingState == ProcessingState.loading ||
                            processingState == ProcessingState.buffering) {
                          return Container(
                            margin: const EdgeInsets.all(8.0),
                            width: 50.0,
                            height: 50.0,
                            child: const CircularProgressIndicator(
                              color: colorAccent,
                            ),
                          );
                        } else if (playing != true) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  yellow,
                                  colorAccent,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.play_arrow_rounded,
                                color: white,
                              ),
                              color: white,
                              iconSize: 50.0,
                              onPressed: audioPlayer.play,
                            ),
                          );
                        } else if (processingState !=
                            ProcessingState.completed) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  yellow,
                                  colorAccent,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.pause_rounded,
                                color: white,
                              ),
                              iconSize: 50.0,
                              color: white,
                              onPressed: audioPlayer.pause,
                            ),
                          );
                        } else {
                          return IconButton(
                            icon: const Icon(
                              Icons.replay_rounded,
                              color: white,
                            ),
                            iconSize: 60.0,
                            onPressed: () => audioPlayer.seek(Duration.zero,
                                index: audioPlayer.effectiveIndices!.first),
                          );
                        }
                      },
                    ),
                    const SizedBox(width: 15),
                    // 10 Second Next
                    StreamBuilder<PositionData>(
                      stream: positionDataStream,
                      builder: (context, snapshot) {
                        final positionData = snapshot.data;

                        return InkWell(
                            onTap: () {
                              tenSecNextOrPrevious(
                                  positionData?.position.inSeconds.toString() ??
                                      "",
                                  true);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: MyImage(
                                  width: 30,
                                  height: 30,
                                  imagePath: "ic_tennext.png"),
                            ));
                      },
                    ),
                    const SizedBox(width: 15),
                    // Next Audio Play
                    StreamBuilder<SequenceState?>(
                      stream: audioPlayer.sequenceStateStream,
                      builder: (context, snapshot) => IconButton(
                        iconSize: 30.0,
                        icon: const Icon(
                          Icons.skip_next_rounded,
                          color: white,
                        ),
                        onPressed:
                            audioPlayer.hasNext ? audioPlayer.seekToNext : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorPrimary,
                        colorAccent,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Volumn Costome Set
                      IconButton(
                        iconSize: 30.0,
                        icon: const Icon(Icons.volume_up),
                        color: white,
                        onPressed: () {
                          showSliderDialog(
                            context: context,
                            title: "Adjust volume",
                            divisions: 10,
                            min: 0.0,
                            max: 2.0,
                            value: audioPlayer.volume,
                            stream: audioPlayer.volumeStream,
                            onChanged: audioPlayer.setVolume,
                          );
                        },
                      ),
                      // Audio Speed Costomized
                      StreamBuilder<double>(
                        stream: audioPlayer.speedStream,
                        builder: (context, snapshot) => IconButton(
                          icon: Text(
                            overflow: TextOverflow.ellipsis,
                            "${snapshot.data?.toStringAsFixed(1)}x",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: white,
                                fontSize: 14),
                          ),
                          onPressed: () {
                            showSliderDialog(
                              context: context,
                              title: "Adjust speed",
                              divisions: 10,
                              min: 0.5,
                              max: 2.0,
                              value: audioPlayer.speed,
                              stream: audioPlayer.speedStream,
                              onChanged: audioPlayer.setSpeed,
                            );
                          },
                        ),
                      ),
                      // Loop Node Button
                      StreamBuilder<LoopMode>(
                        stream: audioPlayer.loopModeStream,
                        builder: (context, snapshot) {
                          final loopMode = snapshot.data ?? LoopMode.off;
                          const icons = [
                            Icon(Icons.repeat, color: white, size: 30.0),
                            Icon(Icons.repeat, color: yellow, size: 30.0),
                            Icon(Icons.repeat_one, color: yellow, size: 30.0),
                          ];
                          const cycleModes = [
                            LoopMode.off,
                            LoopMode.all,
                            LoopMode.one,
                          ];
                          final index = cycleModes.indexOf(loopMode);
                          return IconButton(
                            icon: icons[index],
                            onPressed: () {
                              audioPlayer.setLoopMode(cycleModes[
                                  (cycleModes.indexOf(loopMode) + 1) %
                                      cycleModes.length]);
                            },
                          );
                        },
                      ),
                      // Suffle Button
                      StreamBuilder<bool>(
                        stream: audioPlayer.shuffleModeEnabledStream,
                        builder: (context, snapshot) {
                          final shuffleModeEnabled = snapshot.data ?? false;
                          return IconButton(
                            iconSize: 30.0,
                            icon: shuffleModeEnabled
                                ? const Icon(Icons.shuffle, color: yellow)
                                : const Icon(Icons.shuffle, color: white),
                            onPressed: () async {
                              final enable = !shuffleModeEnabled;
                              if (enable) {
                                await audioPlayer.shuffle();
                              }
                              await audioPlayer.setShuffleModeEnabled(enable);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                StreamBuilder<SequenceState?>(
                    stream: audioPlayer.sequenceStateStream,
                    builder: (context, snapshot) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: MyNetworkImage(
                          imgWidth: MediaQuery.of(context).size.width * 0.80,
                          imgHeight: MediaQuery.of(context).size.height * 0.35,
                          imageUrl: ((audioPlayer.sequenceState?.currentSource
                                      ?.tag as MediaItem?)
                                  ?.artUri)
                              .toString(),
                          fit: BoxFit.cover,
                        ),
                      );
                    }),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                StreamBuilder<SequenceState?>(
                    stream: audioPlayer.sequenceStateStream,
                    builder: (context, snapshot) {
                      return Container(
                        margin: const EdgeInsets.fromLTRB(20, 3, 20, 0),
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ScrollLoopAutoScroll(
                              scrollDirection: Axis.horizontal,
                              child: MyText(
                                  color: white,
                                  text: ((audioPlayer
                                              .sequenceState
                                              ?.currentSource
                                              ?.tag as MediaItem?)
                                          ?.title)
                                      .toString(),
                                  textalign: TextAlign.left,
                                  fontsize: 22,
                                  inter: true,
                                  maxline: 1,
                                  fontwaight: FontWeight.w600,
                                  overflow: TextOverflow.ellipsis,
                                  fontstyle: FontStyle.normal),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMusicPanel(
      dynamicPanelHeight, elementOpacity, progressIndicatorHeight) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorAccent,
            yellow,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Opacity(
              opacity: elementOpacity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /* Music Image */
                  StreamBuilder<SequenceState?>(
                    stream: audioPlayer.sequenceStateStream,
                    builder: (context, snapshot) {
                      return Container(
                        width: 80,
                        height: dynamicPanelHeight,
                        padding: const EdgeInsets.fromLTRB(10, 3, 5, 3),
                        margin: const EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: MyNetworkImage(
                            imgWidth: MediaQuery.of(context).size.width,
                            imgHeight: MediaQuery.of(context).size.height,
                            imageUrl: ((audioPlayer.sequenceState?.currentSource
                                        ?.tag as MediaItem?)
                                    ?.artUri)
                                .toString(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: StreamBuilder<SequenceState?>(
                        stream: audioPlayer.sequenceStateStream,
                        builder: (context, snapshot) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ScrollLoopAutoScroll(
                                scrollDirection: Axis.horizontal,
                                child: MyText(
                                    color: white,
                                    text: ((audioPlayer
                                                .sequenceState
                                                ?.currentSource
                                                ?.tag as MediaItem?)
                                            ?.title)
                                        .toString(),
                                    textalign: TextAlign.left,
                                    fontsize: 16,
                                    inter: true,
                                    maxline: 1,
                                    fontwaight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                    fontstyle: FontStyle.normal),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              MyText(
                                  color: white,
                                  text: ((audioPlayer
                                              .sequenceState
                                              ?.currentSource
                                              ?.tag as MediaItem?)
                                          ?.displaySubtitle)
                                      .toString(),
                                  textalign: TextAlign.left,
                                  fontsize: 12,
                                  inter: true,
                                  maxline: 1,
                                  fontwaight: FontWeight.w400,
                                  overflow: TextOverflow.ellipsis,
                                  fontstyle: FontStyle.normal),
                            ],
                          );
                        }),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        StreamBuilder<SequenceState?>(
                          stream: audioPlayer.sequenceStateStream,
                          builder: (context, snapshot) {
                            if (dynamicPanelHeight <= playerMinHeight) {
                              if (audioPlayer.hasPrevious) {
                                return IconButton(
                                  iconSize: 25.0,
                                  icon: const Icon(
                                    Icons.skip_previous_rounded,
                                    color: white,
                                  ),
                                  onPressed: audioPlayer.hasPrevious
                                      ? audioPlayer.seekToPrevious
                                      : null,
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                        /* Play/Pause */
                        StreamBuilder<PlayerState>(
                          stream: audioPlayer.playerStateStream,
                          builder: (context, snapshot) {
                            if (dynamicPanelHeight <= playerMinHeight) {
                              final playerState = snapshot.data;
                              final processingState =
                                  playerState?.processingState;
                              final playing = playerState?.playing;
                              if (processingState == ProcessingState.loading ||
                                  processingState ==
                                      ProcessingState.buffering) {
                                return Container(
                                  margin: const EdgeInsets.all(8.0),
                                  width: 35.0,
                                  height: 35.0,
                                  child: Utils.pageLoader(),
                                );
                              } else if (playing != true) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: colorAccent,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.play_arrow_rounded,
                                      color: white,
                                    ),
                                    color: white,
                                    iconSize: 25.0,
                                    onPressed: audioPlayer.play,
                                  ),
                                );
                              } else if (processingState !=
                                  ProcessingState.completed) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: colorAccent,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.pause_rounded,
                                      color: white,
                                    ),
                                    iconSize: 25.0,
                                    color: white,
                                    onPressed: audioPlayer.pause,
                                  ),
                                );
                              } else {
                                return IconButton(
                                  icon: const Icon(
                                    Icons.replay_rounded,
                                    color: white,
                                  ),
                                  iconSize: 35.0,
                                  onPressed: () => audioPlayer.seek(
                                      Duration.zero,
                                      index:
                                          audioPlayer.effectiveIndices!.first),
                                );
                              }
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                        /* Next */
                        StreamBuilder<SequenceState?>(
                          stream: audioPlayer.sequenceStateStream,
                          builder: (context, snapshot) {
                            if (dynamicPanelHeight <= playerMinHeight) {
                              if (audioPlayer.hasNext) {
                                return IconButton(
                                  iconSize: 25.0,
                                  icon: const Icon(
                                    Icons.skip_next_rounded,
                                    color: white,
                                  ),
                                  onPressed: audioPlayer.hasNext
                                      ? audioPlayer.seekToNext
                                      : null,
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  /* Previous */
                ],
              ),
            ),
          ),
          Opacity(
            opacity: elementOpacity,
            child: StreamBuilder<PositionData>(
              stream: positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return ProgressBar(
                  progress: positionData?.position ?? Duration.zero,
                  buffered: positionData?.bufferedPosition ?? Duration.zero,
                  total: positionData?.duration ?? Duration.zero,
                  progressBarColor: white,
                  baseBarColor: colorAccent,
                  bufferedBarColor: white.withOpacity(0.24),
                  barCapShape: BarCapShape.square,
                  barHeight: progressIndicatorHeight,
                  thumbRadius: 0.0,
                  timeLabelLocation: TimeLabelLocation.none,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 10 Second Next And Previous Functionality
  // bool isnext = true > next Audio Seek
  // bool isnext = false > previous Audio Seek
  tenSecNextOrPrevious(String audioposition, bool isnext) {
    dynamic firstHalf = Duration(seconds: int.parse(audioposition));
    const secondHalf = Duration(seconds: 10);
    Duration movePosition;
    if (isnext == true) {
      movePosition = firstHalf + secondHalf;
    } else {
      movePosition = firstHalf - secondHalf;
    }

    _musicManager.seek(movePosition);
  }
}
