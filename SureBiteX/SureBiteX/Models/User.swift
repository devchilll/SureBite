import Foundation

// MARK: - User Profile
struct User: Codable, Equatable {
    var name: String
    var email: String
    var photoURL: String?
    var dietaryProfile: DietaryProfile
    
    static let empty = User(
        name: "",
        email: "",
        photoURL: nil,
        dietaryProfile: .empty
    )
}

// MARK: - Dietary Profile
struct DietaryProfile: Codable, Equatable {
    var allergens: Set<String>
    var diets: Set<String>
    var language: String
    var location: String
    var customRestrictions: String
    
    static let empty = DietaryProfile(
        allergens: [],
        diets: [],
        language: Locale.current.language.languageCode?.identifier ?? "en",
        location: "Unknown",
        customRestrictions: ""
    )
}

// MARK: - Reference Data
struct ReferenceData {
    static let commonAllergens = [
        Allergen(name: "Peanuts", icon: "🥜", color: "orange"),
        Allergen(name: "Tree Nuts", icon: "🌰", color: "brown"),
        Allergen(name: "Dairy", icon: "🥛", color: "blue"),
        Allergen(name: "Shellfish", icon: "🦐", color: "red"),
        Allergen(name: "Soy", icon: "🫘", color: "green"),
        Allergen(name: "Eggs", icon: "🥚", color: "yellow"),
        Allergen(name: "Wheat", icon: "🌾", color: "wheat"),
        Allergen(name: "Fish", icon: "🐟", color: "cyan"),
        Allergen(name: "Sesame", icon: "⚫", color: "gray")
    ]
    
    static let commonDiets = [
        Diet(name: "Vegan", icon: "🥬", color: "green"),
        Diet(name: "Keto", icon: "💪", color: "purple"),
        Diet(name: "Paleo", icon: "🍖", color: "brown"),
        Diet(name: "Pescatarian", icon: "🐟", color: "blue"),
        Diet(name: "Vegetarian", icon: "🥗", color: "lightGreen"),
        Diet(name: "Halal", icon: "☪️", color: "darkGreen"),
        Diet(name: "Kosher", icon: "✡️", color: "navy")
    ]
    
    static let languages = [
        "English", "Spanish", "French", "Chinese", "Japanese", 
        "Korean", "Thai", "Italian", "German", "Portuguese"
    ]
    
    static let locations = [
        "Japan", "China", "Thailand", "France", "Italy", "Spain", 
        "Mexico", "USA", "Germany", "South Korea", "Vietnam"
    ]
}

// MARK: - Supporting Types
struct Allergen: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: String
}

struct Diet: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: String
}
