## Animation Consolidation Instructions

This document explains how to extract animations from all FBX files and consolidate them into the caleb.fbx AnimationPlayer.

## Method 1: Manual Extraction (Recommended)

1. **Open caleb.fbx in Godot:**
   - In the FileSystem dock, navigate to `Art/Models/caleb.fbx`
   - Right-click → "Open in Editor" or double-click
   - This opens the imported scene

2. **Locate the AnimationPlayer:**
   - In the Scene dock, find the AnimationPlayer node
   - If it doesn't exist, add one: Add Node → AnimationPlayer

3. **Extract animations from other FBX files:**
   - For each animation FBX file (e.g., `Injured Walk.fbx`, `Crawl.fbx`, etc.):
     - Open the FBX file in the editor
     - Find its AnimationPlayer node
     - Select all animations in the AnimationPlayer
     - Copy them (Ctrl+C)
     - Go back to caleb.fbx scene
     - Paste into caleb's AnimationPlayer (Ctrl+V)
     - Animations will be added to the list

4. **Save the caleb.fbx scene:**
   - Make sure all animations are visible in the AnimationPlayer
   - Save the scene (Ctrl+S)

## Method 2: Using the Extract Script

1. **Run the extraction script:**
   - Open Godot Editor
   - Go to: File → Run Script
   - Navigate to: `Scripts/Editor/ExtractAnimations.gd`
   - Click "Run"
   - Check console output for results

2. **Note:** The script will extract animations but you may need to manually verify and save.

## Expected Animation Names

Based on the FBX files, you should have these animations:
- `CalebSittingIdle` - Idle animation
- `Injured Walk` - Walking forward
- `Injured Walk Backwards` - Walking backward
- `Injured Turn Left` - Turning left
- `Injured Turn Right` - Turning right
- `Crawl` - Crawling animation
- `Swimming` - Swimming animation
- `Treading Water` - Treading water
- `Stand Up` - Standing up
- `Crouch To Stand` - Standing from crouch
- `Standing To Crouched` - Crouching
- `Idle To Situp` - Sitting up
- `CalebKneeling` - Kneeling animation
- `Swimming To Edge` - Swimming to edge
- `Injured Wave Idle` - Waving idle

## Configuring PlayerController

After consolidating animations, update the PlayerController export variables in the Inspector:
- `animation_idle`: "CalebSittingIdle"
- `animation_walk`: "Injured Walk"
- `animation_walk_backward`: "Injured Walk Backwards"
- `animation_turn_left`: "Injured Turn Left"
- `animation_turn_right`: "Injured Turn Right"

## Troubleshooting

- **Animations not found:** Make sure you've copied all animations into caleb.fbx's AnimationPlayer
- **Animation names don't match:** Update the animation name export variables in PlayerController
- **AnimationPlayer not found:** Make sure caleb.fbx has an AnimationPlayer node

