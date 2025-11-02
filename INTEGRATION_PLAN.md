# Running Coach App - Complete Integration Plan

**Last Updated:** November 2, 2025
**Status:** Step-by-step implementation roadmap

---

## 📊 CURRENT STATE ANALYSIS

### ✅ **WHAT'S ALREADY BUILT (Solid Foundation)**

Your app has a **strong MVP base** with:

1. **Full Data Architecture** (SwiftData) ✅ **PHASE 1 COMPLETED**
   - User, Goal, DailyProgress, ConversationSession models
   - Proper relationships and cascade rules
   - Streak calculation and weekly tracking
   - **NEW:** RunningSchedule, ScheduledRun, RunSession, CoachTask, Milestone models
   - **ENHANCED:** Goal model with running-specific fields
   - **ENHANCED:** ConversationSession with type tracking

2. **Complete UI Flow**
   - WelcomeView → GoalSetupView → HomeView
   - CoachConversationView for voice
   - Professional design with proper iOS conventions

3. **In-App Voice Ready (80% done)**
   - ElevenLabsService structure built
   - SDK integrated in project
   - Conversation context passing logic
   - Just needs final activation

4. **Notifications Working**
   - Daily check-in scheduling (8 PM)
   - Action buttons (Talk/Skip)
   - Permission handling

5. **Goal Tracking**
   - Daily completion marking
   - Streak calculations
   - Progress visualization

---

## 🔍 GAP ANALYSIS: What's Missing

### 🚧 **MVP Features NOT Yet Built**

| MVP Requirement | Current Status | Gap |
|----------------|----------------|-----|
| **Data Models** | ✅ **COMPLETED (Phase 1)** | All models created and integrated |
| **Running-Specific Goal Setup** | Generic goal setup exists | Need running-specific questions (fitness level, frequency, obstacles) |
| **Training Schedule System** | ✅ Models exist | Need: Calendar view, run definitions, UI |
| **Pre-Run Phone Calls (15 min before)** | ❌ Doesn't exist | Need: Twilio integration, call scheduling, context injection |
| **Post-Run Check-In** | Basic conversation exists | Need: Structured debrief questions, difficulty rating |
| **Adaptive Schedule Logic** | ✅ Data structures ready | Need: Rules engine, feedback analysis, plan modifications |
| **Task Creation from Obstacles** | ✅ Model exists | Need: AI-triggered task generation, UI |
| **Weekly Planning Calls** | ❌ Doesn't exist | Need: Scheduling logic, weekly summary |

---

## 🎯 IMPLEMENTATION PHASES

### **PHASE 1: Foundation Enhancements (Data Models)** ✅ **COMPLETED**
**Goal:** Add running-specific data structures
**Status:** ✅ Build succeeded, all models integrated
**Completed:** November 2, 2025

#### **What was built:**

1. **New Models:** ✅
   - `RunningSchedule` - Weekly training plan with runs
   - `ScheduledRun` - Individual run details (distance, time, type, status)
   - `RunSession` - Completed run record (difficulty, pain, notes)
   - `CoachTask` - AI-generated tasks for obstacles (renamed from Task to avoid Swift conflict)
   - `Milestone` - Training milestones (5km, 10km, etc.)

2. **Enhancements to Existing Models:** ✅
   - Updated `Goal` model with:
     - Running-specific fields (fitness level, weekly frequency, target race)
     - Training schedule relationship
     - Computed properties (totalRunsCompleted, totalDistanceRun, etc.)
   - Updated `ConversationSession` to track:
     - Conversation type (pre-run, post-run, planning, motivation)
     - Run ID if linked to a specific run
     - Sentiment and key topics

#### **Files created/modified:** ✅
- `Models/Goal.swift` (enhanced)
- `Models/ConversationSession.swift` (enhanced)
- `Models/RunningSchedule.swift` (new)
- `Models/ScheduledRun.swift` (new)
- `Models/RunSession.swift` (new)
- `Models/Task.swift` (new - CoachTask class)
- `Models/Milestone.swift` (new)
- `App/MotivationalCoachApp.swift` (updated ModelContainer)

**See:** `/Phase_Implementations/PHASE_1_COMPLETED.md` for full details

