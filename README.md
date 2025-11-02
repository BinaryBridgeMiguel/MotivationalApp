# Motivational Coach iOS App

An AI-powered motivational coaching app that uses voice to help people achieve their goals. Built with SwiftUI, SwiftData, and ElevenLabs Conversational AI.

## Features

- **Voice-First Coaching**: Real-time AI voice conversations with your personal coach
- **Goal Tracking**: Set and track your goals with streak monitoring
- **Daily Check-ins**: Automated reminders to stay accountable
- **Progress Dashboard**: Visual tracking of your progress and achievements
- **Personalized Motivation**: AI coach that knows your goals, obstacles, and why it matters

## Tech Stack

- **iOS**: SwiftUI + SwiftData (iOS 17+)
- **AI Voice**: ElevenLabs Conversational AI
- **Storage**: Local persistence with SwiftData
- **Notifications**: UserNotifications framework

## Quick Start

1. **Prerequisites**
   - Xcode 15.0+
   - iOS 17.0+
   - ElevenLabs account

2. **Clone and Setup**
   ```bash
   # The project structure is already created
   # Open the directory in Xcode
   ```

3. **Create Xcode Project**
   - Follow instructions in `SETUP_GUIDE.md`

4. **Integrate ElevenLabs Voice**
   - Follow the step-by-step guide: **[`SDK_INTEGRATION_STEPS.md`](SDK_INTEGRATION_STEPS.md)**
   - Takes ~30 minutes to complete
   - Results in fully functional voice coaching

5. **Build and Run**
   - Select your target device
   - Press Cmd+R

## Documentation

- 🚀 **[`SDK_INTEGRATION_STEPS.md`](SDK_INTEGRATION_STEPS.md)** - **START HERE** for ElevenLabs voice integration
- [`SETUP_GUIDE.md`](SETUP_GUIDE.md) - Complete Xcode project setup
- [`QUICK_START.md`](QUICK_START.md) - 10-minute quick start guide
- [`ELEVENLABS_INTEGRATION.md`](ELEVENLABS_INTEGRATION.md) - Detailed voice AI concepts

## Project Structure

```
├── App/                    # App entry point and root views
├── Models/                 # SwiftData models
├── Views/                  # SwiftUI views
│   ├── Onboarding/        # Welcome and goal setup
│   ├── Home/              # Main dashboard
│   └── Coach/             # Voice conversation
├── Services/              # Business logic and integrations
└── Utilities/             # Constants and helpers
```

## Current Status

### ✅ Completed
- Full SwiftUI interface
- SwiftData persistence
- Onboarding flow
- Progress tracking
- Notification scheduling

### 🚧 Ready to Integrate
- ElevenLabs SDK integration (service ready, follow [`SDK_INTEGRATION_STEPS.md`](SDK_INTEGRATION_STEPS.md))

### 📋 Planned
- Cloud sync
- Multiple goals
- Analytics dashboard
- Customizable notifications

## Key Components

### Models
- `User` - User profile and preferences
- `Goal` - Goal with tracking and context
- `DailyProgress` - Daily completion tracking
- `ConversationSession` - Conversation history

### Views
- `WelcomeView` - First-time user onboarding
- `GoalSetupView` - Goal creation wizard
- `HomeView` - Dashboard with progress
- `CoachConversationView` - Voice interaction

### Services
- `DataService` - Data management and CRUD
- `ElevenLabsService` - Voice AI integration
- `NotificationService` - Daily reminders

## Configuration

Update `Utilities/Constants.swift`:

```swift
enum ElevenLabs {
    static let apiKey = "your_api_key"
    static let agentId = "your_agent_id"
}
```

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+
- ElevenLabs account

## License

This is an MVP project. Feel free to use and modify as needed.

## Next Steps

1. Complete ElevenLabs integration
2. Test on real device
3. Refine coach personality
4. Add analytics
5. Implement cloud sync

---

Built with SwiftUI and powered by AI
