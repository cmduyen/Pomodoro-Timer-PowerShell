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

# Timer settings (in seconds)
$workDuration = 25 * 60    # 25 minutes
$breakDuration = 5 * 60    # 5 minutes

# Tracking variables
$remainingTime = 0
$isPaused = $false
$isWorkSession = $false
$startTime = $null
$shouldExit = $false

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
    if ($mode -eq "work") {
        Write-Host "`nStarting work session for $($duration / 60) minutes..." -ForegroundColor Green
    } else {
        Write-Host "`nStarting break for $($duration / 60) minutes..." -ForegroundColor Cyan
    }
    
    # Countdown loop
    while ($remainingTime -ge 0 -and -not $shouldExit) {
        if (-not $isPaused) {
            # Clear the line and display countdown
            [Console]::SetCursorPosition(0, [Console]::CursorTop)
            $timeSpan = [TimeSpan]::FromSeconds($remainingTime)
            $timeString = "{0:D2}:{1:D2}" -f $timeSpan.Minutes, $timeSpan.Seconds
            
            if ($isWorkSession) {
                Write-Host -NoNewline "WORK TIME remaining: $timeString" -ForegroundColor Green
            } else {
                Write-Host -NoNewline "BREAK TIME remaining: $timeString" -ForegroundColor Cyan
            }
            
            $remainingTime--
            
            # Check for keyboard input without blocking
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
            # Paused state - check for resume or exit
            if ([Console]::KeyAvailable) {
                $key = [Console]::ReadKey($true)
                if ($key.Key -eq [ConsoleKey]::R) {
                    $script:isPaused = $false
                    Write-Host "`nTimer resumed." -ForegroundColor Green
                }
                elseif ($key.Key -eq [ConsoleKey]::E) {
                    $script:shouldExit = $true
                    return
                }
            }
        }
        
        Start-Sleep -Seconds 1
    }
    
    # Timer completed (only if not exited)
    if (-not $shouldExit) {
        if ($isWorkSession) {
            $soundWorkEnd.Play()
            Write-Host "`n`nWork session completed! Time for a break." -ForegroundColor Yellow
        } else {
            $soundBreakEnd.Play()
            Write-Host "`n`nBreak time over! Ready for another work session?" -ForegroundColor Yellow
        }
    }
}

# Main loop
Write-Host "`n🍅 Simple Pomodoro Timer" -ForegroundColor Magenta
Write-Host "---------------------"
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