#### **Data Structure Example:**
```swift
@Model final class RunningSchedule {
    @Attribute(.unique) var id: UUID
    var startDate: Date
    var goalId: UUID
    var weeklyFrequency: Int // 2x, 3x, 4x per week
    var fitnessLevel: String // "beginner", "intermediate", "advanced"
    @Relationship(deleteRule: .cascade) var scheduledRuns: [ScheduledRun]?
}

@Model final class ScheduledRun {
    @Attribute(.unique) var id: UUID
    var scheduledDateTime: Date
    var distance: Double // kilometers
    var runType: String // "easy", "tempo", "long", "recovery"
    var status: String // "scheduled", "completed", "missed", "rescheduled"
    var preRunCallScheduled: Bool
    var preRunCallTime: Date?
    @Relationship var runSession: RunSession?
}

@Model final class RunSession {
    @Attribute(.unique) var id: UUID
    var scheduledRunId: UUID
    var completedDate: Date
    var actualDistance: Double?
    var duration: Int? // minutes
    var difficultyRating: Int? // 1-10
    var painReported: Bool
    var painLocation: String?
    var painDescription: String?
    var energyLevel: String? // "low", "medium", "high"
    var notes: String?
    var weatherConditions: String?
}

@Model final class Task {
    @Attribute(.unique) var id: UUID
    var goalId: UUID
    var title: String
    var description: String?
    var dueDate: Date?
    var isCompleted: Bool
    var createdByCoach: Bool
    var createdDuringConversationId: UUID?
    var relatedToRunId: UUID?
    var category: String // "gear", "nutrition", "hydration", "scheduling", "recovery"
    var priority: String // "high", "medium", "low"
}

@Model final class Milestone {
    @Attribute(.unique) var id: UUID
    var goalId: UUID
    var title: String // "First 5km", "First 10km", "Half Marathon"
    var targetDistance: Double?
    var targetDate: Date?
    var isCompleted: Bool
    var completedDate: Date?
    var celebrationCallScheduled: Bool
}
```

---

### **PHASE 2: ElevenLabs Voice Activation**
**Goal:** Get in-app voice conversations working

#### **What needs to be done:**

1. **Activate ElevenLabsService:**
   - Uncomment SDK code in `Services/ElevenLabsService.swift` (lines 17-72)
   - Test connection flow
   - Verify context passing to agent

2. **Update Info.plist:**
   - Add microphone permissions:
   ```xml
   <key>NSMicrophoneUsageDescription</key>
   <string>We need access to your microphone to have voice conversations with your running coach</string>

   <key>NSSpeechRecognitionUsageDescription</key>
   <string>We use speech recognition to understand your voice during coaching sessions</string>
   ```

3. **Test Voice Flow:**
   - Open app → Talk to Coach button
   - Verify microphone access prompt
   - Test conversation quality
   - Confirm context is passed correctly (goal, streak, progress)

#### **Files to modify:**
- `Services/ElevenLabsService.swift` (uncomment lines 17-72)
- `Info.plist`

#### **Testing Checklist:**
- [ ] Microphone permission requested
- [ ] Connection establishes successfully
- [ ] Coach knows user's name and goal
- [ ] User can speak and coach responds
- [ ] Coach can speak and user can hear
- [ ] Conversation ends cleanly
- [ ] Transcript is saved to ConversationSession

---

### **PHASE 3: Running-Specific Goal Setup**
**Goal:** Transform generic goal setup into running coach onboarding

#### **What needs to be changed:**

1. **Update GoalSetupView questions:**

   **Step 1:** "What's your running goal?"
   - Text input with examples: "Run a half marathon", "Run 5km without stopping", "Get back into running"
   - Voice input option available

   **Step 2:** "When do you want to achieve it?"
   - Date picker (or "No specific deadline" option)
   - Calculate weeks/months available

   **Step 3:** "How many times per week can you run?"
   - Multiple choice: 2x, 3x, 4x, 5x per week
   - Explain commitment level

   **Step 4:** "What's your current fitness level?"
   - Multiple choice:
     - "Complete beginner - haven't run in years"
     - "Beginner - run occasionally"
     - "Intermediate - run regularly but want structure"
     - "Advanced - experienced runner"

   **Step 5:** "What are your biggest obstacles?"
   - Multiple selection:
     - Motivation
     - Time in mornings
     - Time in evenings
     - Weather
     - Previous injuries
     - Getting bored
     - Other (text input)

