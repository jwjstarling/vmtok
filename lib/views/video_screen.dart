import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import '../provider/provider.dart'; // Import your provider file

class VideoPlayerScreen extends ConsumerStatefulWidget {
  // Change to ConsumerStatefulWidget
  final List<dynamic> content;
  final ValueNotifier<bool> isVideoTabActive;

  VideoPlayerScreen({required this.content, required this.isVideoTabActive});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  late PageController _pageController;
  late List<VideoPlayerController> _videoControllers;
  ValueNotifier<Duration> _videoPosition = ValueNotifier<Duration>(Duration.zero);

  int _currentIndex = 0;
  bool _showPlayPauseIcon = false;
  double _playPauseOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Extract video URLs and initialize video controllers
    _videoControllers = _extractVideos().map((video) {
      VideoPlayerController controller =
          VideoPlayerController.network(video['url']!);
      controller.initialize().then((_) => setState(() {}));
      controller.setLooping(true);

      
      return controller;
    }).toList();

    // Add the listener to each controller here
  for (var controller in _videoControllers) {
    controller.addListener(() {
      if (_currentIndex == _videoControllers.indexOf(controller)) {
        _videoPosition.value = controller.value.position;
      }
    });
  }

    // Play the first video
    _videoControllers[_currentIndex].play();

    // Listen to the notifier value and pause or play the video accordingly
    widget.isVideoTabActive.addListener(() {
      if (widget.isVideoTabActive.value) {
        _videoControllers[_currentIndex].play();
      } else {
        _videoControllers[_currentIndex].pause();
      }
    });
  }

  List<Map<String, String>> _extractVideos() {
    List<Map<String, String>> videos = [];
    // Find the video collection
    var videoCollection = widget.content.firstWhere(
        (item) => item['sys']['contentType']['sys']['id'] == 'videoCollection');
    var videoList = videoCollection['fields']['videoCollectionList']['en-US'];

    // Loop through the videos to get the video information and video URL
    for (var videoLink in videoList) {
      var videoId = videoLink['sys']['id'];
      var video = widget.content.firstWhere(
        (item) => item['sys']['id'] == videoId,
        orElse: () => null,
      );

      if (video != null) {
        var assetId = video['fields']['videoFile']['en-US']['sys']['id'];
        var asset =
            widget.content.firstWhere((item) => item['sys']['id'] == assetId);
        var videoUrl = 'https:${asset['fields']['file']['en-US']['url']}';

        videos.add({'url': videoUrl, 'id': videoId});
      }
    }

    return videos;
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
      _playPauseOpacity = 0.7; // 70% opacity
    });

    Future.delayed(Duration(seconds: 1), () {
      // Start fading out after 1 second
      setState(() {
        _playPauseOpacity = 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageCode =
        ref.watch(languageProvider); // Get the selected language
    print("Language Code: $languageCode"); // Print the language code

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
          // Get the description based on the selected language
          var videoId = _extractVideos()[index]['id'];
          var video =
              widget.content.firstWhere((item) => item['sys']['id'] == videoId);
          final languageCode = ref.watch(languageProvider);
          String description =
              video['fields']['videoDescription'][languageCode];

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
                    description, // Use the localized description
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        print("Tapped on progress bar");
                      },
                      child: CustomVideoProgressBar(
                          controller: _videoControllers[index],
                          videoPosition: _videoPosition,),
                    )),
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
  }
}

class CustomVideoProgressBar extends StatefulWidget {
  final VideoPlayerController controller;
  final ValueNotifier<Duration> videoPosition;

  CustomVideoProgressBar({
    required this.controller,
    required this.videoPosition,
  });

  @override
  _CustomVideoProgressBarState createState() => _CustomVideoProgressBarState();
}

