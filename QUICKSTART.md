# SureBite MVP - Quick Start Guide

## ⚡ 5-Minute Setup

### Step 1: Get API Key (2 min)
1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Click "Create API Key"
3. Copy the key

### Step 2: Create Xcode Project (1 min)
1. Open Xcode
2. File → New → Project → iOS App
3. Name: `SureBite`, Interface: SwiftUI
4. Save to `/Users/yiransi/Documents/SureBite`

### Step 3: Add Files (1 min)
1. Drag the `SureBite/` folder into Xcode project navigator
2. Check "Copy items if needed"
3. Ensure all files are added to target

### Step 4: Configure (1 min)
1. Open `Services/Secrets.swift`
2. Paste your API key
3. Open Info.plist, add camera permission:
   - Key: `Privacy - Camera Usage Description`
   - Value: `We need camera access to scan menus`

### Step 5: Run! (30 sec)
1. Select iPhone simulator
2. Press Cmd+R
3. Complete onboarding
4. Scan a menu!

## 🧪 Quick Test

**Create a test menu:**
```
APPETIZERS
- Shrimp Cocktail
- Caesar Salad  
- Garlic Bread

ENTREES
- Pad Thai (contains peanuts)
- Grilled Salmon
- Margherita Pizza
```

1. Type this in a document or print it
2. In app: Scan it with camera
3. See risk analysis!

## 🎯 Core Files to Know

- `Secrets.swift` - Add your API key here
- `SureBiteApp.swift` - App entry point
- `ProfileViewModel.swift` - Manages user data
- `GeminiService.swift` - AI integration

## 💡 Tips

- Use well-lit photos for better OCR
- Start with English menus for testing
- Try different allergens in onboarding

---

**Need help?** Check the full `README.md`
