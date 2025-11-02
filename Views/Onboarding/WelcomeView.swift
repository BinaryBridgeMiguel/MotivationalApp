import SwiftUI

struct WelcomeView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataService: DataService
    @State private var showGoalSetup = false
    @State private var userName = ""
    @State private var isPlaying = false

    var body: some View {
        ZStack {
            Constants.UI.Colors.background
                .ignoresSafeArea()

            VStack(spacing: Constants.UI.spacing * 2) {
                Spacer()

                // App Icon/Logo placeholder
                Image(systemName: "figure.run.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .foregroundStyle(Constants.UI.Colors.primary.gradient)

                VStack(spacing: 12) {
                    Text("Welcome to Coach")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Your AI motivational coach that speaks to you")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Spacer()

                VStack(spacing: 16) {
                    // Name input
                    TextField("What's your name?", text: $userName)
                        .textFieldStyle(.roundedBorder)
                        .font(.title3)
                        .padding(.horizontal, Constants.UI.horizontalPadding)
                        .textInputAutocapitalization(.words)

                    // Play intro button
                    Button(action: playIntro) {
                        HStack {
                            Image(systemName: isPlaying ? "stop.circle.fill" : "play.circle.fill")
                            Text(isPlaying ? "Playing..." : "Hear from your coach")
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: Constants.UI.buttonHeight)
                        .background(Constants.UI.Colors.secondaryBackground)
                        .foregroundColor(Constants.UI.Colors.primary)
                        .cornerRadius(Constants.UI.cornerRadius)
                    }
                    .padding(.horizontal, Constants.UI.horizontalPadding)

                    // Get started button
                    Button(action: getStarted) {
                        Text("Get Started")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: Constants.UI.buttonHeight)
                            .background(Constants.UI.Colors.primary)
                            .foregroundColor(.white)
                            .cornerRadius(Constants.UI.cornerRadius)
                    }
                    .padding(.horizontal, Constants.UI.horizontalPadding)
                    .disabled(userName.isEmpty)
                    .opacity(userName.isEmpty ? 0.5 : 1.0)
                }
                .padding(.bottom, 40)
            }
        }
        .fullScreenCover(isPresented: $showGoalSetup) {
            GoalSetupView()
        }
    }

    private func playIntro() {
        // TODO: Play intro message from ElevenLabs
        isPlaying.toggle()

        if isPlaying {
            // Simulate playing for demo
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                isPlaying = false
            }
        }
    }

    private func getStarted() {
        dataService.createUser(name: userName)
        showGoalSetup = true
    }
}

#Preview {
    WelcomeView()
        .environmentObject(DataService(
            modelContainer: try! ModelContainer(for: User.self, Goal.self, DailyProgress.self, ConversationSession.self)
        ))
}