class _CustomVideoProgressBarState extends State<CustomVideoProgressBar> {
  bool _isScrubbing = false;
  Duration _scrubbingPosition = Duration.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (details) {
        print(_isScrubbing);
        print(_scrubbingPosition);
        print("Start Scrubbing");
        setState(() {
          _isScrubbing = true;
          _scrubbingPosition = widget.controller.value.position;
        });
      },
      onHorizontalDragUpdate: (details) {
        final delta = details.primaryDelta ?? 0;
        final totalDuration = widget.controller.value.duration.inMilliseconds;
        final newPosition = _scrubbingPosition.inMilliseconds +
            (totalDuration * delta / context.size!.width).round();
        print(newPosition);
        setState(() {
          _scrubbingPosition =
              Duration(milliseconds: newPosition.clamp(0, totalDuration));
        });
      },
      onHorizontalDragEnd: (details) {
        print(_isScrubbing);
        widget.controller.seekTo(_scrubbingPosition);
        setState(() {
          _isScrubbing = false;
        });
      },
      child: Stack(
        children: [
          Container(
            height: 10, // Set a fixed height
            color: Colors.red, // Set a visible color
          ),
          VideoProgressIndicator(
            widget.controller,
            allowScrubbing: true,
            padding: EdgeInsets.all(0),
            colors: VideoProgressColors(
              playedColor: Colors.blue,
              bufferedColor: Colors.grey,
              backgroundColor: Colors.black,
            ),
          ),
          ValueListenableBuilder<Duration>(
            valueListenable: widget.videoPosition,
            builder: (context, position, child) {
              return Slider(
                value: position.inMilliseconds.toDouble(),
                onChanged: (value) {
                  print(_isScrubbing);
                  print(_scrubbingPosition);
                  setState(() {
                    _isScrubbing = true;
                    _scrubbingPosition = Duration(milliseconds: value.toInt());
                    widget.controller.seekTo(_scrubbingPosition);
                  });
                },
                onChangeEnd: (value) {
                  print(_isScrubbing);
                  print(_scrubbingPosition);
                  setState(() {
                    _isScrubbing = false;
                  });
                },
                min: 0,
                max: widget.controller.value.duration.inMilliseconds.toDouble(),
                activeColor: Colors.transparent,
                inactiveColor: Colors.transparent,
              );
            },
          ),
          Positioned(
            bottom: 30, // Increase the bottom position
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(8),
                color: Colors.black.withOpacity(0.7), // Add a background color
                child: Text(
                  "Time goes here",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomVideoProgressBarState1 extends State<CustomVideoProgressBar> {
  bool _isScrubbing = false;
  Duration _scrubbingPosition = Duration.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (details) {
        print(_isScrubbing);
        print(_scrubbingPosition);
        setState(() {
          _isScrubbing = true;
          _scrubbingPosition = widget.controller.value.position;
        });
      },
      onHorizontalDragUpdate: (details) {
        final delta = details.primaryDelta ?? 0;
        final totalDuration = widget.controller.value.duration.inMilliseconds;
        final newPosition = _scrubbingPosition.inMilliseconds +
            (totalDuration * delta / context.size!.width).round();
        setState(() {
          _scrubbingPosition =
              Duration(milliseconds: newPosition.clamp(0, totalDuration));
        });
      },
      onHorizontalDragEnd: (details) {
        widget.controller.seekTo(_scrubbingPosition);
        setState(() {
          _isScrubbing = false;
        });
      },
      child: Stack(
        children: [
          VideoProgressIndicator(
            widget.controller,
            allowScrubbing: true,
            padding: EdgeInsets.all(0),
            colors: VideoProgressColors(
              playedColor: Colors.blue,
              bufferedColor: Colors.grey,
              backgroundColor: Colors.black,
            ),
          ),
          if (_isScrubbing)
            Positioned(
              bottom: 30, // Increase the bottom position
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(8),
                  color:
                      Colors.black.withOpacity(0.7), // Add a background color
                  child: Text(
                    "${_formatDuration(_scrubbingPosition)} / ${_formatDuration(widget.controller.value.duration)}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }
}
