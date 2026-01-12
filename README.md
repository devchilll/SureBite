# SureBite - iOS MVP

An iOS app to help people with food allergies and dietary restrictions safely navigate restaurant menus, especially when traveling abroad.

## 🎯 Features

- **Menu Scanning**: Use your camera to scan physical menus
- **AI Analysis**: Powered by Gemini AI to identify allergens and dietary conflicts
- **Risk Assessment**: Dishes categorized as Safe, Caution, or Avoid
- **Chef Card**: Translated allergy warnings to show waiters
- **Order Builder**: Select safe dishes and create an order list
- **Profile Management**: Customize allergens, diets, language, and location

## 📱 Screenshots

See the `/UX` folder for design mockups.

## 🚀 Getting Started

### Prerequisites
- macOS with Xcode 15+ installed
- iOS 16+ device or simulator  
- Google Gemini API key ([Get one here](https://makersuite.google.com/app/apikey))

### Setup Instructions

1. **Create a new Xcode project**:
   - Open Xcode
   - File → New → Project
   - Choose "App" under iOS
   - Product Name: `SureBite`
   - Interface: SwiftUI
   - Language: Swift
   - Save in `/Users/yiransi/Documents/SureBite`

2. **Add the source files**:
   - Drag the entire `SureBite/` folder into your Xcode project
   - Make sure "Copy items if needed" is checked
   - File structure should be:
     ```
     SureBite/
     ├── Models/
     │   ├── User.swift
     │   └── MenuItem.swift
     ├── Services/
     │   ├── Secrets.swift
     │   ├── OCRService.swift
     │   └── GeminiService.swift
     ├── ViewModels/
     │   ├── ProfileViewModel.swift
     │   └── ScannerViewModel.swift
     ├── Views/
     │   ├── OnboardingView.swift
     │   ├── ProfileView.swift
     │   ├── MenuScannerView.swift
     │   ├── MenuResultsView.swift
     │   ├── DishDetailView.swift
     │   ├── ChefCardView.swift
     │   └── SettingsView.swift
     ├── SureBiteApp.swift
     └── MainTabView.swift
     ```

3. **Add your API key**:
   - Open `SureBite/Services/Secrets.swift`
   - Replace `YOUR_GEMINI_API_KEY_HERE` with your actual Gemini API key

4. **Configure camera permissions**:
   - In Xcode, select your project in the navigator
   - Select the target → Info tab
   - Add these keys to the Custom iOS Target Properties:
     - `Privacy - Camera Usage Description`: "We need camera access to scan menus"
     - `Privacy - Photo Library Usage Description`: "We need photo access to analyze menu images"

5. **Build and run**:
   - Select your target device/simulator
   - Press Cmd+R to build and run

## 🧪 Testing

### Test the Flow
1. Launch app → Complete onboarding (select allergies like "Peanuts", "Shellfish")
2. Go to Profile → Verify allergens appear as blue pills
3. Tap "Scan Menu" → Take a photo of a menu (or use sample image)
4. Wait for analysis → View results with risk colors
5. Tap a dish → See detailed risk explanation
6. Add dishes to order → Tap "Show to Waiter"
7. View Chef Card with allergy warning

### Sample Menus for Testing
You can create a simple test menu document with items like:
- Grilled Salmon with Lemon
- Pad Thai with Peanut Sauce
- Caesar Salad with Croutons
- Shrimp Tempura
- Vegan Buddha Bowl

## 📊 Architecture

Built using MVVM pattern:
- **Models**: Data structures (User, DietaryProfile, MenuItem)
- **Services**: OCR (Vision framework) and Gemini API client
- **ViewModels**: ProfileViewModel, ScannerViewModel  
- **Views**: SwiftUI views matching UX mocks

## 🔐 Privacy

- All user data stored locally on device (UserDefaults)
- Only extracted text sent to Gemini API, not images
- No account/authentication required for MVP

## 🗺️ Roadmap

See `PRD.md` for full feature roadmap including:
- Phase 2: Restaurant database, crowdsourced validations
- Phase 3: AR overlay, barcode scanning, social sharing

## 📝 Notes

- The `Secrets.swift` file is excluded from git (see `.gitignore`)
- Gemini API is free for moderate usage (you may need to monitor your quota)
- For production, consider adding a backend proxy to hide API keys

## 🐛 Troubleshooting

**OCR not working?**
- Ensure good lighting and clear menu text
- Make sure camera permissions are granted

**API errors?**
- Check your API key in `Secrets.swift`
- Verify internet connection
- Check Gemini API quota limits

**Build errors?**
- Clean build folder (Cmd+Shift+K)
- Restart Xcode
- Verify all files are added to target

## 📄 License

This is an MVP/prototype project.

---

Built with ❤️ using SwiftUI and Gemini AI
