import SwiftUI

struct OnboardingView: View {
    @ObservedObject var profileVM: ProfileViewModel
    @State private var currentStep = 0
    @State private var searchText = ""
    @State private var tempName = ""
    @State private var tempEmail = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                if currentStep > 0 {
                    Button(action: { currentStep -= 1 }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                    }
                }
                Spacer()
                Text("Dietary Preferences")
                    .font(.headline)
                Spacer()
                if currentStep < 2 {
                    Button("Skip") {
                        profileVM.completeOnboarding()
                    }
                    .foregroundColor(.blue)
                }
            }
            .padding()
            
            // Content
            TabView(selection: $currentStep) {
                welcomeStep.tag(0)
                profileStep.tag(1)
                preferencesStep.tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Bottom Button
            Button(action: {
                if currentStep < 2 {
                    currentStep += 1
                } else {
                    profileVM.updateUser(name: tempName, email: tempEmail)
                    profileVM.completeOnboarding()
                }
            }) {
                Text(currentStep == 2 ? "Get Started" : "Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding()
        }
    }
    
    // MARK: - Steps
    
    private var welcomeStep: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "heart.text.square.fill")
                .font(.system(size: 80))
                .foregroundColor(.red)
            
            Text("Welcome to SureBite")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Eat safely anywhere in the world.\nWe'll help you identify allergens and dietary restrictions on any menu.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var profileStep: some View {
        VStack(spacing: 20) {
            Text("Tell us about yourself")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Name")
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField("Your name", text: $tempName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text("Email")
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField("your@email.com", text: $tempEmail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
    
    private var preferencesStep: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search ingredients...", text: $searchText)
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                // Selected items
                if !profileVM.allergensList.isEmpty || !profileVM.dietsList.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("SELECTED")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        FlowLayout(spacing: 8) {
                            ForEach(profileVM.allergensList, id: \.self) { allergen in
                                PillView(text: allergen, icon: "🥜", color: .blue) {
                                    profileVM.removeAllergen(allergen)
                                }
                            }
                            ForEach(profileVM.dietsList, id: \.self) { diet in
                                PillView(text: diet, icon: "🥬", color: .blue) {
                                    profileVM.removeDiet(diet)
                                }
                            }
                        }
                    }
                }
                
                // Common Allergens
                VStack(alignment: .leading, spacing: 12) {
                    Text("COMMON ALLERGENS")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    ForEach(ReferenceData.commonAllergens) { allergen in
                        AllergenRow(
                            allergen: allergen,
                            isSelected: profileVM.user.dietaryProfile.allergens.contains(allergen.name)
                        ) {
                            if profileVM.user.dietaryProfile.allergens.contains(allergen.name) {
                                profileVM.removeAllergen(allergen.name)
                            } else {
                                profileVM.addAllergen(allergen.name)
                            }
                        }
                    }
                }
                
                // Diets
                VStack(alignment: .leading, spacing: 12) {
                    Text("DIETS")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    ForEach(ReferenceData.commonDiets) { diet in
                        DietRow(
                            diet: diet,
                            isSelected: profileVM.user.dietaryProfile.diets.contains(diet.name)
                        ) {
                            if profileVM.user.dietaryProfile.diets.contains(diet.name) {
                                profileVM.removeDiet(diet.name)
                            } else {
                                profileVM.addDiet(diet.name)
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Supporting Views

struct PillView: View {
    let text: String
    let icon: String
    let color: Color
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(icon)
                .font(.caption)
            Text(text)
                .font(.subheadline)
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.caption)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(color)
        .foregroundColor(.white)
        .cornerRadius(16)
    }
}

struct AllergenRow: View {
    let allergen: Allergen
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(allergen.icon)
                    .font(.title3)
                Text(allergen.name)
                    .foregroundColor(.primary)
                Spacer()
                Circle()
                    .strokeBorder(isSelected ? Color.blue : Color.gray, lineWidth: 2)
                    .background(Circle().fill(isSelected ? Color.blue : Color.clear))
                    .frame(width: 24, height: 24)
                    .overlay(
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.caption)
                            .opacity(isSelected ? 1 : 0)
                    )
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

struct DietRow: View {
    let diet: Diet
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(diet.icon)
                    .font(.title3)
                Text(diet.name)
                    .foregroundColor(.primary)
                Spacer()
                Circle()
                    .strokeBorder(isSelected ? Color.blue : Color.gray, lineWidth: 2)
                    .background(Circle().fill(isSelected ? Color.blue : Color.clear))
                    .frame(width: 24, height: 24)
                    .overlay(
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                            .font(.caption)
                            .opacity(isSelected ? 1 : 0)
                    )
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

// Simple flow layout for pills
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX, y: bounds.minY + result.frames[index].minY), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var frames: [CGRect] = []
        var size: CGSize = .zero
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }
                
                frames.append(CGRect(origin: CGPoint(x: currentX, y: currentY), size: size))
                lineHeight = max(lineHeight, size.height)
                currentX += size.width + spacing
            }
            
            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}
