import SwiftUI

struct ChefCardView: View {
    let selectedDishes: [MenuItem]
    let profile: DietaryProfile
    @Environment(\.dismiss) var dismiss
    
    @State private var currentPage = 0
    
    var body: some View {
        NavigationView {
            TabView(selection: $currentPage) {
                // Page 1: Allergy Warning (Chef Card)
                allergyWarningPage
                    .tag(0)
                
                // Page 2: Order List
                orderListPage
                    .tag(1)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .navigationTitle("Show to Waiter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Allergy Warning Page
    
    private var allergyWarningPage: some View {
        VStack(spacing: 30) {
            // Warning Icon
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 80))
                .foregroundColor(.red)
            
            // Title
            Text("⚠️ ALLERGY WARNING")
                .font(.title)
                .fontWeight(.bold)
            
            // Message in Native Language
            VStack(alignment: .leading, spacing: 16) {
                Text("I have severe allergies to:")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                ForEach(Array(profile.allergens), id: \.self) { allergen in
                    HStack {
                        Image(systemName: "circle.fill")
                            .font(.caption)
                        Text(allergen)
                            .font(.title2)
                    }
                }
                
                if !profile.diets.isEmpty {
                    Text("I follow these diets:")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.top, 8)
                    
                    ForEach(Array(profile.diets), id: \.self) { diet in
                        HStack {
                            Image(systemName: "circle.fill")
                                .font(.caption)
                            Text(diet)
                                .font(.title2)
                        }
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.red.opacity(0.1))
            .cornerRadius(12)
            
            // Translated Message (if location is set)
            if profile.location != "Unknown" {
                VStack(alignment: .leading, spacing: 8) {
                    Text("In \(profile.location):")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(getTranslatedMessage())
                        .font(.title3)
                        .italic()
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            
            // Safety Note
            Text("Please ensure my meal is prepared safely without cross-contamination.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            // Swipe Indicator
            HStack {
                Text("Swipe for order list")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Image(systemName: "arrow.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
    
    // MARK: - Order List Page
    
    private var orderListPage: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Title
            Text("My Order")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("\(selectedDishes.count) dishes selected")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Dishes List
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(Array(selectedDishes.enumerated()), id: \.element.id) { index, dish in
                        HStack(alignment: .top, spacing: 12) {
                            // Number
                            Text("\(index + 1)")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                                .frame(width: 40)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(dish.dishName)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("Safe for me")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
    // MARK: - Helper Methods
    
    private func getTranslatedMessage() -> String {
        let allergensList = Array(profile.allergens).joined(separator: ", ")
        
        // This is a simple placeholder. In a real app, you'd use a translation API
        switch profile.location {
        case "Japan":
            return "私は\(allergensList)にアレルギーがあります。"
        case "France":
            return "Je suis allergique à \(allergensList)."
        case "Spain":
            return "Soy alérgico a \(allergensList)."
        case "China":
            return "我对\(allergensList)过敏。"
        default:
            return "I am allergic to \(allergensList)."
        }
    }
}
