# Running Coach MVP - Complete Specification

## 🎯 DUAL CONVERSATION MODES

### **1. In-App Voice Conversations**
**Status:** Already working in iOS app
- User taps "Talk to Coach" button
- Real-time voice conversation with ElevenLabs agent
- Used for: Ad-hoc conversations, immediate motivation, questions
- Available anytime user wants to talk

### **2. Scheduled Phone Calls**
**Status:** To be implemented
- Coach calls user at scheduled times (pre-run, post-run, weekly planning)
- Used for: Proactive accountability, check-ins, scheduled sessions
- Can't be ignored like app notifications

**How They Work Together:**
- **In-app voice** = User initiates when THEY need coach
- **Phone calls** = Coach initiates when USER needs accountability

---

## 🏃 RUNNING COACH MVP - CORE FEATURES

### **Feature 1: Goal Setup (Voice-Based)**

**Onboarding Conversation:**
```
Coach asks during initial setup:

1. "What's your running goal?"
   Examples: "Run a half marathon", "Run 5km without stopping", "Get back into running"

2. "When do you want to achieve it?"
   Examples: "In 3 months", "By end of year", "No specific deadline"

3. "How many times per week can you commit to running?"
   Examples: "2 times", "3 times", "4-5 times"

4. "What's your current fitness level?"
   Examples: "Haven't run in years", "Run occasionally", "Run regularly but want structure"

5. "What are your biggest obstacles?"
   Examples: "Motivation", "Time in the mornings", "Weather", "Getting injured"
```

**Output:**
- User's goal is set
- Initial training schedule generated
- First runs scheduled based on user's availability

---

### **Feature 2: Training Schedule Generation**

**Initial Schedule Logic:**

Based on user input, coach creates progressive schedule:
- Frequency: User's commitment (2x, 3x, 4x per week)
- Days and times: User chooses specific slots
- Progressive difficulty: Starts manageable, builds gradually
- Structure: distance, pace, run type (easy/tempo/long)

**Example Schedule - Beginner (2x per week):**
```
WEEK 1:
├── Tuesday 8:00 AM - 3km easy run
└── Friday 6:00 PM - 4km easy run

WEEK 2:
├── Tuesday 8:00 AM - 4km easy run
└── Friday 6:00 PM - 5km easy run

WEEK 3:
├── Tuesday 8:00 AM - 4km easy run
└── Friday 6:00 PM - 6km easy run

WEEK 4:
├── Tuesday 8:00 AM - 5km easy run
└── Friday 6:00 PM - 6km easy run
```

**Schedule Display in App:**
- Calendar view showing upcoming runs
- Each run shows: date, time, distance, type, difficulty
- Can tap to see details or talk to coach about it

---

### **Feature 3: Pre-Run Check-In (15 minutes before scheduled run)**

**Trigger:** 15 minutes before scheduled run time

**Method:** Phone call from coach

**Conversation Flow:**

```
📞 Coach calls at 7:45 AM for 8:00 AM run

Coach: "Hey [Name]! Your run is in 15 minutes. How are you feeling?"

USER MIGHT SAY:
- "Feeling great!"
- "Pretty tired today"
- "My knee is sore"
- "It's raining outside"
- "I'm running late, might skip"
- "Didn't sleep well"

COACH RESPONSES BASED ON INPUT:

If POSITIVE (feeling great):
→ "Awesome! Today's run is [distance] at an easy pace. 
   Weather is [temp] degrees, perfect conditions. 
   Grab your water and let's do this!"

If TIRED:
→ "I hear you. Let's make this an easier recovery run. 
   We'll cut [distance] to [reduced distance]. 
   Just get out there, light and easy. The consistency matters more. 
   Can you commit to that?"

If PAIN/INJURY:
→ "Okay, let's not push through pain. Take today as a rest day. 
   Let's talk about it after - might need to adjust your schedule. 
   Recovery is part of training. Sound good?"

If WEATHER EXCUSE:
→ "I get it. Weather sucks. Two options: 
   1) Dress for it and embrace the challenge, or 
   2) Hit the treadmill if you have access. 
   What's realistic for you right now?"

If TIME EXCUSE:
→ "I hear you. Can you do even 10 minutes? 
   Something is better than nothing. 
   Or should we reschedule for later today or tomorrow?"

COACH ALWAYS ENDS WITH:
- Specific action: "Grab your water bottle"
- Weather reminder: "It's [temp] degrees, dress accordingly"
- Mindset: "Today's goal is consistency, not speed"
- Commitment: "Text me when you're done" or "I'll check in after"
```

