import Foundation
import Combine
import ElevenLabs

/// Service for managing ElevenLabs Conversational AI integration
/// Handles voice conversations with the AI coach
@MainActor
class ElevenLabsService: ObservableObject {
    // MARK: - Published Properties

    @Published var isConnected = false
    @Published var isListening = false
    @Published var isSpeaking = false
    @Published var error: Error?
    @Published var messages: [ConversationMessage] = []

    // MARK: - Private Properties

    private let agentId: String
    private var conversation: Conversation?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    init() {
        self.agentId = Constants.ElevenLabs.agentId
    }

    // MARK: - Connection Management

    /// Starts a new conversation with the ElevenLabs agent
    func connect() async {
        print("🎤 Connecting to ElevenLabs with Agent ID: \(agentId)")

        do {
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

        } catch {
            print("❌ Failed to connect: \(error)")
            self.error = error
            isConnected = false
        }
    }

    /// Ends the current conversation
    func disconnect() {
        print("🔌 Disconnecting from ElevenLabs")

        Task {
            await conversation?.endConversation()
        }

        conversation = nil
        isConnected = false
        isListening = false
        isSpeaking = false
        cancellables.removeAll()
    }

    // MARK: - Conversation Management

    /// Starts listening for user input (automatically handled by SDK)
    func startConversation() async {
        guard isConnected else {
            print("⚠️ Cannot start conversation - not connected")
            return
        }

        isListening = true
        print("🎙️ Conversation active - speak now")
    }

    /// Stops the active conversation
    func stopConversation() {
        isListening = false
        isSpeaking = false
        print("⏸️ Conversation paused")
    }

    /// Sends a text message to the agent
    func sendMessage(_ message: String) async {
        guard isConnected else {
            print("⚠️ Cannot send message - not connected")
            return
        }

        print("📤 Sending message: \(message)")

        do {
            try await conversation?.sendMessage(message)
        } catch {
            print("❌ Failed to send message: \(error)")
            self.error = error
        }
    }

    /// Toggles microphone mute state
    func toggleMute() async {
        guard isConnected else { return }

        do {
            try await conversation?.toggleMute()
            print("🔇 Mute toggled")
        } catch {
            print("❌ Failed to toggle mute: \(error)")
        }
    }

    // MARK: - Context Management

    /// Updates the conversation with user's goal context
    /// Send this as an initial message when starting a conversation
    func updateConversationContext(goal: String, progress: Int, obstacles: String) async {
        let contextMessage = """
        [Context Update]
        User's Goal: \(goal)
        Current Streak: \(progress) days
        Known Obstacles: \(obstacles)

        Please reference this context in our conversation.
        """

        await sendMessage(contextMessage)
    }

    // MARK: - Private Methods

    /// Sets up observers for conversation state changes
    private func setupConversationObservers() {
        // Note: The actual observer implementation depends on the ElevenLabs SDK version
        // This is a placeholder for future implementation when SDK documentation is available
        print("📡 Setting up conversation observers")
    }


    /// Executes a client tool (custom function called by the agent)
    private func executeClientTool(name: String, parameters: [String: Any]) async -> [String: Any] {
        print("🔧 Executing tool: \(name) with params: \(parameters)")

        // Example: Handle custom tools
        switch name {
        case "mark_complete":
            // Trigger completion in DataService
            return ["success": true, "message": "Goal marked as complete"]
        case "get_progress":
            // Return current progress
            return ["streak": 5, "this_week": 4]
        default:
            return ["error": "Unknown tool: \(name)"]
        }
    }
}

// MARK: - Conversation Message Model

/// Simple message model for displaying conversation history
struct ConversationMessage: Identifiable {
    let id = UUID()
    let role: String // "user" or "assistant"
    let content: String
    let timestamp: Date
}

// MARK: - Setup Instructions
/*
 TO ENABLE ELEVENLABS VOICE:

 1. Add Swift Package in Xcode:
    - File → Add Package Dependencies
    - URL: https://github.com/elevenlabs/elevenlabs-swift-sdk.git
    - Version: 2.0.16 or later

 2. Uncomment the import at the top:
    - import ElevenLabs

 3. Uncomment all the SDK code marked with STEP comments above

 4. Update Info.plist:
    - NSMicrophoneUsageDescription: "For voice conversations with your coach"
    - NSCameraUsageDescription: "For video features (optional)"

 5. Update Constants.swift:
    - Add your Agent ID from https://elevenlabs.io/app/conversational-ai

 6. For private agents:
    - Implement fetchConversationToken() to get tokens from your backend
    - Never store API keys in the client app

 The app will work with simulated connection until you complete these steps.
 */