2. **Generate Initial Training Schedule:**
   - After goal setup, call schedule generation service
   - Based on: frequency + fitness level + goal date + available days
   - Create first 4 weeks of runs
   - Store in `RunningSchedule` and `ScheduledRun` models

3. **Schedule Generation Logic:**
   ```swift
   func generateInitialSchedule(
       goal: Goal,
       frequency: Int,
       fitnessLevel: String,
       targetDate: Date?
   ) -> RunningSchedule {
       // Logic for beginners (2x per week example):
       // Week 1: 3km easy, 4km easy
       // Week 2: 4km easy, 5km easy
       // Week 3: 4km easy, 6km easy
       // Week 4: 5km easy, 6km easy

       // Increase by 10-15% per week
       // Always start conservative
   }
   ```

#### **Files to modify:**
- `Views/Onboarding/GoalSetupView.swift`
- `Services/DataService.swift` (add schedule generation)
- `Services/ScheduleGenerationService.swift` (new)

#### **Testing Checklist:**
- [ ] All 5 questions display correctly
- [ ] Validation works for each step
- [ ] Schedule generates based on inputs
- [ ] 4 weeks of runs created in database
- [ ] User can see schedule after setup

---

### **PHASE 4: Training Schedule UI**
**Goal:** Show upcoming runs in a calendar/list view

#### **What needs to be built:**

1. **New View: TrainingScheduleView**
   - Weekly calendar showing scheduled runs
   - Each run card shows:
     - Day of week & date
     - Time
     - Distance
     - Type (easy/tempo/long run)
     - Status (scheduled/completed/missed)
   - Tap run → RunDetailView
   - Swipe actions: Reschedule, Skip, Mark Complete

2. **Update HomeView:**
   - Add "Next Run" card showing:
     - Date & time
     - Countdown ("in 2 days" or "tomorrow at 8 AM")
     - Distance & type
     - "View Full Schedule" button
   - Quick actions:
     - "Mark Complete" (if today)
     - "Talk to Coach About This Run"

3. **Run Detail View:**
   - Full run details (distance, pace guidance, type)
   - Weather forecast for scheduled time (optional - requires weather API)
   - Preparation tips (hydration, warm-up)
   - Actions:
     - "Talk to Coach About This Run"
     - "Mark Complete"
     - "Skip This Run"
     - "Reschedule"

#### **New files to create:**
- `Views/Training/TrainingScheduleView.swift`
- `Views/Training/RunDetailView.swift`
- `Views/Training/Components/RunCard.swift`

#### **UI Wireframe:**
```
┌─────────────────────────────────┐
│ Home View                       │
├─────────────────────────────────┤
│                                 │
│ ┌─────────────────────────────┐ │
│ │ NEXT RUN                    │ │
│ │ Tomorrow at 8:00 AM         │ │
│ │ 5km Easy Run                │ │
│ │ [Talk to Coach] [Complete]  │ │
│ └─────────────────────────────┘ │
│                                 │
│ ┌─────────────────────────────┐ │
│ │ This Week                   │ │
│ │ ● Tuesday - 5km ✓           │ │
│ │ ● Thursday - 4km (tomorrow) │ │
│ │ ○ Sunday - 8km              │ │
│ └─────────────────────────────┘ │
│                                 │
│ [View Full Schedule]            │
└─────────────────────────────────┘
```

#### **Testing Checklist:**
- [ ] Schedule view shows all upcoming runs
- [ ] Run cards display correct information
- [ ] Tap run opens detail view
- [ ] Mark complete updates status
- [ ] Next run appears on HomeView
- [ ] Navigation flows smoothly

---

### **PHASE 5: Post-Run Check-In (In-App)**
**Goal:** Structured feedback after completing runs

#### **What needs to be built:**

1. **Post-Run Feedback Flow:**
   - When user taps "Mark Complete" → trigger check-in
   - Two options:
     - **Voice check-in** (recommended) - Talk to coach
     - **Quick form** - Rate and notes

2. **Voice Check-In Questions (Coach asks):**
   ```
   1. "How did it feel overall? Easy, moderate, or hard?"
   2. "Rate the difficulty from 1 to 10"
   3. "Any pain or discomfort anywhere?"
   4. "How's your energy level now?"
   5. "Did you have enough water?"
   6. "Anything that made it harder than expected?"
   ```

