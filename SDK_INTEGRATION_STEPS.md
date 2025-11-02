# ElevenLabs SDK Integration - Step by Step

This guide walks you through integrating the official ElevenLabs Swift SDK into your motivational coach app.

## Prerequisites

✅ Xcode project created
✅ ElevenLabs account: https://elevenlabs.io
✅ Agent created and configured
✅ Agent ID from your ElevenLabs dashboard

## Step 1: Add the Swift Package (5 minutes)

### In Xcode:

1. Open your project in Xcode
2. Go to **File → Add Package Dependencies**
3. In the search bar, paste:
   ```
   https://github.com/elevenlabs/elevenlabs-swift-sdk.git
   ```
4. Select version **2.0.16** or later
5. Click **Add Package**
6. Ensure the package is added to your app target
7. Wait for Xcode to download and integrate the package

### Verify Installation:

You should see `elevenlabs-swift-sdk` under **Package Dependencies** in your project navigator.

## Step 2: Update Info.plist (2 minutes)

Add required privacy descriptions:

1. In Xcode, click on your project name
2. Select your **target**
3. Go to the **Info** tab
4. Click the **+** button to add new keys:

**Key 1:**
- **Key**: `NSMicrophoneUsageDescription`
- **Type**: String
- **Value**: `We need access to your microphone to enable voice conversations with your AI coach.`

**Key 2:**
- **Key**: `NSCameraUsageDescription`
- **Type**: String
- **Value**: `Camera access may be required for future video features.`

**Alternative:** Edit Info.plist directly:
```xml
<key>NSMicrophoneUsageDescription</key>
<string>We need access to your microphone to enable voice conversations with your AI coach.</string>
<key>NSCameraUsageDescription</key>
<string>Camera access may be required for future video features.</string>
```

## Step 3: Update Constants.swift (1 minute)

Open `Utilities/Constants.swift` and update:

```swift
enum ElevenLabs {
    static let apiKey = "YOUR_ELEVENLABS_API_KEY" // Not needed for public agents
    static let agentId = "YOUR_AGENT_ID_HERE"      // ← REPLACE THIS
}
```

**Where to find your Agent ID:**
1. Go to https://elevenlabs.io/app/conversational-ai
2. Click on your agent
3. The Agent ID is in the URL or agent settings

## Step 4: Enable the SDK in ElevenLabsService.swift (10 minutes)

Open `Services/ElevenLabsService.swift` and follow these steps:

### 4.1: Uncomment the import

**Line 5:** Change from:
```swift
// import ElevenLabs
```
To:
```swift
import ElevenLabs
```

### 4.2: Update the conversation property type

**Line 22:** Change from:
```swift
private var conversation: Any? // Will be Conversation? after import
```
To:
```swift
private var conversation: Conversation?
```

### 4.3: Enable the connect() method

**Lines 39-62:** Uncomment the entire block:
```swift
let config = ConversationConfig(
    conversationOverrides: ConversationOverrides(
        textOnly: false // Enable voice mode
    )
)

// For public agents (no API key needed in client)
conversation = try await ElevenLabs.startConversation(
    agentId: agentId,
    config: config
)

setupConversationObservers()
isConnected = true
print("✅ Connected to ElevenLabs")
```

**Delete or comment out** lines 64-67 (the temporary simulation code).

### 4.4: Enable disconnect()

**Lines 81-85:** Uncomment:
```swift
Task {
    await conversation?.endConversation()
}
```

### 4.5: Enable sendMessage()

**Lines 124-131:** Uncomment:
```swift
do {
    try await conversation?.sendMessage(message)
} catch {
    print("❌ Failed to send message: \(error)")
    self.error = error
}
```

### 4.6: Enable toggleMute()

**Lines 139-145:** Uncomment:
```swift
do {
    try await conversation?.toggleMute()
    print("🔇 Mute toggled")
} catch {
    print("❌ Failed to toggle mute: \(error)")
}
```

### 4.7: Enable conversation observers

**Lines 172-207:** Uncomment the entire setupConversationObservers() block.

### 4.8: Implement state handlers

Update the following methods with real implementations:

**handleStateChange() - Line 211:**
```swift
private func handleStateChange(_ state: ConversationState) {
    print("🔄 State changed: \(state)")

    switch state {
    case .connected:
        isConnected = true
    case .disconnected:
        isConnected = false
        isListening = false
        isSpeaking = false
    case .connecting:
        print("⏳ Connecting...")
    @unknown default:
        break
    }
}
```

**handleMessages() - Line 217:**
```swift
private func handleMessages(_ messages: [Message]) {
    print("💬 Received \(messages.count) messages")

    // Convert to our ConversationMessage model
    self.messages = messages.map { message in
        ConversationMessage(
            role: message.role.rawValue,
            content: message.content,
            timestamp: Date()
        )
    }
}
```

**handleAgentState() - Line 223:**
```swift
private func handleAgentState(_ agentState: AgentState) {
    print("🤖 Agent state: \(agentState)")

    switch agentState {
    case .speaking:
        isSpeaking = true
        isListening = false
    case .listening:
        isSpeaking = false
        isListening = true
    case .thinking:
        isSpeaking = false
        isListening = false
    @unknown default:
        break
    }
}
```

