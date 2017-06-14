// This file is free software. You may use it under the MIT license, which is copied
// below and available at http://opensource.org/licenses/MIT
//
// Copyright (c) 2014 Catchoom Technologies S.L.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
// Software, and to permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
// PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
// FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.

#import "CraftARTrackingContent.h"

///@file

/**
 Status of the video
 */
typedef NS_ENUM(NSUInteger, CraftARVideoPlaybackStatus) {
    /// Video is not ready
    PLAYBACK_STATUS_NOT_READY,
    /// Video is ready to play
    PLAYBACK_STATUS_READY,
    /// Video is playing
    PLAYBACK_STATUS_PLAYING,
    /// Video is pasused
    PLAYBACK_STATUS_PAUSED,
    /// Video has finished playing
    PLAYBACK_STATUS_FINISHED,
};

/**
 A video content is able to play a video on top of a reference image.
 */
@interface CraftARTrackingContentVideo : CraftARTrackingContent {
    CraftARVideoPlaybackStatus playbackStatus;
}

/// Status of the video
@property (nonatomic, readonly) CraftARVideoPlaybackStatus playbackStatus;

// Video settings
@property (nonatomic, readwrite) Boolean autoplay;
@property (nonatomic, readwrite) Boolean loop;
@property (nonatomic, readwrite) Boolean muted;
@property (nonatomic, readwrite) Boolean hasTransparencyMask;
@property (nonatomic, readonly) NSURL *poster;

/**
 Initialize content with a video from a URL
 @param videoUrl Must be a url to a local or remote H.264 video.
 */
- (id) initWithVideoFrom: (NSURL*) videoUrl;


/**
 Initialize content with a video from a URL and a poster URL
 @param videoUrl Must be a url to a local or remote H.264 video.
 @param posterURL Must be a url to a local or remote image (png or jpg) to be drawn as
 video placeholder when the video is not loaded yet.
 */
- (id) initWithVideoFrom: (NSURL*) videoUrl andPosterURL: (NSURL*) poster;

/**
 Behaviour when this content's reference is detected.
 Default behaviour is to start playing if ready. Can be overriden.
 */
- (void) trackingStarted;

/**
 Behaviour when this content's reference detection is lost.
 Default behaviour is to pause playback if playing. Can be overriden.
 */
- (void) trackingLost;


/**
 Behaviour when media is ready to play.
 Default behaviour is to start playing if the reference is tracked. Can be overriden.
 */
- (void) didBecomeReadyToPlay;

/**
 Behaviour when playback is finished.
 Default behaviour does nothing. Can be overriden.
 */
- (void) didFinishPlaying;


/**
 Start playing, returns NO if not ready.
 */
- (Boolean) start;

/**
 Stop playing if status is PLAYING
 */
- (void) stop;

/**
 Pause playback. Returns NO if not playing.
 */
- (Boolean) pause;

/**
  Set the audio volume
 @param volume Should be between 0.0 and 1.0
 */
- (void) setVolume: (float)volume;

@end