3. **Quick Form (Text option):**
   - Difficulty slider (1-10)
   - Pain toggle (Yes/No) → if yes, location picker
   - Energy level (Low/Medium/High)
   - Optional notes text field
   - Submit button

4. **Update CoachConversationView:**
   - Detect if conversation is post-run check-in
   - Pass run context to ElevenLabs:
     ```json
     {
       "conversation_type": "post_run_checkin",
       "run_details": {
         "distance": 5.0,
         "scheduled_time": "8:00 AM",
         "run_type": "easy"
       },
       "questions_to_ask": [
         "How did it feel?",
         "Rate difficulty 1-10",
         "Any pain?"
       ]
     }
     ```
   - Guide conversation with structured questions
   - Extract answers from conversation
   - Save to `RunSession` model

5. **Feedback Analysis & Storage:**
   - Parse conversation/form data
   - Extract:
     - Difficulty rating (1-10)
     - Pain reports (boolean + location)
     - Sentiment (positive/neutral/struggling)
     - External obstacles mentioned
   - Store in `RunSession`
   - Flag for adaptive scheduling analysis

#### **Files to modify:**
- `Views/Coach/CoachConversationView.swift`
- `Views/Training/PostRunCheckInView.swift` (new)
- `Services/DataService.swift` (add run session recording)
- `Services/ElevenLabsService.swift` (pass run context)
- `Services/FeedbackAnalysisService.swift` (new)

#### **Testing Checklist:**
- [ ] Mark complete triggers check-in
- [ ] Voice check-in asks structured questions
- [ ] Quick form captures all data
- [ ] Data saves to RunSession correctly
- [ ] Coach remembers feedback in next conversation
- [ ] Difficulty trends visible over time

---

### **PHASE 6: Adaptive Schedule Logic**
**Goal:** AI coach adjusts plan based on feedback

#### **What needs to be built:**

1. **Adaptation Rules Engine:**
   - Analyze last 2-4 runs for patterns
   - Detect conditions (see rules below)
   - Apply adjustment rules automatically
   - Generate explanation for user

2. **Adaptation Rules (from MVP spec):**

   **RULE 1: Consistent "Too Easy" → Increase Difficulty**
   - **Trigger:** 2+ consecutive runs with difficulty < 4/10
   - **Action:**
     - Increase distance by 10-15%
     - Add intensity variation (tempo run)
     - Suggest increasing frequency

   **RULE 2: Consistent "Too Hard" → Decrease Difficulty**
   - **Trigger:** 2+ consecutive runs with difficulty > 8/10
   - **Action:**
     - Decrease distance by 20-30%
     - Add extra rest day
     - Keep all runs at easy intensity

   **RULE 3: Pain Reported → Immediate Rest + Modification**
   - **Trigger:** Any pain during/after run
   - **Action:**
     - Next run becomes REST DAY
     - Add 1-2 extra rest days
     - Decrease following week by 30-40%
     - Create recovery tasks (stretching, ice)

   **RULE 4: Excuse Mentioned → Task Creation**
   - **Trigger:** Obstacle preventing run (weather, gear, time)
   - **Action:**
     - Reschedule missed run
     - Create specific task to solve problem
     - Set deadline for task

   **RULE 5: Consistent Completion → Progressive Overload**
   - **Trigger:** 4+ weeks, 80%+ completion, difficulty 5-7/10
   - **Action:**
     - Increase weekly volume by 10%
     - Add variation (tempo, hills, long runs)
     - Build toward goal more aggressively

   **RULE 6: Multiple Misses → Intervention**
   - **Trigger:** 3+ missed runs in 2 weeks
   - **Action:**
     - Schedule intervention call
     - Reassess commitment and schedule
     - Potentially reduce frequency
     - Address root cause

3. **Schedule Modification Logic:**
   ```swift
   func applyAdaptation(
       rule: AdaptationRule,
       currentSchedule: RunningSchedule
   ) -> RunningSchedule {
       switch rule {
       case .tooEasy:
           // Increase distances by 10-15%
           // Add tempo run
           // Suggest frequency increase
       case .tooHard:
           // Decrease distances by 20-30%
           // Add rest day
           // Remove intensity
       case .painReported:
           // Cancel next run → REST
           // Reduce following week 30-40%
           // Create recovery tasks
       // ... other rules
       }
   }
   ```

