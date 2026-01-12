import SwiftUI

@main
struct SureBiteApp: App {
    @StateObject private var profileVM = ProfileViewModel()
    
    var body: some Scene {
        WindowGroup {
            if profileVM.hasCompletedOnboarding {
                MainTabView(profileVM: profileVM)
            } else {
                OnboardingView(profileVM: profileVM)
            }
        }
    }
}
