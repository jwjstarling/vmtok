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
  double _thumbPosition = 0.0; // Add this to track the thumb position
  final GlobalKey _timeKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
          return Column(
          children: [
          if (_isScrubbing)
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: _calculateLeftPosition(constraints.maxWidth)), // Adjust this value to position the widget
              child: Container(
                key: _timeKey,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7), // Add a background color
                  borderRadius: BorderRadius.circular(8),  // Rounded edges
                ),
                child: Text(
                  _formatDuration(_scrubbingPosition, widget.controller.value.duration),
                  style: TextStyle(color: Colors.white, fontSize: 12), // Adjust the font size here
                ),
              ),
            ),
            ValueListenableBuilder<Duration>(
              valueListenable: widget.videoPosition,
              builder: (context, position, child) {
                return SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 5, // Adjust as needed
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6), // Adjust as needed
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 10), // Adjust as needed
                    thumbColor: Colors.blue,
                    activeTrackColor: Colors.blue,
                    inactiveTrackColor: Colors.grey,
                    overlayColor: Colors.blue.withOpacity(0.2),
                  ),
                  child: Slider(
                    value: position.inMilliseconds.toDouble(),
                    onChanged: (value) {
                      print(_isScrubbing);
                      setState(() {
                        _isScrubbing = true;
                        _scrubbingPosition = Duration(milliseconds: value.toInt());
                        widget.controller.seekTo(_scrubbingPosition);
                        _thumbPosition = (value / widget.controller.value.duration.inMilliseconds) * constraints.maxWidth;
                      });
                    },
                    onChangeEnd: (value) {
                      setState(() {
                        _isScrubbing = false;
                      });
                    },
                    min: 0,
                    max: widget.controller.value.duration.inMilliseconds.toDouble(),
                    activeColor: Colors.blue, // Set to transparent since we're using SliderTheme
                    inactiveColor: Colors.grey, // Set to transparent since we're using SliderTheme
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

double _calculateLeftPosition(double maxWidth) {
  if (_timeKey.currentContext == null) {
    return 0.0; // Default value if the context is not available
  }

  final RenderBox renderBox = _timeKey.currentContext!.findRenderObject() as RenderBox;
  final timeWidth = renderBox.size.width;

  // Calculate the position of the slider thumb
  double thumbPosition = (widget.controller.value.position.inMilliseconds / widget.controller.value.duration.inMilliseconds) * maxWidth;

  double left = thumbPosition - timeWidth / 2;
  if (left < 0) {
    left = 0;
  } else if (left + timeWidth > maxWidth) {
    left = maxWidth - timeWidth;
  }

  return left;
}

String _formatDuration(Duration elapsed, Duration total) {
  final elapsedMinutes = elapsed.inMinutes;
  final elapsedSeconds = elapsed.inSeconds % 60;
  final totalMinutes = total.inMinutes;
  final totalSeconds = total.inSeconds % 60;

  return "$elapsedMinutes:${elapsedSeconds.toString().padLeft(2, '0')} / $totalMinutes:${totalSeconds.toString().padLeft(2, '0')}";
}
}