4. **User Notification:**
   - In-app notification: "Your coach adjusted your schedule"
   - Show adjustment card in HomeView:
     ```
     ┌─────────────────────────────────┐
     │ 🎯 SCHEDULE UPDATED             │
     │                                 │
     │ You crushed last week!          │
     │ I'm increasing your distances   │
     │ by 10% and adding a tempo run.  │
     │                                 │
     │ [View Changes] [Talk to Coach]  │
     └─────────────────────────────────┘
     ```
   - Optional: Push notification

5. **Adjustment History:**
   - Track all schedule changes
   - Show reasoning
   - Allow user to undo if needed

#### **Files to create:**
- `Services/AdaptiveSchedulingService.swift`
- `Models/ScheduleAdjustment.swift`
- `Views/Training/ScheduleAdjustmentView.swift`

#### **Testing Checklist:**
- [ ] Rules trigger correctly based on feedback
- [ ] Schedule updates automatically
- [ ] User sees notification of changes
- [ ] Reasoning is clear and helpful
- [ ] Changes are appropriate (not too aggressive)
- [ ] User can undo unwanted changes

---

### **PHASE 7: Task Creation from Obstacles**
**Goal:** AI creates actionable tasks when user mentions obstacles

#### **What needs to be built:**

1. **Task Detection in Conversations:**
   - Parse conversation transcripts for obstacle keywords
   - Categories:
     - **Gear:** "no rain jacket", "shoes worn out", "need hydration pack"
     - **Nutrition:** "forgot to eat", "got hungry", "need energy gels"
     - **Hydration:** "forgot water", "got dehydrated", "need water bottle"
     - **Scheduling:** "no time", "too early", "conflicting meeting"
     - **Recovery:** "sore", "tired", "need rest"
   - Generate task with:
     - Title (actionable: "Buy rain jacket")
     - Description (why: "You mentioned getting soaked last run")
     - Due date (reasonable: 3-7 days)
     - Priority (high/medium/low)

2. **Task Generation Service:**
   ```swift
   func generateTaskFromObstacle(
       obstacle: String,
       context: RunContext
   ) -> Task? {
       // Example:
       // Input: "It was raining and I don't have rain gear"
       // Output: Task(
       //   title: "Buy waterproof running jacket",
       //   description: "You mentioned getting soaked during your last run",
       //   dueDate: Date().addingDays(5),
       //   priority: "medium",
       //   category: "gear"
       // )
   }
   ```

3. **Task UI:**

   **HomeView - Tasks Section:**
   ```
   ┌─────────────────────────────────┐
   │ 📋 TASKS FROM YOUR COACH        │
   │                                 │
   │ ☐ Buy waterproof jacket         │
   │   Due in 3 days                 │
   │                                 │
   │ ☐ Set water reminder            │
   │   Due today                     │
   │                                 │
   │ [View All Tasks]                │
   └─────────────────────────────────┘
   ```

   **TaskListView:**
   - Filter: All / Active / Completed
   - Group by: Priority / Category / Due Date
   - Swipe actions: Complete / Dismiss / Snooze
   - Tap task → Detail view

4. **Task Follow-Up:**
   - Coach asks about tasks in next check-in:
     - "Did you get that rain jacket?"
     - "How's the water reminder working?"
   - If task not completed:
     - "Still need help with [task]?"
     - Offer to adjust or remove

5. **Manual Task Creation:**
   - User can create tasks themselves
   - "Add Task" button
   - Coach-created tasks marked differently

#### **Files to create:**
- `Views/Tasks/TaskListView.swift`
- `Views/Tasks/TaskDetailView.swift`
- `Services/TaskGenerationService.swift`

#### **Files to modify:**
- `Views/Home/HomeView.swift` (add tasks section)
- `Services/ElevenLabsService.swift` (task detection in conversations)

#### **Testing Checklist:**
- [ ] Tasks generated from mentioned obstacles
- [ ] Tasks appear in HomeView
- [ ] Can mark tasks complete
- [ ] Coach asks about tasks in next call
- [ ] Can manually create tasks
- [ ] Tasks have appropriate due dates

---

### **PHASE 8: Twilio Phone Call Integration**
**Goal:** Coach calls user at scheduled times (pre-run, post-run, weekly planning)

