# 🍅 Terminal Pomodoro Timer - Focus Booster for Developers

![Pomodoro Technique](https://img.icons8.com/color/96/000000/timer.png)
## 💡 Why I Created This Tool

After trying countless Pomodoro apps with distracting interfaces, premium paywalls, or complex setups, I built this **lightweight PowerShell solution** to solve three key problems:

1. **Minimalist Workflow**  
   ⌨️ No GUI distractions - just pure terminal focus  
   💻 Works instantly in any Windows environment  
   🚫 No installations or dependencies required

2. **Zero-Cost Productivity**  
   🆓 100% free (no "Pro version" nonsense)  
   🔓 Full control over your timer settings  
   📝 No registration or tracking

3. **Deep Work Optimized**  
   🔕 Runs silently in your existing terminal  
   ⏱️ Visual countdown keeps you accountable  
   🔄 Seamless pause/resume for interruptions

> "What makes this special is how it disappears into your workflow while actively improving your focus." - Developer testimonial

## 🧠 The Science Behind It

This implementation follows core Pomodoro technique principles:
- ✅ 25-minute focused work sprints (adjustable)
- ✅ 5-minute mental breaks (adjustable)
- ✅ Audible cues for state transitions
- ✅ Strict no-multitasking enforcement

Studies show the Pomodoro method can:
- ↑ Increase focus duration by 120-200%
- ↓ Reduce context-switching fatigue
- ↑ Improve task completion rates

## 🏆 Key Benefits

| Feature | Advantage |
|---------|-----------|
| **Terminal-native** | No alt-tabbing to check timers |
| **Customizable** | Adapt to your personal rhythm |
| **Tactile** | Keyboard-controlled for flow state |
| **Portable** | Runs from USB or cloud drives |

## 🛠️ How It Helps You Focus

1. **Eliminates Decision Fatigue**  
   The timer dictates your work/break rhythm automatically

2. **Creates Urgency**  
   Visual countdown prevents procrastination

3. **Structured Breaks**  
   Enforces proper rest periods to maintain peak cognition

Try it for just **3 sessions** and you'll notice:
- Fewer unintended social media checks
- More consistent coding flow
- Clearer task completion awareness

## 🚀 Basic Usage
Run the timer:

```powershell
.\PomodoroTimer.ps1
```

**Available Commands:**

| Command | Action                       | Shortcut Key |
| ------- | ---------------------------- | ------------ |
| work    | Start 25-minute work session | -            |
| break   | Start 5-minute break         | -            |
| -       | Pause timer                  | P            |
| -       | Resume timer                 | R            |
| exit    | Quit the application         | E            |

## ⚙️ Customization
### 1. Changing Time Durations
Edit these values in the script:

```powershell
# Work duration in seconds (default: 25 minutes)
$workDuration = 25 * 60

# Break duration in seconds (default: 5 minutes)
$breakDuration = 5 * 60
```
### 2. Customizing Sounds
**Option A: Use System Sounds**
Replace these lines to use different system sounds:

```powershell
$soundWorkEnd = [System.Media.SystemSounds]::Exclamation  # Try ::Beep, ::Hand, etc.
$soundBreakEnd = [System.Media.SystemSounds]::Asterisk
```

**Option B: Use Custom WAV Files**
1. Add these lines to the script:

```powershell
$soundWorkEnd = New-Object System.Media.SoundPlayer "C:\path\to\work_sound.wav"
$soundBreakEnd = New-Object System.Media.SoundPlayer "C:\path\to\break_sound.wav"
```

2. Download WAV files (recommended from Freesound.org)

**Recommended Sound Pairs:**

| Purpose    | Example 1                                                              | Example 2                                                             |
| ---------- | ---------------------------------------------------------------------- | --------------------------------------------------------------------- |
| Work Start | [Gentle Chime](https://freesound.org/people/InspectorJ/sounds/411790/) | [Soft Beep](https://freesound.org/people/NoiseCollector/sounds/4391/) |
| Work End   | [Alarm Buzzer](https://freesound.org/people/KorgMS2000B/sounds/52283/) | [Bell Ring](https://freesound.org/people/juskiddink/sounds/109663/)  |

## 🛠️ Troubleshooting
If you get execution errors, run:

```powershell
Set-ExecutionPolicy Bypass -Scope Process
```

## 📊 Example Session

```powershell
pomodoro> work
Starting work session for 25 minutes...
WORK TIME remaining: 24:59  # Counts down every second
[Press P] 
Timer paused. Press 'R' to resume or 'E' to exit.
[Press R]
Timer resumed.
...
Work session completed! Time for a break.
```

## 📜 License
MIT License - Free for personal and commercial use
