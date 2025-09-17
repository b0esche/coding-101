# Background Audio Implementation for GigHub

## Overview
This implementation adds background audio playback support to the GigHub Flutter app using `just_audio_background`. The solution addresses the challenge of having two separate audio players on DJ profiles that need to work correctly with background sessions.

**Key Constraint**: `just_audio_background` only supports a single AudioPlayer instance with background capabilities. Our solution uses a shared AudioPlayer managed by a central service.

## Key Components

### 1. Background Audio Service (`/lib/src/Data/services/background_audio_service.dart`)
A centralized service that manages the single background-enabled AudioPlayer:

- **Shared Player**: Single AudioPlayer instance with background support
- **Session Management**: Tracks which audio source is currently loaded
- **Source Switching**: Switches audio sources when user changes tracks
- **Background Metadata**: Provides track title, artist, and artwork to system media controls

### 2. Updated Audio Player Widget (`/lib/src/Features/profile/dj/presentation/widgets/audio_player.dart`)
Enhanced AudioPlayerWidget that uses the shared player:

- **Shared Player Usage**: All widgets use the same background-enabled AudioPlayer
- **Smart Source Switching**: Automatically switches audio source when play is pressed
- **Session Coordination**: Works with AudioPlayerCoordinator to manage UI state
- **No Individual Disposal**: Widgets don't dispose the shared player

### 3. Main App Initialization (`/lib/main.dart`)
Background service is initialized during app startup:

```dart
await BackgroundAudioService.initialize();
```

### 4. Android Permissions (`/android/app/src/main/AndroidManifest.xml`)
Added required permissions for background audio:

```xml
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK" />
```

## How It Works

### Shared Player Architecture
1. **Single Instance**: Only one AudioPlayer with background support exists
2. **Source Switching**: When user switches tracks, the service changes the audio source
3. **UI Coordination**: Multiple UI widgets can control the same shared player
4. **Session Tracking**: Service tracks which session (track) is currently active

### Player Coordination Flow
1. User presses play on Track 1 widget
2. Widget checks if its session is active in the background service
3. If not active, service switches to Track 1's audio source with metadata
4. AudioPlayerCoordinator ensures other UI widgets are paused
5. Track plays with background support

### Background Session Management
- **Single Session**: Only one background session exists at any time
- **Metadata Updates**: Each track switch updates system media controls
- **Seamless Switching**: Users can switch between tracks without losing background capability

### Profile Screen Integration
Updated DJ profile screens to pass required parameters:

```dart
AudioPlayerWidget(
  audioUrl: dj.streamingUrls.first,
  trackTitle: dj.trackTitles.first,
  artistName: dj.name,
  sessionId: '${dj.id}_track_1',
  artworkUrl: dj.headImageUrl,
)
```

## Benefits

1. **Background Playback**: Audio continues when app goes to background or screen is locked
2. **System Integration**: Shows track info in system media controls and lock screen
3. **Proper Session Management**: Handles two separate players correctly without conflicts
4. **User Experience**: Seamless switching between tracks with proper background support
5. **Platform Support**: Works on both iOS and Android with appropriate permissions
6. **Error Prevention**: Eliminates "single player instance" errors from just_audio_background

## Technical Implementation Details

### Key Architectural Changes
- **Shared AudioPlayer**: Single background-enabled player instead of multiple instances
- **Service-Managed Sources**: Audio sources are managed by the background service
- **Widget Coordination**: UI widgets coordinate through the shared player
- **Smart Switching**: Automatic audio source switching when changing tracks

### Error Resolution
- **Fixed**: "just_audio_background supports only a single player instance" error
- **Approach**: Use one shared player with dynamic source switching
- **Result**: Multiple UI controls for single background-capable player

## Testing

To test the implementation:

1. Navigate to a DJ profile with audio tracks
2. Start playing Track 1
3. Put the app in background or lock the screen
4. Verify audio continues playing with correct metadata in system controls
5. Bring app to foreground and switch to Track 2
6. Verify seamless switching with updated metadata
7. Test background/foreground transitions multiple times
8. Confirm no crashes or "single player instance" errors

## Technical Notes

- **just_audio_background v0.0.1-beta.8**: Used for background audio support
- **Shared Player Limitation**: Only one AudioPlayer can have background support
- **Dynamic Source Switching**: Audio sources are switched rather than creating new players
- **MediaItem Updates**: Track metadata updates on each source switch
- **Coordinator Integration**: Works with existing AudioPlayerCoordinator for UI management
- **Memory Efficient**: Single player instance reduces memory usage

The implementation ensures that the two audio players on DJ profiles work correctly with background audio while respecting the single-player limitation of just_audio_background.