**What Happens in App:**
- If session adjusted (distance reduced, rescheduled), app updates automatically
- User sees modified plan
- Pre-run check-in marked as complete

---

### **Feature 4: Post-Run Check-In (After run completed)**

**Trigger:** User marks run as complete in app

**Method:** In-app voice conversation OR phone call (user choice)

**Conversation Flow:**

```
Coach: "How did it go? Tell me about the run."

QUESTIONS COACH ASKS:

1. "How did it feel overall? Easy, moderate, or hard?"
   
2. "Rate the difficulty from 1 to 10"
   (1 = could run forever, 10 = barely survived)

3. "Any pain or discomfort anywhere?"
   
4. "How's your energy level now?"
   
5. "Did you have enough water during the run?"
   
6. "Anything that made it harder than expected?"

USER MIGHT SAY:

SCENARIO 1 - Too Easy:
"It was really easy, I could have gone longer"
"Barely broke a sweat"
"Felt like a warm-up"

SCENARIO 2 - Just Right:
"Felt good, challenging but manageable"
"Perfect pace"
"Tired but in a good way"

SCENARIO 3 - Too Hard:
"Way harder than I expected"
"Had to stop and walk a few times"
"My legs were burning badly"
"Almost gave up"

SCENARIO 4 - Pain/Injury:
"My knee started hurting around kilometer 2"
"Shin pain on the right side"
"Lower back was tight"

SCENARIO 5 - External Issues:
"Forgot my water, got really thirsty"
"Started too fast and burned out"
"Didn't eat enough before"

COACH RESPONSES:

If TOO EASY:
→ "That's great feedback! Your body is ready for more. 
   I'm going to increase your next run a bit. 
   Let's keep building on this momentum!"

If JUST RIGHT:
→ "Perfect! That's exactly where we want you - 
   challenged but not destroyed. 
   We'll keep progressing at this pace."

If TOO HARD:
→ "Okay, we pushed too fast. That's my fault. 
   I'm backing off next week's intensity. 
   This is about sustainable progress, not burning out. 
   You still completed it though - that's mental toughness."

If PAIN:
→ "Let's not ignore that. Take an extra rest day. 
   I'm adjusting your schedule. 
   We'll also add some stretching and strengthening work. 
   Pain is your body talking - let's listen."

If EXTERNAL ISSUES:
→ "Good learning experience. 
   Let's solve this for next time: 
   [creates task like 'Set water reminder' or 'Pre-run nutrition plan']"

COACH ALWAYS ENDS WITH:
- Acknowledgment: "You showed up, that's what counts"
- Forward-looking: "Next run is [when], we're doing [distance]"
- Motivation: "Keep crushing it" or "Rest up, you earned it"
```

**What Happens in App:**
- All feedback saved to session record
- Coach analyzes feedback
- Future sessions may be adjusted based on patterns
- Tasks created if needed (addressed below)

---

## ⚡ ADAPTIVE SCHEDULE ADJUSTMENT (THE MAGIC)

This is the core intelligence that makes this a REAL coach, not just a static training plan.

### **Adaptation Rules**

#### **RULE 1: Consistent "Too Easy" → Increase Difficulty**

**Trigger:**
- User rates 2+ consecutive runs as difficulty < 4/10
- OR User says runs feel "too easy" multiple times
- AND User completes runs consistently

**Action:**
```
Next Week Adjustments:
- Increase distance by 10-15%
- Add intensity variation (one tempo run instead of all easy)
- Suggest increasing frequency (2x → 3x per week)

Coach explains:
"You crushed last week! Your body is ready for more. 
Let's bump up the distance and add a tempo run. 
How does 3x per week sound instead of 2x?"
```

