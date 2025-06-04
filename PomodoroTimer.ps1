<#
.SYNOPSIS
    🍅 Pomodoro Timer for PowerShell
.DESCRIPTION
    A simple Pomodoro timer that runs in the terminal with work/break cycles.
.NOTES
    File Name      : PomodoroTimer.ps1
    Author         : JustDuyen
    Organization   : DuStudios
    Version        : 1.0
    Date           : 2025-06-04
    Prerequisite   : PowerShell 5.1 or later
#>

# Sound settings
$soundWorkEnd = [System.Media.SystemSounds]::Exclamation
$soundBreakEnd = [System.Media.SystemSounds]::Asterisk

# Timer settings
$workDuration = 25 * 60    # 25 minutes
$breakDuration = 5 * 60    # 5 minutes

# Tracking variables
$remainingTime = 0
$isPaused = $false
$isWorkSession = $false
$startTime = $null
$shouldExit = $false

function Show-BorderedProgressBar {
    param(
        [int]$current,
        [int]$total,
        [int]$width = 40,
        [string]$color = "Green",
        [string]$sessionType
    )
    
    $progress = [math]::Min($current / $total, 1)
    $filled = [math]::Floor($progress * $width)
    $empty = $width - $filled
    
    # Create bordered progress bar with clear start/end markers
    $progressBar = "╔" + ("═" * $width) + "╗`n"
    $progressBar += "║"
    
    # Filled portion
    if ($filled -gt 0) {
        $progressBar += ("█" * $filled)
    }
    
    # Current position indicator
    if ($filled -lt $width) {
        $animationChars = @('▌', '▀', '▐', '▄')
        $animIndex = [int](($current % 0.2) * 20) % 4
        $progressBar += $animationChars[$animIndex]
        $progressBar += (" " * ($empty - 1))
    }
    
    $progressBar += "║`n"
    $progressBar += "╚" + ("═" * $width) + "╝"
    
    $timeSpan = [TimeSpan]::FromSeconds($total - $current)
    $timeString = "{0:D2}:{1:D2}" -f $timeSpan.Minutes, $timeSpan.Seconds
    $percent = ($progress * 100).ToString("0.0") + "%"
    
    # Compose display
    $status = "$sessionType  $timeString  $percent"
    $display = "`n$status`n$progressBar"
    
    # Clear previous output and display new one
    [Console]::SetCursorPosition(0, [Console]::CursorTop - 4)
    Write-Host $display -ForegroundColor $color -NoNewline
}

function Start-Countdown {
    param(
        [int]$duration,
        [string]$mode
    )
    
    $script:remainingTime = $duration
    $script:isWorkSession = ($mode -eq "work")
    $script:startTime = Get-Date
    $script:isPaused = $false
    $script:shouldExit = $false
    
    # Display initial message
    $sessionType = if ($mode -eq "work") { "WORK SESSION" } else { "BREAK TIME" }
    $color = if ($mode -eq "work") { "Green" } else { "Cyan" }
    Write-Host "`nStarting $sessionType for $([math]::Floor($duration/60)) minutes...`n" -ForegroundColor $color
    
    # Initial empty progress bar
    Show-BorderedProgressBar -current 0 -total $duration -color $color -sessionType $sessionType
    
    # Countdown loop
    $elapsed = 0
    while ($remainingTime -ge 0 -and -not $shouldExit) {
        if (-not $isPaused) {
            # Update progress display
            Show-BorderedProgressBar -current $elapsed -total $duration -color $color -sessionType $sessionType
            
            $remainingTime--
            $elapsed++
            
            # Check for keyboard input
            if ([Console]::KeyAvailable) {
                $key = [Console]::ReadKey($true)
                if ($key.Key -eq [ConsoleKey]::P) {
                    $script:isPaused = $true
                    Write-Host "`nTimer paused. Press 'R' to resume or 'E' to exit." -ForegroundColor Yellow
                }
                elseif ($key.Key -eq [ConsoleKey]::E) {
                    $script:shouldExit = $true
                    return
                }
            }
        } else {
            # Paused state
            if ([Console]::KeyAvailable) {
                $key = [Console]::ReadKey($true)
                if ($key.Key -eq [ConsoleKey]::R) {
                    $script:isPaused = $false
                    Write-Host "`nTimer resumed." -ForegroundColor $color
                }
                elseif ($key.Key -eq [ConsoleKey]::E) {
                    $script:shouldExit = $true
                    return
                }
            }
        }
        
        Start-Sleep -Seconds 1
    }
    
    # Timer completed
    if (-not $shouldExit) {
        if ($isWorkSession) {
            $soundWorkEnd.Play()
            Write-Host "`nWork session completed! Time for a break." -ForegroundColor Yellow
        } else {
            $soundBreakEnd.Play()
            Write-Host "`nBreak time over! Ready for another work session?" -ForegroundColor Yellow
        }
    }
}

# Main loop
Write-Host "`n🍅 Pomodoro Timer | JustDuyen" -ForegroundColor Magenta
Write-Host "----------------------------------------"
Write-Host "Commands:"
Write-Host "  work    - Start 25-minute work session"
Write-Host "  break   - Start 5-minute break"
Write-Host "  exit    - Quit the timer"
Write-Host "`nDuring countdown:"
Write-Host "  P       - Pause timer"
Write-Host "  R       - Resume timer"
Write-Host "  E       - Exit timer immediately"
Write-Host "`n"

while ($true) {
    Write-Host "pomodoro> " -NoNewline -ForegroundColor Magenta
    $input = Read-Host
    
    switch ($input.ToLower()) {
        "work" {
            Start-Countdown -duration $workDuration -mode "work"
        }
        "break" {
            Start-Countdown -duration $breakDuration -mode "break"
        }
        "exit" {
            $script:shouldExit = $true
            exit
        }
        default {
            Write-Host "Unknown command. Try 'work', 'break', or 'exit'." -ForegroundColor Red
        }
    }
    
    # Clear any remaining key presses
    while ([Console]::KeyAvailable) {
        [Console]::ReadKey($true) | Out-Null
    }
}
