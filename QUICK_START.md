# Quick Start Guide

Get your motivational coach app running in 10 minutes.

## What You'll Need

- [ ] Mac with Xcode 15+
- [ ] ElevenLabs account (free tier is fine)
- [ ] 10 minutes

## Step 1: Create Your Coach (5 min)

1. Go to https://elevenlabs.io/app/conversational-ai
2. Click "Create New Agent"
3. Name it "Motivational Coach"
4. Choose a powerful voice (Adam, Antoni, or Josh recommended)
5. Copy the system prompt from `ELEVENLABS_INTEGRATION.md`
6. Save and note your **Agent ID**

## Step 2: Get Your API Key (1 min)

1. Go to https://elevenlabs.io/app/settings/api-keys
2. Create a new API key
3. Copy it somewhere safe

## Step 3: Create Xcode Project (2 min)

1. Open Xcode
2. File → New → Project
3. Choose "iOS App"
4. Settings:
   - Name: **MotivationalCoachApp**
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **None** (we'll use SwiftData manually)
5. Save it to `/Users/mich/Documents/Apps/MotivationalIphoneApp`

## Step 4: Add Project Files (1 min)

In Xcode:
1. Right-click project name → "Add Files to..."
2. Select all folders: App, Models, Views, Services, Utilities
3. **UNCHECK** "Copy items if needed"
4. **SELECT** "Create groups"
5. Click Add

## Step 5: Configure (1 min)

1. Open `Utilities/Constants.swift`
2. Replace:
   ```swift
   static let apiKey = "YOUR_ACTUAL_API_KEY"
   static let agentId = "YOUR_ACTUAL_AGENT_ID"
   ```

3. Click your project name → Target → Info tab
4. Add these keys:
   - **NSMicrophoneUsageDescription**: "For voice conversations with your coach"
   - **NSSpeechRecognitionUsageDescription**: "To understand your voice"

## Step 6: Run It! (30 sec)

1. Select "iPhone 15 Pro" simulator (or any iOS 17+ device)
2. Press **Cmd+R**
3. The app should launch!

## What You'll See

✅ Welcome screen with your coach greeting
✅ Goal setup flow
✅ Home dashboard with streak tracking
✅ Conversation screen (voice needs SDK integration)

## Known Limitations (MVP)

⚠️ **Voice is not yet connected** - The ElevenLabs service is a placeholder
⚠️ You need to complete the SDK integration (see `ELEVENLABS_INTEGRATION.md`)

## Temporary Workaround

While integrating the SDK, you can:
1. Use text input instead of voice
2. Have the app speak responses using iOS native TTS
3. Test the full UI and data flow

## Next Action

Choose one:

**A) Full Voice Integration** → Follow `ELEVENLABS_INTEGRATION.md`

**B) Text MVP First** → Modify `CoachConversationView.swift` to use text input

**C) Explore the UI** → Just run it and see the design

## Troubleshooting

**Build fails?**
- Make sure target is iOS 17.0+
- Check all files are added to target

**Simulator crashes?**
- Try a different simulator
- Clean build: Cmd+Shift+K

**Can't find models?**
- Verify SwiftData models are in the target membership

## Support Files

- `README.md` - Project overview
- `SETUP_GUIDE.md` - Detailed setup
- `ELEVENLABS_INTEGRATION.md` - Voice AI integration

---

**Ready to build?** Start at Step 1 above.

**Questions?** Check the detailed guides in the documentation files.
