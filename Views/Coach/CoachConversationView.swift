import SwiftUI

struct CoachConversationView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataService: DataService
    @StateObject private var elevenLabsService = ElevenLabsService()

    @State private var isConnecting = false
    @State private var currentSession: ConversationSession?

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Constants.UI.Colors.primary.opacity(0.3),
                    Constants.UI.Colors.background
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: endConversation) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("End")
                        }
                        .foregroundColor(.primary)
                    }

                    Spacer()

                    // Connection status
                    HStack(spacing: 6) {
                        Circle()
                            .fill(elevenLabsService.isConnected ? Color.green : Color.orange)
                            .frame(width: 8, height: 8)
                        Text(elevenLabsService.isConnected ? "Connected" : "Connecting...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()

                Spacer()

                // Center content
                VStack(spacing: 40) {
                    // Coach avatar/animation
                    ZStack {
                        // Animated circles for speaking state
                        if elevenLabsService.isSpeaking {
                            ForEach(0..<3) { index in
                                Circle()
                                    .stroke(Constants.UI.Colors.primary.opacity(0.3), lineWidth: 2)
                                    .frame(width: 150 + CGFloat(index * 30), height: 150 + CGFloat(index * 30))
                                    .scaleEffect(elevenLabsService.isSpeaking ? 1.2 : 1.0)
                                    .animation(
                                        Animation.easeInOut(duration: 1.5)
                                            .repeatForever(autoreverses: true)
                                            .delay(Double(index) * 0.2),
                                        value: elevenLabsService.isSpeaking
                                    )
                            }
                        }

                        // Main icon
                        Image(systemName: elevenLabsService.isSpeaking ? "waveform.circle.fill" : "mic.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .foregroundStyle(Constants.UI.Colors.primary.gradient)
                            .scaleEffect(elevenLabsService.isSpeaking ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: elevenLabsService.isSpeaking)
                    }

                    // Status text
                    VStack(spacing: 8) {
                        Text(statusText)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)

                        if elevenLabsService.isListening {
                            Text("Tap and hold to speak")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                Spacer()

                // Bottom controls
                VStack(spacing: 20) {
                    if elevenLabsService.isConnected {
                        // Main talk button (push-to-talk)
                        Button(action: {}) {
                            Image(systemName: elevenLabsService.isListening ? "mic.fill" : "mic")
                                .font(.system(size: 32))
                                .frame(width: 80, height: 80)
                                .background(elevenLabsService.isListening ? Constants.UI.Colors.primary : Constants.UI.Colors.secondaryBackground)
                                .foregroundColor(elevenLabsService.isListening ? .white : Constants.UI.Colors.primary)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                        }
                        .buttonStyle(PressButtonStyle(
                            onPress: { startSpeaking() },
                            onRelease: { stopSpeaking() }
                        ))

                        // Quick actions
                        HStack(spacing: 16) {
                            quickActionButton(icon: "checkmark.circle", title: "Mark Complete") {
                                // Mark today as complete
                                dataService.recordDailyProgress(completed: true)
                            }

                            quickActionButton(icon: "lightbulb", title: "Need Motivation") {
                                // Request motivational message
                                Task {
                                    await elevenLabsService.sendMessage("I need some motivation right now")
                                }
                            }
                        }
                    } else {
                        ProgressView()
                            .scaleEffect(1.5)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .task {
            await connectToCoach()
        }
    }

    private var statusText: String {
        if !elevenLabsService.isConnected {
            return "Connecting to your coach..."
        } else if elevenLabsService.isSpeaking {
            return "Coach is speaking..."
        } else if elevenLabsService.isListening {
            return "I'm listening..."
        } else {
            return "Ready to talk"
        }
    }

    private func quickActionButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Constants.UI.Colors.secondaryBackground)
            .cornerRadius(12)
        }
        .foregroundColor(.primary)
    }

    private func connectToCoach() async {
        isConnecting = true
        currentSession = dataService.startConversationSession()

        // Connect to ElevenLabs
        await elevenLabsService.connect()

        // Update conversation context
        if let goal = dataService.activeGoal {
            await elevenLabsService.updateConversationContext(
                goal: goal.goalText,
                progress: goal.currentStreak,
                obstacles: goal.biggestObstacle
            )
        }

        // Start conversation
        await elevenLabsService.startConversation()

        isConnecting = false
    }

    private func startSpeaking() {
        // User starts speaking
        print("User started speaking")
    }

    private func stopSpeaking() {
        // User stopped speaking
        print("User stopped speaking")
    }

    private func endConversation() {
        elevenLabsService.stopConversation()
        elevenLabsService.disconnect()

        if let session = currentSession {
            dataService.endConversationSession(session)
        }

        dismiss()
    }
}

// Custom button style for push-to-talk
struct PressButtonStyle: ButtonStyle {
    let onPress: () -> Void
    let onRelease: () -> Void

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { _, isPressed in
                if isPressed {
                    onPress()
                } else {
                    onRelease()
                }
            }
    }
}

#Preview {
    CoachConversationView()
        .environmentObject(DataService(
            modelContainer: try! ModelContainer(for: User.self, Goal.self, DailyProgress.self, ConversationSession.self)
        ))
}