⚠️ **NOTE:** This is the most complex phase. Requires backend infrastructure.

#### **Architecture:**
```
iOS App → Backend Server → Twilio API → ElevenLabs Agent → User's Phone
   ↑                            ↓
   └──────── Status Updates ────┘
```

#### **What needs to be built:**

1. **Backend Service (Node.js / Python / etc.)**

   **Required Endpoints:**

   **A. Schedule Call Request**
   ```
   POST /api/schedule-call
   Body: {
     "user_id": "uuid",
     "phone_number": "+1234567890",
     "scheduled_time": "2025-11-03T07:45:00Z",
     "call_type": "pre_run",
     "context": {
       "user_name": "Miguel",
       "next_run": {
         "distance": 5.0,
         "type": "easy",
         "scheduled_time": "08:00"
       },
       "goal": "Run half marathon",
       "current_streak": 5
     }
   }
   ```

   **B. Twilio Webhook (Call Initiated)**
   ```
   POST /api/twilio/call-initiated
   - Receives call from Twilio
   - Connects to ElevenLabs agent
   - Injects context
   - Routes audio stream
   ```

   **C. Call Status Update**
   ```
   POST /api/twilio/call-status
   - Receives status: answered, missed, completed, failed
   - Sends update back to iOS app
   - Stores call record
   ```

   **D. Get Call History**
   ```
   GET /api/calls?user_id=uuid
   - Returns call records with transcripts
   ```

2. **Twilio Integration:**

   **Setup:**
   - Twilio account + phone number
   - Configure webhooks to backend
   - Set up TwiML for voice routing

   **Outbound Call Flow:**
   ```javascript
   // Backend (Node.js example)
   const twilio = require('twilio');
   const client = twilio(accountSid, authToken);

   async function initiatePreRunCall(userId, phoneNumber, context) {
     const call = await client.calls.create({
       to: phoneNumber,
       from: twilioPhoneNumber,
       url: `${backendUrl}/api/twilio/connect-to-agent`,
       statusCallback: `${backendUrl}/api/twilio/call-status`,
       statusCallbackEvent: ['initiated', 'answered', 'completed']
     });

     return call.sid;
   }
   ```

