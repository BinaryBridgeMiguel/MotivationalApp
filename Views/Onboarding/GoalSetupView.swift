import SwiftUI
import SwiftData

struct GoalSetupView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataService: DataService
    @EnvironmentObject var notificationService: NotificationService
    @State private var currentStep = 0
    @State private var isVoiceMode = false

    // Goal data
    @State private var goalText = ""
    @State private var whyItMatters = ""
    @State private var biggestObstacle = ""
    @State private var struggleTime = "Mornings"

    let struggleTimes = ["Mornings", "Afternoons", "Evenings", "Late nights", "Weekends"]

    var body: some View {
        ZStack {
            Constants.UI.Colors.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button("Back") {
                        if currentStep > 0 {
                            withAnimation {
                                currentStep -= 1
                            }
                        } else {
                            dismiss()
                        }
                    }

                    Spacer()

                    Text("Setup Your Goal")
                        .font(.headline)

                    Spacer()

                    // Placeholder for symmetry
                    Button("Back") {
                        // Empty
                    }
                    .opacity(0)
                }
                .padding()

                // Progress indicator
                ProgressView(value: Double(currentStep + 1), total: 4)
                    .padding(.horizontal)

                // Content
                ScrollView {
                    VStack(spacing: Constants.UI.spacing * 2) {
                        // Voice mode toggle
                        HStack {
                            Image(systemName: isVoiceMode ? "mic.fill" : "keyboard")
                            Text(isVoiceMode ? "Voice Mode" : "Text Mode")
                                .font(.subheadline)
                            Spacer()
                            Toggle("", isOn: $isVoiceMode)
                        }
                        .padding()
                        .background(Constants.UI.Colors.secondaryBackground)
                        .cornerRadius(Constants.UI.cornerRadius)
                        .padding(.horizontal, Constants.UI.horizontalPadding)

                        // Step content
                        stepView
                            .padding(.horizontal, Constants.UI.horizontalPadding)

                        Spacer(minLength: 40)

                        // Next button
                        Button(action: nextStep) {
                            Text(currentStep == 3 ? "Complete Setup" : "Continue")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .frame(height: Constants.UI.buttonHeight)
                                .background(canProceed ? Constants.UI.Colors.primary : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(Constants.UI.cornerRadius)
                        }
                        .padding(.horizontal, Constants.UI.horizontalPadding)
                        .disabled(!canProceed)
                    }
                    .padding(.top, 20)
                }
            }
        }
    }

    @ViewBuilder
    private var stepView: some View {
        switch currentStep {
        case 0:
            goalStepView
        case 1:
            whyStepView
        case 2:
            obstacleStepView
        case 3:
            struggleTimeStepView
        default:
            EmptyView()
        }
    }

    private var goalStepView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("What's your goal?")
                .font(.title2)
                .fontWeight(.bold)

            Text("Be specific. What do you want to achieve?")
                .font(.body)
                .foregroundColor(.secondary)

            if isVoiceMode {
                voiceInputButton(binding: $goalText, prompt: "Tell me your goal")
            } else {
                TextField("E.g., Work out 5 days a week", text: $goalText, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3...6)
            }
        }
    }

    private var whyStepView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Why does this matter to you?")
                .font(.title2)
                .fontWeight(.bold)

            Text("The deeper the reason, the stronger your commitment.")
                .font(.body)
                .foregroundColor(.secondary)

            if isVoiceMode {
                voiceInputButton(binding: $whyItMatters, prompt: "Why does this goal matter?")
            } else {
                TextField("E.g., I want to have energy to play with my kids", text: $whyItMatters, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3...6)
            }
        }
    }

    private var obstacleStepView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("What's your biggest obstacle?")
                .font(.title2)
                .fontWeight(.bold)

            Text("Be honest. What usually gets in your way?")
                .font(.body)
                .foregroundColor(.secondary)

            if isVoiceMode {
                voiceInputButton(binding: $biggestObstacle, prompt: "What's holding you back?")
            } else {
                TextField("E.g., I always hit snooze on my alarm", text: $biggestObstacle, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3...6)
            }
        }
    }

    private var struggleTimeStepView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("When do you usually struggle?")
                .font(.title2)
                .fontWeight(.bold)

            Text("This helps your coach show up when you need it most.")
                .font(.body)
                .foregroundColor(.secondary)

            VStack(spacing: 12) {
                ForEach(struggleTimes, id: \.self) { time in
                    Button(action: {
                        struggleTime = time
                    }) {
                        HStack {
                            Text(time)
                                .foregroundColor(struggleTime == time ? .white : .primary)
                            Spacer()
                            if struggleTime == time {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(struggleTime == time ? Constants.UI.Colors.primary : Constants.UI.Colors.secondaryBackground)
                        .cornerRadius(Constants.UI.cornerRadius)
                    }
                }
            }
        }
    }

    private func voiceInputButton(binding: Binding<String>, prompt: String) -> some View {
        Button(action: {
            // TODO: Implement voice input with ElevenLabs
            print("Voice input: \(prompt)")
        }) {
            HStack {
                Image(systemName: "mic.circle.fill")
                    .font(.title)
                Text(binding.wrappedValue.isEmpty ? "Tap to speak" : binding.wrappedValue)
                    .lineLimit(3)
                Spacer()
            }
            .padding()
            .frame(minHeight: 100)
            .background(Constants.UI.Colors.secondaryBackground)
            .cornerRadius(Constants.UI.cornerRadius)
        }
    }

    private var canProceed: Bool {
        switch currentStep {
        case 0: return !goalText.isEmpty
        case 1: return !whyItMatters.isEmpty
        case 2: return !biggestObstacle.isEmpty
        case 3: return true
        default: return false
        }
    }

    private func nextStep() {
        if currentStep < 3 {
            withAnimation {
                currentStep += 1
            }
        } else {
            completeSetup()
        }
    }

    private func completeSetup() {
        dataService.createGoal(
            goalText: goalText,
            whyItMatters: whyItMatters,
            biggestObstacle: biggestObstacle,
            struggleTime: struggleTime
        )

        // Request notification permissions
        Task {
            _ = await notificationService.requestAuthorization()
            await notificationService.scheduleDailyCheckIn()
        }

        dismiss()
    }
}

#Preview {
    let schema = Schema([User.self, Goal.self, DailyProgress.self, ConversationSession.self])
    let container = try! ModelContainer(for: schema, configurations: ModelConfiguration(isStoredInMemoryOnly: true))

    return GoalSetupView()
        .environmentObject(DataService(modelContainer: container))
}
