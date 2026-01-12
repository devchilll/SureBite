import Foundation
import SwiftUI
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var hasCompletedOnboarding: Bool
    
    private let userDefaultsKey = "user_profile"
    private let onboardingKey = "has_completed_onboarding"
    
    init() {
        // Load from UserDefaults
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let savedUser = try? JSONDecoder().decode(User.self, from: data) {
            self.user = savedUser
        } else {
            self.user = User.empty
        }
        
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: onboardingKey)
    }
    
    // MARK: - Profile Management
    
    func updateUser(name: String, email: String) {
        user.name = name
        user.email = email
        save()
    }
    
    func addAllergen(_ allergen: String) {
        user.dietaryProfile.allergens.insert(allergen)
        save()
    }
    
    func removeAllergen(_ allergen: String) {
        user.dietaryProfile.allergens.remove(allergen)
        save()
    }
    
    func addDiet(_ diet: String) {
        user.dietaryProfile.diets.insert(diet)
        save()
    }
    
    func removeDiet(_ diet: String) {
        user.dietaryProfile.diets.remove(diet)
        save()
    }
    
    func updateCustomRestrictions(_ restrictions: String) {
        user.dietaryProfile.customRestrictions = restrictions
        save()
    }
    
    func updateLanguage(_ language: String) {
        user.dietaryProfile.language = language
        save()
    }
    
    func updateLocation(_ location: String) {
        user.dietaryProfile.location = location
        save()
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: onboardingKey)
        save()
    }
    
    func resetProfile() {
        user = User.empty
        hasCompletedOnboarding = false
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        UserDefaults.standard.removeObject(forKey: onboardingKey)
    }
    
    // MARK: - Persistence
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
            print("💾 Profile saved")
        }
    }
    
    // MARK: - Helper Properties
    
    var allergensList: [String] {
        Array(user.dietaryProfile.allergens).sorted()
    }
    
    var dietsList: [String] {
        Array(user.dietaryProfile.diets).sorted()
    }
    
    var hasRestrictions: Bool {
        !user.dietaryProfile.allergens.isEmpty || !user.dietaryProfile.diets.isEmpty
    }
}

