import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataService: DataService
    @State private var showCoachConversation = false
    @State private var showGoalSetup = false

    var body: some View {
        ZStack {
            Constants.UI.Colors.background
                .ignoresSafeArea()

            if let goal = dataService.activeGoal {
                activeGoalView(goal: goal)
            } else {
                noGoalView
            }
        }
        .fullScreenCover(isPresented: $showCoachConversation) {
            CoachConversationView()
        }
        .fullScreenCover(isPresented: $showGoalSetup) {
            GoalSetupView()
        }
    }

    @ViewBuilder
    private func activeGoalView(goal: Goal) -> some View {
        VStack(spacing: Constants.UI.spacing * 2) {
            // Header with user name
            HStack {
                VStack(alignment: .leading) {
                    if let user = dataService.currentUser {
                        Text("Hey, \(user.name)")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    Text("Let's make today count")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()

                Menu {
                    Button(action: { showGoalSetup = true }) {
                        Label("Edit Goal", systemImage: "pencil")
                    }
                    Button(action: { /* Settings */ }) {
                        Label("Settings", systemImage: "gear")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, Constants.UI.horizontalPadding)
            .padding(.top, 20)

            ScrollView {
                VStack(spacing: Constants.UI.spacing) {
                    // Current Goal Card
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your Goal")
                            .font(.headline)
                            .foregroundColor(.secondary)

                        Text(goal.goalText)
                            .font(.title2)
                            .fontWeight(.semibold)

                        Divider()

                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Why it matters")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(goal.whyItMatters)
                                    .font(.subheadline)
                            }
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Constants.UI.Colors.secondaryBackground)
                    .cornerRadius(Constants.UI.cornerRadius)

                    // Stats Section
                    HStack(spacing: 16) {
                        // Streak Card
                        statCard(
                            title: "Current Streak",
                            value: "\(goal.currentStreak)",
                            subtitle: "days",
                            icon: "flame.fill",
                            color: .orange
                        )

                        // This Week Card
                        statCard(
                            title: "This Week",
                            value: "\(goal.completionsThisWeek)",
                            subtitle: "of 7 days",
                            icon: "checkmark.circle.fill",
                            color: .green
                        )
                    }

                    // Today's Progress
                    todayProgressCard

                    // Talk to Coach Button (Primary CTA)
                    Button(action: { showCoachConversation = true }) {
                        HStack {
                            Image(systemName: "waveform.circle.fill")
                                .font(.title2)
                            Text("Talk to Coach")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                        .background(Constants.UI.Colors.primary.gradient)
                        .foregroundColor(.white)
                        .cornerRadius(Constants.UI.cornerRadius)
                        .shadow(color: Constants.UI.Colors.primary.opacity(0.3), radius: 10, y: 5)
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, Constants.UI.horizontalPadding)
            }
        }
    }

    private var noGoalView: some View {
        VStack(spacing: 20) {
            Image(systemName: "target")
                .font(.system(size: 80))
                .foregroundColor(.secondary)

            Text("No Active Goal")
                .font(.title)
                .fontWeight(.bold)

            Text("Set a goal to get started with your coach")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button(action: { showGoalSetup = true }) {
                Text("Set Your Goal")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: Constants.UI.buttonHeight)
                    .background(Constants.UI.Colors.primary)
                    .foregroundColor(.white)
                    .cornerRadius(Constants.UI.cornerRadius)
            }
            .padding(.horizontal, Constants.UI.horizontalPadding)
        }
        .padding()
    }

    private var todayProgressCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Today's Progress")
                    .font(.headline)
                Spacer()
                if let progress = dataService.getTodayProgress() {
                    Image(systemName: progress.completed ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(progress.completed ? .green : .secondary)
                        .font(.title2)
                }
            }

            if let progress = dataService.getTodayProgress(), progress.completed {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Completed!")
                        .fontWeight(.medium)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
            } else {
                HStack(spacing: 12) {
                    Button(action: { dataService.recordDailyProgress(completed: true) }) {
                        Text("Mark Complete")
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Constants.UI.Colors.success)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }

                    Button(action: { dataService.recordDailyProgress(completed: false) }) {
                        Text("Skip Today")
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Constants.UI.Colors.secondaryBackground)
                            .foregroundColor(.primary)
                            .cornerRadius(12)
                    }
                }
            }
        }
        .padding()
        .background(Constants.UI.Colors.secondaryBackground)
        .cornerRadius(Constants.UI.cornerRadius)
    }

    private func statCard(title: String, value: String, subtitle: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
            }

            Text(value)
                .font(.system(size: 36, weight: .bold))

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Constants.UI.Colors.secondaryBackground)
        .cornerRadius(Constants.UI.cornerRadius)
    }
}

#Preview {
    HomeView()
        .environmentObject(DataService(
            modelContainer: try! ModelContainer(for: User.self, Goal.self, DailyProgress.self, ConversationSession.self)
        ))
}