**Example:**
```
Original Plan (Week 3):
├── Tuesday: 4km easy
└── Friday: 5km easy

User Feedback:
├── Tuesday: "Felt too easy, 3/10 difficulty"
└── Friday: "Also easy, could have done more"

Adapted Plan (Week 4):
├── Tuesday: 5km easy (increased 25%)
├── Thursday: 4km tempo (added frequency + intensity)
└── Saturday: 7km long run (added variation)
```

---

#### **RULE 2: Consistent "Too Hard" → Decrease Difficulty**

**Trigger:**
- User rates 2+ consecutive runs as difficulty > 8/10
- OR User struggles to complete runs (stops, walks, quits early)
- OR User expresses feeling overwhelmed

**Action:**
```
Next Week Adjustments:
- Decrease distance by 20-30%
- Add extra rest day
- Keep all runs at easy intensity (no tempo/speed work)
- Slow down progression

Coach explains:
"We jumped up too fast. Let's back off and let your body adapt. 
This is about building sustainable habits, not rushing. 
I've eased up next week's schedule."
```

**Example:**
```
Original Plan (Week 2):
├── Tuesday: 5km easy
└── Friday: 7km easy

User Feedback:
├── Tuesday: "Really hard, 8/10, legs were burning"
└── Friday: "Way too hard, had to walk twice, 9/10"

Adapted Plan (Week 3):
├── Tuesday: 3km easy (decreased 40%)
└── Saturday: 4km easy (decreased 43% + added rest days)
```

---

#### **RULE 3: Pain Reported → Immediate Rest + Modification**

**Trigger:**
- User reports ANY pain during or after run
- Especially: knee, shin, ankle, lower back

**Action:**
```
Immediate:
- Next scheduled run becomes REST DAY
- Add 1-2 extra rest days

Following Week:
- Decrease distance by 30-40%
- All runs at easy pace only
- Monitor pain for next 2-3 runs

Tasks Created:
- "Stretch routine for [affected area]"
- "Ice [body part] after each run"
- "Consider getting running shoe assessment"

Coach explains:
"Let's not push through pain. Your body needs recovery. 
I'm adding rest days and backing off intensity. 
We'll rebuild gradually and avoid injury."
```

**Example:**
```
Current Week:
├── Tuesday: 5km completed
└── Friday: 6km - "Knee pain started at km 3"

Adapted Next Week:
├── Monday: REST DAY (was Tuesday run)
├── Thursday: 3km easy, monitor knee (50% reduction)
└── Sunday: REST DAY (was Friday run)

Week After:
├── Tuesday: 4km easy IF knee feels good
└── Friday: 4km easy
```

---

#### **RULE 4: Excuse Mentioned → Task Creation + Problem Solving**

**Trigger:**
- User mentions obstacle preventing run
- Examples: weather, no gear, time constraints, forgot water

**Action:**
```
Immediate:
- Reschedule missed run (if applicable)
- Create specific task to solve the problem
- Set deadline for task

Coach explains:
"I hear you - [obstacle] made it hard. 
No problem, let's solve this. 
Here's what we're doing: [task]. 
And we'll move today's run to [new time]."
```

**Examples:**

**Excuse: "It was raining and I don't have rain gear"**
```
Tasks Created:
- "Buy waterproof running jacket" (Due: within 3 days)
- "Research best rain running gear"

Schedule Adjustment:
- Move today's run to tomorrow
- Add accountability: "Did you get the jacket?" in next check-in
```

**Excuse: "I forgot to drink water and got too thirsty"**
```
Tasks Created:
- "Set water bottle reminder (night before run)"
- "Create hydration routine"

Schedule Adjustment:
- None needed, completed the run

Next Pre-Run Check-In:
- Coach reminds: "Don't forget your water today!"
```

**Excuse: "Didn't have time this morning, work emergency"**
```
Schedule Adjustment:
- Offer evening run: "Can you run tonight instead?"
- OR move to next day: "Let's hit it tomorrow morning"

Discussion:
- "Do we need to adjust your running times permanently?"
- "Should we plan for backup time slots?"
```

---

#### **RULE 5: Consistent Completion → Progressive Overload**

**Trigger:**
- User completes 4+ weeks of runs consistently (80%+ completion rate)
- Feedback shows runs are manageable (difficulty 5-7/10)
- No injuries or concerning pain

