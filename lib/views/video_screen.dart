import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/provider.dart';
import '../classes/content_classes.dart';
import 'package:contentful_sync/contentful_sync.dart';
import '../services/content_services.dart';

final localStore = LocalStore();
enum VideoLoadingStatus { uninitialized, loading, loaded, error }

class VideoPlayerScreen extends ConsumerStatefulWidget {
  final ValueNotifier<bool> isVideoTabActive;

  VideoPlayerScreen({required this.isVideoTabActive});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  late PageController _pageController;
  List<VideoPlayerController> _videoControllers = [];
  List<VideoPost> _videoPosts = [];
  ValueNotifier<Duration> _videoPosition = ValueNotifier<Duration>(Duration.zero);

  int _currentIndex = 0;
  bool _showPlayPauseIcon = false;
  double _playPauseOpacity = 0.0;

  VideoLoadingStatus _loadingStatus = VideoLoadingStatus.uninitialized;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _videoControllers = [];
    _pageController = PageController();
    _loadVideos();
  }

  void _loadVideos() async {
    setState(() {
      _loadingStatus = VideoLoadingStatus.loading;
    });

    try {
      await displayVideoDetails("Collection of Vids for VM Tok App");
      _videoControllers = await _initializeVideos();
      print("Number of Videos: ${_videoControllers.length}");

      setState(() {
        _loadingStatus = VideoLoadingStatus.loaded;
      });
    } catch (error) {
      setState(() {
        _loadingStatus = VideoLoadingStatus.error;
        _errorMessage = error.toString();
      });
    }
  }

  Future<List<VideoPlayerController>> _initializeVideos() async {
    await localStore.open();
    print("_initialize videos");
    final collection = await fetchVideoCollectionByTitle('Collection of Vids for VM Tok App');
    List<VideoPlayerController> controllers = [];
    if (collection != null) {
      final videoPosts = await fetchVideoPostsForCollection(collection);
      for (var post in videoPosts) {
        Asset? videoAsset = await fetchAssetById(post.videoFileId);
        if (videoAsset != null) {
          print("Video URL: ${videoAsset.url}");
          VideoPlayerController controller = VideoPlayerController.network(videoAsset.url!);
          await controller.initialize();
          controller.setLooping(true);
          controllers.add(controller);
        }
      }
      if (controllers.isNotEmpty) {
        controllers[0].play();
      }
    }
    return controllers;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _videoPosition.dispose();
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _togglePlayPause(int index) {
    setState(() {
      _videoControllers[index].value.isPlaying
          ? _videoControllers[index].pause()
          : _videoControllers[index].play();
      _playPauseOpacity = 0.7;
    });

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _playPauseOpacity = 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = ref.watch(languageProvider);

    switch (_loadingStatus) {
      case VideoLoadingStatus.uninitialized:
      case VideoLoadingStatus.loading:
        return CircularProgressIndicator();
      case VideoLoadingStatus.loaded:
        print("Videos Loaded");
        return Scaffold(
          body: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: _videoControllers.length,
            onPageChanged: (index) {
              // Restart the previous video and play the current one
              _videoControllers[_currentIndex].seekTo(Duration(seconds: 0));
              _videoControllers[_currentIndex].pause();
              _currentIndex = index;
              _videoControllers[_currentIndex].play();
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _togglePlayPause(index),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    VideoPlayer(_videoControllers[index]),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Text(
                        "Description", // Replace with the actual video description
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    Center(
                      child: AnimatedOpacity(
                        opacity: _playPauseOpacity,
                        duration: Duration(milliseconds: 500), // Fade out duration
                        child: Icon(
                          _videoControllers[index].value.isPlaying
                              ? Icons.play_arrow
                              : Icons.pause,
                          color: Colors.white.withOpacity(0.7),
                          size: 100,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      case VideoLoadingStatus.error:
        return Center(child: Text('An error occurred: $_errorMessage'));
      default:
        return SizedBox.shrink(); // This shouldn't be reached
    }
  }
}
