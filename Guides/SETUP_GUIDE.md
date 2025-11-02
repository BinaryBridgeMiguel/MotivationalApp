# Motivational Coach App - Setup Guide

This guide will help you set up and run the iOS motivational coaching app.

## Prerequisites

- Mac with macOS 14.0 or later
- Xcode 15.0 or later
- iOS 17.0+ target device or simulator
- ElevenLabs account with Conversational AI setup

## Project Structure

```
MotivationalIphoneApp/
├── App/
│   ├── MotivationalCoachApp.swift    # Main app entry point
│   └── ContentView.swift              # Root view with navigation logic
├── Models/
│   ├── User.swift                     # User profile model
│   ├── Goal.swift                     # Goal model with progress tracking
│   ├── DailyProgress.swift            # Daily completion tracking
│   └── ConversationSession.swift      # Conversation history
├── Views/
│   ├── Onboarding/
│   │   ├── WelcomeView.swift         # Welcome screen
│   │   └── GoalSetupView.swift       # Goal setup flow
│   ├── Home/
│   │   └── HomeView.swift            # Main dashboard
│   └── Coach/
│       └── CoachConversationView.swift # Voice conversation UI
├── Services/
│   ├── ElevenLabsService.swift       # ElevenLabs integration
│   ├── DataService.swift             # Data management
│   └── NotificationService.swift     # Local notifications
└── Utilities/
    └── Constants.swift                # App constants
```

## Step-by-Step Setup

### 1. Create Xcode Project

1. Open Xcode
2. File → New → Project
3. Choose "iOS" → "App"
4. Configure:
   - Product Name: **MotivationalCoachApp**
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **SwiftData** (if available, otherwise None)
5. Choose a location and create

### 2. Add Files to Xcode Project

1. In Xcode, right-click on your project in the navigator
2. Select "Add Files to MotivationalCoachApp..."
3. Navigate to the directory where you created the files
4. Select all folders (App, Models, Views, Services, Utilities)
5. Make sure "Copy items if needed" is UNCHECKED (they're already in place)
6. Make sure "Create groups" is selected
7. Click "Add"

### 3. Configure Info.plist

Add these keys to your Info.plist:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>We need access to your microphone to enable voice conversations with your AI coach.</string>

<key>NSSpeechRecognitionUsageDescription</key>
<string>We use speech recognition to understand your voice commands and responses.</string>

<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>
```

**How to edit Info.plist:**
1. In Xcode, click on your project name in the navigator
2. Select your target
3. Go to the "Info" tab
4. Click the "+" button to add custom keys
5. Add each key above with its corresponding value

### 4. Configure Capabilities

1. In Xcode, select your project
2. Select your target
3. Go to "Signing & Capabilities"
4. Click "+ Capability" and add:
   - **Push Notifications** (for daily check-ins)
   - **Background Modes** → Check "Audio, AirPlay, and Picture in Picture"

### 5. Install ElevenLabs SDK

You have two options:

#### Option A: Swift Package Manager (Recommended)

1. In Xcode, go to File → Add Package Dependencies
2. Enter the ElevenLabs SDK URL (check their documentation for the exact URL)
3. Common URL pattern: `https://github.com/elevenlabs/elevenlabs-swift`
4. Select version and add to your target

#### Option B: Check ElevenLabs Documentation

Visit: https://elevenlabs.io/docs/conversational-ai/client-sdk-reference

They may provide:
- CocoaPods installation
- Manual framework integration
- Alternative package manager instructions

### 6. Configure ElevenLabs Credentials

1. Open `Utilities/Constants.swift`
2. Replace placeholder values:

```swift
enum ElevenLabs {
    static let apiKey = "YOUR_ACTUAL_API_KEY"
    static let agentId = "YOUR_ACTUAL_AGENT_ID"
}
```

**Where to find these:**
- API Key: https://elevenlabs.io/app/settings/api-keys
- Agent ID: https://elevenlabs.io/app/conversational-ai (select your agent)

### 7. Update ElevenLabsService.swift

Once you have the ElevenLabs SDK installed, update the service implementation:

1. Import the ElevenLabs SDK at the top of the file
2. Replace placeholder methods with actual SDK calls
3. Implement proper delegates/callbacks
4. Handle audio session configuration

**Example structure (adapt to actual SDK):**
```swift
import ElevenLabs // or whatever the module name is

@MainActor
class ElevenLabsService: ObservableObject {
    private var client: ElevenLabsClient? // Use actual SDK client

    func connect() async {
        let config = ElevenLabsConfig(
            apiKey: apiKey,
            agentId: agentId
        )
        client = ElevenLabsClient(config: config)
        await client?.connect()
        isConnected = true
    }

    // ... implement other methods
}
```

### 8. Test the App

1. Select your target device or simulator (iOS 17+)
2. Press Cmd+R to build and run
3. The app should:
   - Show the welcome screen
   - Allow you to create a user
   - Guide you through goal setup
   - Display the home dashboard
   - Allow voice conversations (once ElevenLabs is configured)

## Current Implementation Status

### ✅ Completed
- SwiftUI project structure
- SwiftData models for persistence
- Onboarding flow (Welcome + Goal Setup)
- Home screen with progress tracking
- Conversation UI
- Local notification scheduling
- Data service for CRUD operations

### 🚧 Needs Integration
- ElevenLabs Conversational AI SDK
  - The service layer is built but needs actual SDK implementation
  - Voice input/output in goal setup
  - Real-time conversation in CoachConversationView

### 📋 To Be Added (Future Features)
- Cloud sync (iCloud/Firebase)
- Multiple goals support
- Progress charts and analytics
- Customizable notification times
- Coach personality customization
- Conversation history review

## Troubleshooting

### Build Errors

**"Cannot find type 'ModelContainer' in scope"**
- Make sure you're targeting iOS 17.0+
- SwiftData requires iOS 17 minimum

**"Module 'ElevenLabs' not found"**
- Verify the SDK is properly added via Swift Package Manager
- Check the import statement matches the actual module name

### Runtime Issues

**Notifications not appearing**
- Check notification permissions are granted
- Verify notification scheduling in Settings → Notifications
- Ensure the time is set correctly in Constants.swift

**Voice not working**
- Check microphone permissions in Settings → Privacy
- Verify Info.plist has microphone usage description
- Make sure ElevenLabs credentials are correct

## Next Steps

1. **Get ElevenLabs SDK Details**
   - Check their latest documentation for iOS SDK
   - Some SDKs may be in beta or require special access

2. **Implement Voice Features**
   - Update ElevenLabsService with real SDK calls
   - Add voice input to goal setup
   - Enable push-to-talk in conversation view

3. **Test on Real Device**
   - Voice features work best on physical devices
   - Simulator has limited audio capabilities

4. **Customize Coach Personality**
   - Update your ElevenLabs agent's system prompt
   - Test different voice models
   - Refine coaching style

## Resources

- [ElevenLabs Conversational AI Docs](https://elevenlabs.io/docs/conversational-ai/overview)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [SwiftData Guide](https://developer.apple.com/documentation/swiftdata)
- [UserNotifications Framework](https://developer.apple.com/documentation/usernotifications)

## Support

If you encounter issues:
1. Check the ElevenLabs documentation for SDK updates
2. Verify all prerequisites are met
3. Ensure Xcode and iOS versions are compatible
4. Review console logs for specific error messages

---

Built with SwiftUI, SwiftData, and ElevenLabs Conversational AI
