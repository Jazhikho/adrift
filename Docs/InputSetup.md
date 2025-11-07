# Input Map Configuration

This document describes the required Input Map actions for the game. These should be configured in Godot's Project Settings -> Input Map.

## Required Actions

### Movement
- **move_forward** (W key)
- **move_backward** (S key)
- **move_left** (A key)
- **move_right** (D key)
- **sprint** (Shift key) - Optional, for sprint functionality

### Interaction
- **interact** (E key)
- **inventory** (Tab key)
- **ping** (Q key)
- **rest** (R key)
- **pause** (Esc key)

## Setup Instructions

1. Open Godot Editor
2. Go to Project -> Project Settings
3. Navigate to Input Map tab
4. Add each action listed above
5. Assign the corresponding keys to each action

## Notes

- The PlayerController script validates that movement actions exist on startup
- Missing actions will generate error messages in the console
- Input actions can be modified in the Inspector for individual instances if needed