**Action:**
```
Gradual Progression:
- Increase weekly volume by 10%
- Add variation (tempo runs, hill runs, long runs)
- Build toward goal more aggressively

Coach explains:
"You've been crushing it for a month straight! 
Your body is adapting well. 
Let's level up the training and get you closer to [goal]."
```

**Example:**
```
Week 4 Status:
- 8/8 runs completed
- Average difficulty: 6/10
- No injuries
- User says: "Feeling strong"

Week 5 Progression:
├── Monday: 5km easy
├── Wednesday: 4km tempo (new intensity)
├── Friday: 6km easy
└── Sunday: 8km long run (new weekly long run)

Total weekly volume: +15% from Week 4
```

---

#### **RULE 6: Multiple Misses → Intervention & Reassessment**

**Trigger:**
- User misses 3+ scheduled runs in 2 weeks
- OR User consistently reschedules but doesn't complete

**Action:**
```
Emergency Check-In Call:
- Coach initiates conversation: "Hey, what's going on?"
- Honest discussion about obstacles
- Reassess commitment and schedule
- Potentially reduce frequency or adjust times
- Address root cause of resistance

Coach says:
"I notice you've missed the last few runs. 
No judgment - let's figure out what's really blocking you. 
Maybe the schedule isn't realistic right now? 
Or something else going on? Talk to me."
```

**Possible Adjustments:**
```
If time is the issue:
→ Move runs to different times
→ Reduce frequency (3x → 2x per week)
→ Shorten runs (make them more achievable)

If motivation is the issue:
→ Add more check-ins for accountability
→ Break goal into smaller milestones
→ Revisit the "why" - reconnect to purpose

If life circumstances changed:
→ Press pause on training plan
→ Switch to maintenance mode (1x per week)
→ Set new realistic timeline
```

---

## 🎯 ADAPTATION ALGORITHM SUMMARY

**The coach continuously monitors:**
1. ✅ Difficulty ratings (too easy vs too hard)
2. ✅ Completion rates (showing up vs missing)
3. ✅ Pain reports (injury prevention)
4. ✅ External obstacles (excuses → tasks)
5. ✅ Progress toward goal (on track vs behind)
6. ✅ User sentiment (motivated vs struggling)

**And adjusts:**
1. 📈 Distance and intensity
2. 📅 Frequency and timing
3. 🛑 Rest days and recovery
4. ✅ Tasks to solve obstacles
5. 🎯 Goal timeline and milestones
6. 💬 Check-in frequency and type

**The result:**
A training plan that feels like working with a REAL coach who knows you, adapts to you, and keeps you accountable without destroying you.

---

## 📱 USER EXPERIENCE - COMPLETE FLOW

### **Week 1 - Starting Out**

**Monday Evening (Initial Setup):**
```
User: Opens app for first time

Coach (Voice): "Hey! I'm your running coach. 
                Let's get you started. 
                What's your running goal?"

User: "I want to run a half marathon"

Coach: "Amazing goal! When do you want to do this?"

User: "In 4 months"

Coach: "Perfect, that's totally doable. 
        How many times per week can you commit to running?"

User: "Probably twice a week"

Coach: "Great! Let's start with 2x per week and build from there. 
        When can you run? Mornings, evenings, weekends?"

User: "Tuesday mornings and Friday evenings work best"

Coach: "Done. This week: 
        Tuesday 8am - 3km easy run
        Friday 6pm - 4km easy run
        
        I'll call you before each run to check in. 
        You ready to start tomorrow?"

User: "Let's do it"

[App shows schedule]
```

**Tuesday 7:45 AM:**
```
📞 Phone rings - Coach calling

User: Picks up

Coach: "Morning! First run today - 3km. How are you feeling?"

User: "Nervous but ready"

Coach: "That's normal! This is just an easy run to see where you're at. 
        No pressure on pace or time. 
        Just complete the distance. 
        Weather is perfect, 16 degrees. 
        Grab some water and let's get you out there!"

User: "Okay, I'm going"

[Hangs up, goes running]
```

