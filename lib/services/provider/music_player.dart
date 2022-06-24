
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/mixins/BaseMixins.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:flutter/foundation.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';

class MusicPlayer extends ChangeNotifier with BaseMixins {
  AssetsAudioPlayer player = AssetsAudioPlayer();

   List<Music> _popularMusicsList = [];
   List<Music> _recentMusicsList = [];

  List<Music> get getPopularMusicsList => _popularMusicsList;

  List<Music> get getRecentMusicsList => _recentMusicsList;

  bool _miniPlayerVisibility = false;
  bool _isMusicStopped = true;

  bool get isMusicStopped => _isMusicStopped;

  void setMusicStopped(bool value){
    _isMusicStopped = value;
    notifyListeners();
  }

  bool get miniPlayerVisibility => _miniPlayerVisibility;

  void setMiniPlayerVisibility(bool visibility) {
    _miniPlayerVisibility = visibility;
    notifyListeners();
  }

  void setPopularMusicList(List<Music> musics) {
    for (Music music in musics) {
      _popularMusicsList.add(music);
    }
    notifyListeners();
  }

  void setRecentMusicList(List<Music> musics) {
    for (Music music in musics) {
      _recentMusicsList.add(music);
    }
    notifyListeners();
  }

  MusicPlayer() {
    player.playlistAudioFinished.listen((Playing playing) {
      if(!_isMusicStopped){
        next(action: false);
      }

    });

    AssetsAudioPlayer.addNotificationOpenAction((notification) {
      return false;
    });
  }

void listenMusicStreaming(){
  player.playlistAudioFinished.listen((Playing playing) {
    if(!_isMusicStopped){
      next(action: false);
    }

  });
}

  void setPlayer(AssetsAudioPlayer musicPlayer,
      PodcastPlayer podcastProvider, RadioProvider radioProvider) {
    player = musicPlayer;

    setMiniPlayerVisibility(true);
    podcastProvider.setMiniPlayerVisibility(false);
    radioProvider.setMiniPlayerVisibility(false);
  }

  late Album _currentAlbum;

  Album get currentAlbum => _currentAlbum;

  late Album _playlist;

  Album get playlist => _playlist;

  Music? _currentMusic;

  Music? get currentMusic => _currentMusic;

  bool _loopMode = false;

  bool get loopMode => _loopMode;
  bool _loopPlaylist = false;

  bool get loopPlaylist => _loopPlaylist;
  bool _isMusicLoaded = true;

  bool get isMusicLoaded => _isMusicLoaded;
  int? _currentIndex;

  int? get currentIndex => _currentIndex;

  set currentAlbum(album) {
    _currentAlbum = album;
    notifyListeners();
  }

  late int _sessionId;

  int get sessionId => _sessionId;

  late int tIndex;

  setBuffering(index) {
    tIndex = index;
  }

  playOrPause() async {
    try {
      await player.playOrPause();
    } catch(_) { }
  }

  isFirstMusic() {
    return _currentIndex == 0;
  }

  isLastMusic(next) {
    return next == _currentAlbum.musics.length;
  }

  next({action = true}) {
    int next = _currentIndex! + 1;
    if (!action && _loopMode && isLastMusic(next) && _loopPlaylist) {
      setPlaying(_currentAlbum, 0);
      play(0);
    } else if (!action && _loopMode && !_loopPlaylist) {
      setPlaying(_currentAlbum, _currentIndex!);
      play(_currentIndex);
    } else {
      play(next);
    }
  }

  prev() {
    int pre = _currentIndex! - 1;
    if (pre <= _currentAlbum.musics.length) {
      play(pre);
    }
  }

  int c = 0;

  handleLoop() {
    c++;
    if (c == 1) {
      _loopMode = true;
      _loopPlaylist = true;
    } else if (c == 2) {
      _loopMode = true;
      _loopPlaylist = false;
    } else if (c > 2) {
      _loopMode = _loopPlaylist = false;
      c = 0;
    }
  }

  late Album _beforeShuffling;
  bool _shuffled = false;

  bool get shuffled => _shuffled;

  handleShuffle() {
    _shuffled = !_shuffled;
    List<Music?> musics = _currentAlbum.musics;
    _beforeShuffling = _currentAlbum;
    List<Music?> shuffledMusics = shuffle(musics);
    if (_shuffled) {
      Album album = Album(
          id: currentAlbum.id,
          title: currentAlbum.title,
          artist: currentAlbum.artist,
          description: currentAlbum.description,
          cover: currentAlbum.cover,
          musics: currentAlbum.musics);
      _currentAlbum = album;
    } else {
      _currentAlbum = _beforeShuffling;
    }
  }


  play(index) async {
    try {
      _currentMusic = _currentAlbum.musics[index];
      notifyListeners();
      await _open(_currentAlbum.musics[index]);
      _currentIndex = index;
    } catch(_) { }
  }

  isSameAlbum() {
    return _playlist.id == _currentAlbum.id;
  }

  isMusicInProgress(Music music) {
    return player.isPlaying.value &&
        player.current.value != null &&
        //  player!.current.value?.audio.assetAudioPath == music.audio;
        player.getCurrentAudioTitle == music.title;
  }

  isLocalMusicInProgress(filePath) {
    return player.isPlaying.value &&
        player.current.value != null &&
        player.current.value?.audio.assetAudioPath == filePath;
  }

  bool isPlaying() {
    return player.isPlaying.value;
  }

  void audioSessionListener() {
    player.audioSessionId.listen((sessionId) {
      _sessionId = sessionId;
    });
  }

  _open(Music music) async {

    var metas = Metas(
      title: music.title,
      artist: music.artist,
      image: MetasImage.network('$apiUrl/${music.cover}'),
      id: music.id.toString(),

      //can be MetasImage.network
    );
    try {
      await player.open(
        Audio.network(
          '$apiUrl/${music.audio}',
          metas: metas,
        ),
        showNotification: true,
        notificationSettings: NotificationSettings(

          customPrevAction: (player) {
            prev();
            setMiniPlayerVisibility(true);

          },
          customNextAction: (player) {
            next();
            setMiniPlayerVisibility(true);
          },
          customPlayPauseAction: (player) => playOrPause(),
          customStopAction: (player) {
            setMusicStopped(true);
            player.stop();
            setMiniPlayerVisibility(false);

          },
        ),
      );
    } catch(_) { }
  }

  handlePlayButton({album, required Music music, index}) async {
    _shuffled = false;

    setBuffering(index);

    try {
      if (isMusicInProgress(music)) {
        player.pause();
      } else {
        _isMusicLoaded = false;
        notifyListeners();
        _currentIndex = index;
        await _open(music);
        _isMusicLoaded = true;
        notifyListeners();
        setPlaying(album, index);
      }
    }catch(_) { }
  }

  setPlaying(Album album, int index) {
    _currentAlbum = album;
    _currentIndex = index;
    _currentMusic = _currentAlbum.musics[index];
  }

  String getMusicThumbnail() {
    return currentMusic!.cover;
  }

  String getMusicCover() {
    return '$apiUrl/${currentMusic!.cover}';
  }
}
