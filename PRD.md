# Product Requirements Document (PRD): SureBite MVP

**Version:** 1.0  
**Status:** Draft  
**Authors:** [Your Name] (with AI Assistant)

---

## 1. Executive Summary
**SureBite** is an iOS application designed to mitigate dining anxiety for individuals with food allergies and dietary restrictions. It acts as a "decision support tool" that filters menu items based on a user's biological profile, highlighting risks and translating complexity into safety.

*   **Primary Goal:** Reduce "Time-to-Safety" for diners.
*   **Target Audience:** Travelers with allergies, Celiacs, and strict dietary adherents (Vegan/Halal).
*   **Platform:** iOS (Native).
*   **Key Differentiator:** "Order with Confidence" - identifying safe dishes and helping communicate that order to staff.

---

## 2. User Workflow (The "Happy Path")

### First-Time User Flow
1.  **Onboarding:**
    *   **Welcome Screen:** Brief intro to app purpose
    *   **Dietary Preferences Setup** (based on `food.png` UX):
        *   Search bar to quickly find ingredients
        *   **Selected Section:** Shows active restrictions as blue pills with X to remove
        *   **Common Allergens Section:** Visual icons for Big 8 (Peanuts, Tree Nuts, Dairy, Shellfish, Soy, Eggs, etc.)
        *   **Diets Section:** Vegan, Keto, Paleo, Pescatarian, etc.
        *   "Save Preferences" button at bottom
    *   **Language & Location:** System defaults, editable in settings later

### Core User Flow
2.  **Home/Profile Screen** (based on `profile.png`):
    *   User avatar and profile info at top
    *   **My Allergies** card showing selected allergens as pills (e.g., "Peanuts", "Shellfish", "Gluten")
    *   Optional: Emergency Info, Medical ID, Emergency Contact
    *   **Dining Preferences:** Quick toggles (Vegan Mode, Spiciness Tolerance)
    *   Primary CTA: "Scan Menu" button

3.  **Scan Menu:**
    *   Camera view opens with live text detection indicators
    *   User captures menu photo or uploads from gallery/PDF
    *   **iOS Vision Framework** extracts text on-device
    *   Loading state: "Analyzing menu..."

4.  **Menu Analysis Results** (based on `screen.png`):
    *   Beautiful card-based layout with dish images (if available from AI or placeholders)
    *   Each dish card shows:
        *   Dish name (e.g., "Grilled Salmon", "Pad Thai")
        *   Risk indicator (Green checkmark, Yellow warning, Red X)
        *   Brief description/ingredients
    *   Filter tabs at bottom: "All", "Safe", "Caution", "Avoid"
    *   Tap any dish to see detailed risk reasoning

5.  **Dish Detail View:**
    *   Full dish info
    *   Risk explanation (e.g., "Contains peanut sauce - HIGH RISK")
    *   Confidence level
    *   "Add to Order" button (for safe/acceptable items)

6.  **Order Review & Chef Card:**
    *   Selected dishes shown in a clean list
    *   "Show to Waiter" button generates:
        *   **Chef Card:** Translated allergen warning in local language
        *   **Order Summary:** Clear list of selected dishes with numbers/names
    *   Large, waiter-friendly display optimized for showing across table

7.  **Settings** (based on `setting.png`):
    *   Profile editing
    *   **Food Allergy Profile** - edit restrictions
    *   **Language** - change UI language
    *   **Current Location** - update for travel
    *   Preferences (Notifications, App Theme, Safety Score display)
    *   Privacy & Support sections

---

## 3. Feature Specifications (MVP)

### Feature 1: The Scanner (Vision)
*   **Tech:** SwiftUI + Vision Framework (`VNRecognizeTextRequest`).
*   **Function:** Fast, on-device OCR.
*   **Privacy:** Only text strings are sent to the cloud, not images.

### Feature 2: User Profile & Preferences
*   **Storage:** Local on-device (`UserDefaults` for MVP).
*   **Profile Components:**
    *   User info (name, email, photo)
    *   **Dietary restrictions:** Stored as sets of allergens and diet types
    *   Language preference (default: system language)
    *   Location/destination (for translation context)
    *   Optional: Emergency contact info, Medical ID
*   **UI Features:**
    *   Selected restrictions displayed as removable pills/chips
    *   Search functionality to quickly find ingredients
    *   Icons for common allergens for visual recognition
    *   "Edit Profile" flow accessible from settings

### Feature 3: Analysis Engine
*   **Model:** Gemini 2.5 Flash (for speed/cost) or GPT-4o-mini.
*   **Prompting:** Structured output (JSON) requesting `dish_name`, `risk_level`, `reasoning`, and `confidence`.

### Feature 4: The Interface (Results)
*   **Visuals:** Clean, card-based UI.
    *   **Priority:** Green (Safe) items at the top.
    *   **Clarity:** Bold icons/colors for risk levels.
*   **Interaction:** Simple "Add to Order" toggle.

### Feature 5: The "Order & Chef Card"
*   **Chef Card:** Pre-translated static text (or AI-translated dynamic text) explaining the allergy. e.g., "I cannot eat peanuts."
*   **Order List:** A clean list of the *selected* safe items to show the waiter, minimizing miscommunication.

---

## 4. Technical Architecture (MVP: Serverless/Client-Side)
*   **Frontend:** SwiftUI (iOS 15+).
*   **Backend:** None (Serverless). App speaks directly to Gemini API.
*   **Data Persistence:** `UserDefaults` (for simple user profile settings) or `SwiftData`/`CoreData` (if we need to save history later, but `UserDefaults` is fine for MVP profile).
*   **AI Integration:** Direct HTTP/REST calls to Google Gemini API from the client.
    *   *Note on Security:* For a personal/prototype MVP, storing the API key in the app (e.g., in a `Secrets.swift` file or environment variable) is acceptable. For App Store production, this will need a proxy later (Phase 2).

---

## 5. Future Roadmap

### Phase 2: Enhanced Reliability & Community
*   **Crowdsourced Validations:** Users can "flag" a dish if they had a reaction or found an error.
*   **Restaurant Database:** Store analyzed menus by location (Google Maps integration). If a user walks into "Mario's Pizza," the menu is already there.
*   **Multi-Language UI:** Full app localization, not just the Chef Card.

### Phase 3: The "concierge"
*   **AR Overlay:** (When technology matures) Real-time translation via camera overlay.
*   **Ingredient Deep-Dive:** Integration with product databases for packaged foods (barcode scanning).
*   **Social Sharing:** Share "Safe Places" lists with friends.

---

## 6. Success Metrics
*   **Time-to-Decision:** < 30 seconds from Scan to "Ready to Order".
*   **Retained Users:** % of users who scan > 1 menu per week.
*   **Correction Rate:** How often users override the AI's risk assessment (indicates trust issues).