**Tuesday 8:25 AM:**
```
User: Opens app, marks run complete

App: Voice conversation starts

Coach: "You did it! First run done! How did it feel?"

User: "Actually pretty good! Not as hard as I thought"

Coach: "That's awesome! Rate it 1 to 10, how hard was it?"

User: "Maybe a 5 or 6?"

Coach: "Perfect. That's exactly where we want you. 
        Any pain or soreness?"

User: "No, felt fine"

Coach: "Excellent! You just proved to yourself you can do this. 
        Next run is Friday evening, 4km. 
        I'll check in with you then. 
        Great start!"
```

**Friday 5:45 PM:**
```
📞 Coach calls

Coach: "Friday run time! 4km today. How's your energy?"

User: "Good! Legs are a tiny bit sore from Tuesday but not bad"

Coach: "That's normal - your body is adapting. 
        Today, same deal: easy pace, just finish. 
        Don't worry about speed. 
        You got this?"

User: "Yep!"

[Runs]
```

**Friday 6:45 PM:**
```
Coach: "How was it?!"

User: "Great! Actually easier than Tuesday"

Coach: "Love it! Difficulty?"

User: "Like a 4 or 5"

Coach: "Perfect progression! You're building fitness already. 
        Week 1 complete - 2 for 2! 
        That's consistency. 
        
        Next week: Tuesday 4km, Friday 5km. 
        We're bumping it up slightly. 
        Rest this weekend and I'll see you Tuesday morning!"
```

---

### **Week 3 - Adaptation Happening**

**Tuesday Post-Run:**
```
Coach: "How was the 5km?"

User: "Honestly? Too easy. I felt like I could have gone way longer"

Coach: "Okay! Your body is ready for more. 
        I'm hearing you've felt this way the last few runs. 
        
        Here's what I'm thinking: 
        Add a third run per week 
        AND increase distances a bit. 
        
        Does Thursday morning work for you?"

User: "Yeah, I could do Thursday"

Coach: "Perfect. Here's next week:
        - Tuesday 6km easy
        - Thursday 5km tempo (faster pace)
        - Saturday 8km long run
        
        We're building toward that half marathon. 
        How does this feel?"

User: "Let's do it!"

[Schedule automatically updates]
```

---

### **Week 5 - Handling Pain**

**Thursday Post-Run:**
```
Coach: "How did it go?"

User: "Not great. My right knee started hurting around kilometer 3. 
       Had to walk a bit"

Coach: "Okay, let's not ignore that. 
        Where exactly does it hurt? Inside? Outside? Front?"

User: "Outside of the knee, kind of sharp when I run"

Coach: "Alright, here's the plan:
        - Saturday's run is cancelled. Rest day.
        - Ice your knee 3x per day
        - I'm backing off next week's volume
        
        If it still hurts next week, we might need to see someone. 
        But let's give it rest first. 
        
        Pain is your body talking. Let's listen. 
        Sound good?"

User: "Yeah, makes sense"

[Tasks created: "Ice knee 3x daily"]
[Saturday run removed]
[Next week's distances reduced by 30%]
```

---

### **Week 8 - Crushing It**

**Sunday After Long Run:**
```
Coach: "You just ran 12km! How was it?!"

User: "Hard but I did it! Felt strong until the last 2km"

Coach: "That's incredible! You started at 3km eight weeks ago. 
        You've more than tripled your distance. 
        
        You're officially ready for the next phase:
        We're going to start adding some tempo runs 
        and get you ready for 15km, then 18km.
        
        At this rate, that half marathon is yours. 
        I'm proud of you. 
        
        Rest tomorrow, we'll talk next week about the new plan."

User: "Thanks coach!"
```

---

## 🎯 SUCCESS METRICS

**The MVP is working when:**

✅ Users answer 80%+ of scheduled phone calls
✅ Users complete 75%+ of scheduled runs
✅ Schedule adapts visibly based on user feedback
✅ Users report feeling accountable to the coach
✅ Injuries are caught early and prevented
✅ Users say "I don't want to disappoint my coach"
✅ Progress toward goal is measurable and on track

---

## 💪 THE MAGIC MOMENT

**When a user says:**

"I didn't feel like running today, but my coach called me and I couldn't just blow them off. So I put my shoes on and went. And honestly, once I started, I felt great."

**That's when you know the phone call + adaptation system works.**

---

*This is the Running Coach MVP. Build this, use it yourself, prove it works, then replicate the model for every other coaching niche.*