**handleToolCalls() - Line 244:**
```swift
private func handleToolCalls(_ toolCalls: [ClientToolCallEvent]) async {
    for toolCall in toolCalls {
        do {
            let parameters = try toolCall.getParameters()
            let result = await executeClientTool(
                name: toolCall.toolName,
                parameters: parameters
            )

            if toolCall.expectsResponse {
                try await conversation?.sendToolResult(
                    for: toolCall.toolCallId,
                    result: result
                )
            } else {
                conversation?.markToolCallCompleted(toolCall.toolCallId)
            }
        } catch {
            if toolCall.expectsResponse {
                try? await conversation?.sendToolResult(
                    for: toolCall.toolCallId,
                    result: ["error": error.localizedDescription],
                    isError: true
                )
            }
        }
    }
}
```

## Step 5: Build and Test (5 minutes)

### 5.1: Build the project

Press **Cmd+B** to build.

**Common Build Issues:**

❌ **"Cannot find 'ElevenLabs' in scope"**
- Make sure you added the Swift Package correctly
- Check that the import is uncommented

❌ **"Type 'Conversation' is not a member type"**
- Verify the package version is 2.0.16+
- Clean build folder: **Cmd+Shift+K**

### 5.2: Run on Simulator

1. Select **iPhone 15 Pro** simulator (or any iOS 17+ device)
2. Press **Cmd+R** to run
3. The app should launch

### 5.3: Test the connection

1. Complete the onboarding flow
2. Set up a test goal
3. Tap **"Talk to Coach"**
4. You should see:
   - "🎤 Connecting to ElevenLabs..." in console
   - Connection status changes to "Connected"
   - The microphone button becomes active

### 5.4: Test voice conversation

⚠️ **Voice works best on a real device**, not simulator.

On a real iPhone:
1. Connect your iPhone via USB
2. Select it as the target device
3. Run the app
4. Grant microphone permissions when prompted
5. Tap "Talk to Coach"
6. **Hold the microphone button and speak**
7. You should hear the AI coach respond

## Step 6: Configure Your Agent (10 minutes)

Make sure your ElevenLabs agent is properly configured:

### 6.1: System Prompt

Go to your agent settings and use this system prompt:

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
- Reference their specific goal and obstacles when mentioned
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

Context: The user will share their goal, why it matters, and their obstacles at the start of conversations. Reference these throughout your coaching.
```

### 6.2: First Message

Set your agent's first message:

```
Hey! I'm your coach. I'm here to help you push past what's holding you back and achieve what you're working toward. What's on your mind?
```

### 6.3: Voice Selection

Choose a voice that matches the coach personality:
- **Adam** - Confident, powerful
- **Antoni** - Warm, energetic
- **Josh** - Strong, motivating

### 6.4: Make Agent Public (Optional)

For testing, make your agent **public** so you don't need API keys in the client:

1. In agent settings, toggle **"Public Agent"** to ON
2. This allows anyone with the Agent ID to use it
3. For production, use **private agents** with token authentication

## Troubleshooting

### Voice not working

**Problem:** No audio response from agent

**Solutions:**
1. Test on a **real device** (simulator has limited audio)
2. Check microphone permissions in Settings → Privacy
3. Verify your agent has a voice selected
4. Check ElevenLabs account has available characters

### Connection fails

**Problem:** Cannot connect to ElevenLabs

**Solutions:**
1. Verify Agent ID is correct
2. Check internet connection
3. For private agents, implement token fetching
4. Check ElevenLabs service status

### Build errors

**Problem:** Code won't compile

**Solutions:**
1. Clean build folder: **Cmd+Shift+K**
2. Delete derived data: Xcode → Preferences → Locations → Derived Data → Delete
3. Restart Xcode
4. Verify Swift Package is installed correctly

### Microphone permissions denied

**Problem:** App can't access microphone

**Solutions:**
1. Go to iPhone Settings → Privacy → Microphone
2. Enable permission for your app
3. Restart the app

## Next Steps

After successful integration:

✅ Test the full conversation flow
✅ Adjust agent personality as needed
✅ Test different coaching scenarios
✅ Add custom client tools (optional)
✅ Implement token authentication for production
✅ Add conversation history display

## Advanced Features

### Client Tools (Custom Functions)

Allow your agent to trigger app actions:

1. Define tools in your agent configuration
2. Implement handlers in `executeClientTool()`
3. Examples:
   - Mark goal as complete
   - Get current progress
   - Schedule reminder
   - Update goal

### Text-Only Mode

For testing without voice:

```swift
let config = ConversationConfig(
    conversationOverrides: ConversationOverrides(
        textOnly: true
    )
)
```

### Private Agents with Token Authentication

For production apps:

1. Create a backend endpoint to generate conversation tokens
2. Implement `fetchConversationToken()` in your app
3. Never store API keys in the client

## Resources

- [ElevenLabs Swift SDK GitHub](https://github.com/elevenlabs/elevenlabs-swift-sdk)
- [Official Documentation](https://elevenlabs.io/docs/conversational-ai/libraries/swift)
- [ElevenLabs Dashboard](https://elevenlabs.io/app/conversational-ai)

---

**Estimated Time: 30-45 minutes**

**Difficulty: Intermediate**

**Result: Fully functional voice AI coaching app** 🎉