3. **ElevenLabs + Twilio Connection:**

   **Connect Call to Agent:**
   ```javascript
   app.post('/api/twilio/connect-to-agent', (req, res) => {
     const context = getContextForUser(req.userId);

     // Generate TwiML to connect to ElevenLabs
     const twiml = new twilio.twiml.VoiceResponse();
     twiml.connect().stream({
       url: `wss://elevenlabs.io/v1/convai/conversation?agent_id=${agentId}`,
       parameters: {
         context: JSON.stringify(context)
       }
     });

     res.type('text/xml');
     res.send(twiml.toString());
   });
   ```

4. **iOS Changes:**

   **New Service: BackendAPIService**
   ```swift
   class BackendAPIService {
       let baseURL = "https://your-backend.com/api"

       func scheduleCall(
           phoneNumber: String,
           scheduledTime: Date,
           callType: CallType,
           context: CallContext
       ) async throws -> String {
           // POST to /api/schedule-call
           // Returns call ID
       }

       func getCallStatus(callId: String) async throws -> CallStatus {
           // GET /api/calls/{callId}
       }

       func getCallHistory() async throws -> [CallRecord] {
           // GET /api/calls
       }
   }
   ```

   **New Service: CallSchedulingService**
   ```swift
   class CallSchedulingService: ObservableObject {
       @Published var scheduledCalls: [ScheduledCall] = []

       func schedulePreRunCall(for run: ScheduledRun) async {
           // Schedule call 15 min before run
           let callTime = run.scheduledDateTime.addingTimeInterval(-15 * 60)

           let context = CallContext(
               userName: currentUser.name,
               callType: .preRun,
               runDetails: RunDetails(
                   distance: run.distance,
                   type: run.runType,
                   scheduledTime: run.scheduledDateTime
               ),
               goal: activeGoal.goalText,
               currentStreak: activeGoal.currentStreak
           )

           let callId = try await backendAPI.scheduleCall(
               phoneNumber: currentUser.phoneNumber,
               scheduledTime: callTime,
               callType: .preRun,
               context: context
           )

           // Store locally
           scheduledCalls.append(ScheduledCall(id: callId, time: callTime))
       }

       func handleMissedCall(callId: String) {
           // Send notification
           // Offer to reschedule
       }
   }
   ```

5. **Call Types & Scheduling:**

   **Pre-Run Call:**
   - Scheduled: 15 minutes before run
   - Duration: 2-3 minutes
   - Purpose: Check-in, motivation, adjust if needed

   **Post-Run Call (Optional):**
   - Triggered: When run marked complete
   - Alternative: In-app voice (user choice)

   **Weekly Planning Call:**
   - Scheduled: Sunday evening or Monday morning
   - Duration: 5-10 minutes
   - Purpose: Review last week, plan next week, adjust schedule

6. **User Settings:**
   - Enable/disable phone calls (vs in-app only)
   - Phone number input
   - Call preference times
   - Do Not Disturb hours

#### **Backend Technology Stack Options:**

**Option A: Node.js + Express**
```
- Fast development
- Great Twilio SDK
- Easy WebSocket handling
- Deploy: Heroku, Railway, Render
```

**Option B: Python + Flask/FastAPI**
```
- Clean async support
- Twilio SDK available
- Deploy: Railway, Render, Fly.io
```

**Option C: Serverless (AWS Lambda + API Gateway)**
```
- Auto-scaling
- Pay per use
- More complex setup
- Higher latency
```

#### **Recommended Backend Structure:**
```
backend/
├── src/
│   ├── routes/
│   │   ├── calls.js         # Call scheduling endpoints
│   │   ├── twilio.js        # Twilio webhooks
│   │   └── users.js         # User management
│   ├── services/
│   │   ├── twilioService.js # Twilio integration
│   │   ├── elevenLabsService.js # ElevenLabs integration
│   │   └── schedulerService.js  # Call scheduling logic
│   ├── models/
│   │   ├── User.js
│   │   ├── Call.js
│   │   └── RunSchedule.js
│   └── index.js             # Express app
├── package.json
└── .env                     # API keys
```

#### **New iOS Files:**
- `Services/BackendAPIService.swift`
- `Services/CallSchedulingService.swift`
- `Models/CallRecord.swift`
- `Models/CallContext.swift`
- `Views/Settings/PhoneSettingsView.swift`

#### **Testing Checklist:**
- [ ] Backend deploys successfully
- [ ] Twilio account configured
- [ ] Test call initiates from iOS
- [ ] Call connects to user's phone
- [ ] ElevenLabs agent responds on call
- [ ] Context passed correctly
- [ ] Call status updates iOS app
- [ ] Missed call handling works
- [ ] Call history displays correctly

---

## 📅 RECOMMENDED IMPLEMENTATION ORDER

### **WEEK 1: Foundation & Voice**

**~~Step 1: Foundation Models~~** ✅ **COMPLETED**
- **Phase:** 1
- **Status:** ✅ Done (November 2, 2025)
- **Outcome:** All data models created and integrated

**Step 2: Activate ElevenLabs Voice** ⭐ *START HERE*
- **Phase:** 2
- **Effort:** 1-2 hours
- **Why next:** Already 80% built, immediate testing capability
- **Outcome:** Working voice conversations in-app

**Step 3: Running-Specific Goal Setup**
- **Phase:** 3
- **Effort:** 4-6 hours
- **Why next:** Transforms generic coach into running coach
- **Outcome:** Running-specific onboarding flow

---

### **WEEK 2: Schedule UI & Initial Testing**

**Step 4: Training Schedule UI**
- **Phase:** 4
- **Effort:** 6-8 hours
- **Why next:** Visualize generated schedules
- **Outcome:** Calendar view, next run card

**Step 5: Schedule Generation Logic**
- **Phase:** 3 (Part 2)
- **Effort:** 4-6 hours
- **Why next:** Auto-generate 4-week plans
- **Outcome:** Initial training plans created

**Testing:** Use app yourself for runs this week

---

### **WEEK 3: Feedback & Adaptation**

**Step 6: Post-Run Check-In**
- **Phase:** 5
- **Effort:** 6-8 hours
- **Why next:** Collect feedback for adaptation
- **Outcome:** Structured post-run conversations

**Step 7: Adaptive Scheduling Logic**
- **Phase:** 6
- **Effort:** 8-10 hours
- **Why next:** The "magic" of adaptive coaching
- **Outcome:** Schedule adjusts based on feedback

**Testing:** Complete 3-4 runs, verify adaptations

---

### **WEEK 4: Tasks & Polish**

**Step 8: Task System**
- **Phase:** 7
- **Effort:** 6-8 hours
- **Why next:** Handle obstacles proactively
- **Outcome:** AI-generated tasks from conversations

**Step 9: Polish & Testing**
- **Effort:** 4-6 hours
- **What:** Bug fixes, UI improvements, testing
- **Outcome:** Solid in-app MVP

---

### **MONTH 2+: Phone Calls (After Validation)**

**Step 10: Backend Development**
- **Phase:** 8
- **Effort:** 20-30 hours
- **Why wait:** Validate concept with in-app first
- **Outcome:** Backend server with Twilio integration

**Step 11: Phone Call Integration**
- **Phase:** 8
- **Effort:** 10-15 hours
- **Why last:** Most complex, requires backend
- **Outcome:** Pre-run phone calls working

---

## ✅ VALIDATION STRATEGY

### **Before Building Phone Calls:**

1. **Self-Test (2-4 weeks):**
   - Use app yourself for training
   - Track metrics:
     - Do you complete more runs with voice check-ins?
     - Does adaptive scheduling feel right?
     - Do you feel accountable to the coach?
   - Document what works and what doesn't

2. **Beta Testing (5-10 users, 2-4 weeks):**
   - Friends who run
   - Local running group members
   - Collect feedback:
     - Is voice coaching helpful?
     - Does schedule adapt appropriately?
     - Would phone calls add value?
   - Measure:
     - Run completion rate
     - Retention (do they keep using it?)
     - Satisfaction scores

3. **Decide on Phone Calls:**
   - If in-app voice validates well → build phone system
   - If lukewarm response → iterate on in-app first
   - Validate the expensive infrastructure is worth it

### **Success Metrics:**

**In-App MVP Success:**
- ✅ Users complete 75%+ of scheduled runs
- ✅ Users use voice check-ins regularly
- ✅ Schedule adapts appropriately (not too hard/easy)
- ✅ Users report feeling accountable
- ✅ Tasks help solve obstacles
- ✅ Users want to keep using it

**When these hit → proceed to phone calls**

---

## 🚀 QUICK START: What to Do Today

### **Immediate Action Plan:**

1. **Review this plan** - Understand the full scope ✅ (you're here!)

2. **Start with Phase 2** - Activate ElevenLabs voice
   - Effort: 1-2 hours
   - High impact, low complexity
   - Immediate testing capability

3. **Test voice conversations** - Talk to your coach
   - Verify it works end-to-end
   - Get comfortable with voice UI
   - Identify any issues

4. **Move to Phase 3** - Running-specific goal setup
   - Transform generic onboarding
   - Add running questions
   - Foundation for everything else

### **Daily Progress Tracking:**

Update this file with checkboxes as you complete each phase:

- [ ] Phase 1: Data Models
- [ ] Phase 2: ElevenLabs Voice Activation ⭐ START HERE
- [ ] Phase 3: Running-Specific Goal Setup
- [ ] Phase 4: Training Schedule UI
- [ ] Phase 5: Post-Run Check-In
- [ ] Phase 6: Adaptive Schedule Logic
- [ ] Phase 7: Task Creation System
- [ ] Phase 8: Phone Call Integration (after validation)

---

## 📚 REFERENCE DOCUMENTS

- **Strategic Plan:** `/plan.md` - Overall vision and multi-niche strategy
- **MVP Specification:** `/MVP_SPECIFICATION.md` - Detailed running coach features
- **This Plan:** `/INTEGRATION_PLAN.md` - Step-by-step implementation roadmap

---

## 💪 REMEMBER

**You're building a REAL coach, not just an app.**

The goal isn't perfect code or beautiful UI (though both matter). The goal is:
- Users complete more runs than without the coach
- Users feel accountable to someone (even if it's AI)
- The schedule adapts like a human coach would
- Obstacles get solved, not ignored

**Start small. Validate quickly. Iterate constantly.**

Build the in-app voice version first. Use it yourself. Prove it works. Then add the phone calls.

**Let's build it.** 💪

---

*Last Updated: November 2, 2025*
