import 'dart:developer';
import 'package:dtpocketfm/pages/bottombar.dart';
import 'package:dtpocketfm/pages/musicdetails.dart';
import 'package:dtpocketfm/widget/musicutils.dart';
import 'package:just_audio/just_audio.dart';
import '../model/getepisodebyaudioidmodel.dart';

class MusicManager {
  late ConcatenatingAudioSource playlist;
  List<Result>? episodeDataList;
  MusicManager();

  void setInitialPlaylist(int cPosition, dynamic dataList, dynamic callApi,
      String audioId, dynamic isContinueWatching, int stoptime) async {
    currentlyPlaying.value = audioPlayer;
    playlist = ConcatenatingAudioSource(children: []);
    episodeDataList = dataList as List<Result>;
    for (int i = 0; i < (episodeDataList?.length ?? 0); i++) {
      playlist.add(
        buildAudioSource(
          image: episodeDataList?[i].image.toString() ?? "",
          audioUrl: episodeDataList?[i].audio.toString() ?? "",
          episodeId: episodeDataList?[i].id.toString() ?? "",
          displaydiscription: episodeDataList?[i].description.toString() ?? "",
          title: episodeDataList?[i].name.toString() ?? "",
          audioId: audioId,
        ),
      );
    }

    try {
      log("playing      :=====================> ${audioPlayer.playing}");
      log("audioSource  :=====================> ${audioPlayer.audioSource?.sequence.length}");
      log("playlist     :=====================> ${playlist.length}");
      // Preloading audio is not currently supported on Linux.
      await audioPlayer.setAudioSource(playlist, initialIndex: cPosition);
      if (isContinueWatching == true) {
        seek(Duration(milliseconds: stoptime));
        play();
      } else {
        play();
      }

      callApi();
      // ignore: use_build_context_synchronously
    } catch (e) {
      // Catch load errors: 404, invalid url...
      log("Error loading audio source: $e");
    }
  }

  void play() async {
    audioPlayer.play();
  }

  void pause() {
    audioPlayer.pause();
  }

  void seek(Duration position) {
    audioPlayer.seek(position);
  }

  void dispose() {
    audioPlayer.dispose();
  }

  clearMusicPlayer() async {
    episodeDataList = [];
    playlist = ConcatenatingAudioSource(children: []);
    for (var i = 0; i < playlist.length; i++) {
      playlist.removeAt(i);
    }
    playlist.clear();
  }
}
