# How to Run SureBite 🏃‍♂️

**⚠️ Important:** Since I am an AI, I generated the **source code** for you, but I cannot generate the `.xcodeproj` binary file. You need to create the container project in Xcode once.

## Step 1: Create the Project
1.  Open **Xcode** on your Mac.
2.  Click **"Create New Project..."** (or File > New > Project).
3.  Choose **iOS** tab -> **App** -> Click **Next**.
4.  **Settings**:
    *   Product Name: `SureBite`
    *   Interface: **SwiftUI**
    *   Language: **Swift**
    *   Storage: None (unchecked)
5.  **Save Location**:
    *   Save it to your **Desktop** for now (to avoid overwriting the files I made).
    *   Click **Create**.

## Step 2: Add The Code
Now we put my code into your new project.

1.  **Open your Finder**.
    *   Go to `Documents/SureBite/SureBite` (where my code is).
2.  **Open Xcode**.
    *   Look at the left sidebar (Project Navigator).
    *   **Delete** the existing `ContentView.swift` and `SureBiteApp.swift` (Move to Trash).
3.  **Drag and Drop**:
    *   Drag the **contents** of my `SureBite` folder (Models, Services, ViewModels, Views, SureBiteApp.swift, MainTabView.swift) **into the Xcode sidebar** under the yellow "SureBite" folder.
4.  **Popup Options**:
    *   Check ✅ **"Copy items if needed"**.
    *   Check ✅ **"Create groups"**.
    *   Check ✅ "Add to targets: **SureBite**".
    *   Click **Finish**.

## Step 3: Run on Simulator
1.  In Xcode, look at the top status bar.
2.  Click the device name (e.g., "Any iOS Device") -> choose **iPhone 16 Pro**.
3.  Press **Cmd + R** (or the Play button ▶️).
    *   The Simulator should launch with the app!

## Step 4: Run on Physical iPhone (Optional)
1.  Connect your iPhone via cable.
2.  Select your iPhone in the device list at the top.
3.  **Sign the App**:
    *   Click the blue **SureBite** icon at the very top left of the sidebar.
    *   Click the **Signing & Capabilities** tab.
    *   Under **Team**, select **"Add an Account..."** and login with your Apple ID.
    *   Select your "Personal Team".
    *   Change **Bundle Identifier** to something unique (e.g., `com.yourname.SureBite`).
4.  **Run (Cmd + R)**.
    *   If it fails to launch, go to your iPhone **Settings** -> **General** -> **VPN & Device Management** -> Trust your Developer App.

## 🆘 Troubleshooting

**"No such module..."**
*   Make sure you dragged the files *into* the Xcode window, and checked "Copy items if needed".

**"Entry point already defined"**
*   Did you delete the original `SureBiteApp.swift` in Step 2? You can't have two.

**Camera Issue**
*   The Simulator camera shows black/static. Use "Choose from Library" to test scanning.
*   On a real phone, you must accept the Camera permission popup.

---
**Need the API Key?**
Open `Services/Secrets.swift` in Xcode and paste your Gemini API key.
