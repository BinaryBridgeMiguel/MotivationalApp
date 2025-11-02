# ElevenLabs Integration Guide

This document provides detailed instructions for integrating the ElevenLabs Conversational AI SDK into the app.

## Overview

The app uses ElevenLabs Conversational AI for real-time voice coaching. The integration happens primarily in `Services/ElevenLabsService.swift`.

## Prerequisites

1. ElevenLabs account: https://elevenlabs.io
2. Conversational AI agent created and configured
3. API key from your account settings

## Setting Up Your ElevenLabs Agent

### 1. Create Your Agent

1. Go to https://elevenlabs.io/app/conversational-ai
2. Click "Create New Agent"
3. Configure the agent:

**Agent Configuration:**
```
Name: Motivational Coach

Voice: Choose a powerful, energetic voice (e.g., Adam, Antoni, or Josh)

First Message:
"Hey! I'm your coach. I'm here to help you crush your goals and push past what you thought was possible. Let's talk about what you're working on."
```

### 2. System Prompt

Use this system prompt for your agent (customize as needed):

```
You are a powerful, authentic motivational coach. Your purpose is to help people achieve their goals through honest, energetic, and impactful coaching.

PERSONALITY TRAITS:
- Raw and authentic - no corporate speak or generic platitudes
- Direct but caring - you tell the truth because you care about their success
- Energetic and powerful - your energy is contagious
- Occasionally use strong language for emphasis (when appropriate)
- Celebrate wins genuinely
- Call out excuses respectfully but firmly
- Conversational and natural

CORE PHILOSOPHY:
1. Everyone has untapped potential
2. Discomfort is where growth happens
3. Consistency beats intensity
4. The mind quits before the body
5. Your past doesn't define your future
6. Action creates clarity

COACHING APPROACH:
- Ask powerful questions
- Help them identify their "why"
- Challenge limiting beliefs
- Acknowledge struggles without dwelling
- Provide specific, actionable steps
- Hold them accountable with compassion
- Remind them of their stated goals and reasons

CONVERSATIONAL STYLE:
- Keep responses concise (2-3 sentences usually)
- Use "you" language to make it personal
- Reference their specific goal and obstacles
- Match their energy - meet them where they are
- Don't be afraid of silence - let them think
- Real talk over motivational clichés

AVOID:
- Long monologues
- Generic advice
- Toxic positivity
- Dismissing their struggles
- Being overly soft when they need a push
- Being harsh when they need support

Remember: You know their goal, why it matters to them, and what usually holds them back. Use this context in your coaching.
```

### 3. Knowledge Base (Optional)

Add these to your agent's knowledge base if available:

**Goal Context Variables:**
- `{{user_goal}}` - Their current goal
- `{{why_it_matters}}` - Why this goal is important
- `{{biggest_obstacle}}` - Their main challenge
- `{{current_streak}}` - Days of consecutive progress
- `{{struggle_time}}` - When they typically struggle

### 4. Conversation Settings

- **Language:** English
- **Response Time:** Fast (for real-time feel)
- **Interruption Handling:** Enabled (allow natural conversation flow)
- **End of Speech Detection:** Medium sensitivity

## iOS SDK Integration

### Option 1: Using the Official SDK (When Available)

Check the official documentation:
https://elevenlabs.io/docs/conversational-ai/client-sdk-reference

### Option 2: WebSocket Implementation

If no official iOS SDK is available, you can use their WebSocket API:

```swift
import Foundation

class ElevenLabsService: ObservableObject {
    private var webSocket: URLSessionWebSocketTask?
    private let apiKey: String
    private let agentId: String

    init() {
        self.apiKey = Constants.ElevenLabs.apiKey
        self.agentId = Constants.ElevenLabs.agentId
    }

    func connect() async {
        let url = URL(string: "wss://api.elevenlabs.io/v1/convai/conversation?agent_id=\(agentId)")!
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "xi-api-key")

        let session = URLSession(configuration: .default)
        webSocket = session.webSocketTask(with: request)
        webSocket?.resume()

        await receiveMessages()
    }

    private func receiveMessages() async {
        // Implement message receiving logic
    }

    func sendAudio(data: Data) async {
        // Send audio chunks to the API
        let message = URLSessionWebSocketTask.Message.data(data)
        try? await webSocket?.send(message)
    }
}
```

### Option 3: REST API Integration

For simpler integration without real-time voice:

```swift
func sendTextMessage(_ text: String) async throws -> String {
    let url = URL(string: "https://api.elevenlabs.io/v1/convai/conversation")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue(apiKey, forHTTPHeaderField: "xi-api-key")

    let body: [String: Any] = [
        "agent_id": agentId,
        "text": text
    ]
    request.httpBody = try JSONSerialization.data(withJSONObject: body)

    let (data, _) = try await URLSession.shared.data(for: request)
    // Process response
    return "" // Return agent's response
}
```

## Audio Handling

### Record User Audio

```swift
import AVFoundation

class AudioRecorder: NSObject, AVAudioRecorderDelegate {
    private var audioRecorder: AVAudioRecorder?

    func startRecording() {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 16000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: getAudioURL(), settings: settings)
            audioRecorder?.record()
        } catch {
            print("Recording failed: \(error)")
        }
    }

    func stopRecording() -> Data? {
        audioRecorder?.stop()
        return try? Data(contentsOf: getAudioURL())
    }
}
```

### Play Agent Audio Response

```swift
import AVFoundation

class AudioPlayer {
    private var audioPlayer: AVAudioPlayer?

    func play(audioData: Data) {
        do {
            audioPlayer = try AVAudioPlayer(data: audioData)
            audioPlayer?.play()
        } catch {
            print("Playback failed: \(error)")
        }
    }
}
```

## Passing Context to Agent

### Method 1: Session Initialization

When starting a conversation, pass user context:

```swift
func startConversation(with goal: Goal) async {
    let context = [
        "goal": goal.goalText,
        "why": goal.whyItMatters,
        "obstacle": goal.biggestObstacle,
        "streak": String(goal.currentStreak)
    ]

    // Send context with first message or session init
    await sendContext(context)
}
```

### Method 2: Custom Variables

If the agent supports variable interpolation:

```swift
func updateAgentVariables(goal: Goal) async {
    let variables = """
    {
        "user_goal": "\(goal.goalText)",
        "why_it_matters": "\(goal.whyItMatters)",
        "biggest_obstacle": "\(goal.biggestObstacle)",
        "current_streak": "\(goal.currentStreak)"
    }
    """

    // Send to agent configuration endpoint
}
```

### Method 3: Context in Messages

Include context in the conversation flow:

```swift
func startCoachingSession() async {
    let contextMessage = """
    The user's goal is: \(goal.goalText)
    This matters to them because: \(goal.whyItMatters)
    Their main challenge is: \(goal.biggestObstacle)
    Current streak: \(goal.currentStreak) days
    """

    await sendMessage(contextMessage)
}
```

## Implementation Checklist

- [ ] Sign up for ElevenLabs account
- [ ] Create Conversational AI agent
- [ ] Configure agent with system prompt
- [ ] Get API key and Agent ID
- [ ] Update Constants.swift with credentials
- [ ] Choose integration method (SDK/WebSocket/REST)
- [ ] Implement audio recording
- [ ] Implement audio playback
- [ ] Add context passing
- [ ] Test conversation flow
- [ ] Handle errors gracefully
- [ ] Add loading states
- [ ] Implement reconnection logic

## Testing

### Test Cases

1. **Connection Test**
   - Agent connects successfully
   - Connection status updates in UI
   - Handles connection failures

2. **Voice Input Test**
   - Microphone captures audio
   - Audio is sent to ElevenLabs
   - Transcription is accurate

3. **Voice Output Test**
   - Agent's response plays clearly
   - Audio quality is good
   - Playback doesn't overlap with recording

4. **Context Test**
   - Agent knows user's goal
   - Agent references obstacles
   - Agent tracks progress accurately

5. **Conversation Flow**
   - Natural back-and-forth
   - Agent responds appropriately
   - Handles interruptions

## Troubleshooting

### Audio Issues
- Check microphone permissions
- Verify audio session configuration
- Test on real device (simulator limited)

### Connection Issues
- Validate API key
- Check Agent ID is correct
- Verify network connectivity

### Quality Issues
- Adjust sample rate
- Check audio format settings
- Test different voice models

## Alternative: Text-Based MVP

If voice integration is complex, start with text:

1. Use text input instead of voice
2. Display agent responses as text
3. Add text-to-speech for agent (iOS AVSpeechSynthesizer)
4. Upgrade to full voice later

```swift
import AVFoundation

let synthesizer = AVSpeechSynthesizer()
let utterance = AVSpeechUtterance(string: agentResponse)
utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
synthesizer.speak(utterance)
```

## Resources

- [ElevenLabs API Reference](https://elevenlabs.io/docs/api-reference)
- [Conversational AI Guide](https://elevenlabs.io/docs/conversational-ai)
- [iOS AVFoundation](https://developer.apple.com/documentation/avfoundation)

---

**Next:** After integration, test thoroughly and adjust the agent's personality based on real conversations.
