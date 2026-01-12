import SwiftUI

struct ProfileView: View {
    @ObservedObject var profileVM: ProfileViewModel
    @State private var showingScanner = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Header
                    VStack(spacing: 12) {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Text(profileVM.user.name.prefix(1).uppercased())
                                    .font(.largeTitle)
                                    .foregroundColor(.blue)
                            )
                        
                        Text(profileVM.user.name.isEmpty ? "User" : profileVM.user.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        if !profileVM.user.email.isEmpty {
                            Text(profileVM.user.email)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Button("Edit Profile") {
                            showingSettings = true
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }
                    .padding(.vertical)
                    
                    // My Allergies Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("🥜")
                                .font(.title2)
                            Text("My Allergies")
                                .font(.headline)
                            Spacer()
                            NavigationLink(destination: EditAllergiesView(profileVM: profileVM)) {
                                Image(systemName: "plus")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        if profileVM.hasRestrictions {
                            FlowLayout(spacing: 8) {
                                ForEach(profileVM.allergensList, id: \.self) { allergen in
                                    Text(allergen)
                                        .font(.subheadline)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(16)
                                }
                                ForEach(profileVM.dietsList, id: \.self) { diet in
                                    Text(diet)
                                        .font(.subheadline)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(16)
                                }
                            }
                            
                            Text("Selected allergens will be highlighted in menu scans.\nEnsure this list is up-to-date for your safety.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.top, 4)
                        } else {
                            Text("No restrictions added yet")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Emergency Info (Optional)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "cross.case.fill")
                                .foregroundColor(.red)
                            Text("Emergency Info")
                                .font(.headline)
                        }
                        
                        InfoRow(icon: "person.fill", title: "Medical ID", value: "Active")
                        InfoRow(icon: "phone.fill", title: "Emergency Contact", value: "Mom • 555-0123")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Dining Preferences
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "fork.knife")
                                .foregroundColor(.orange)
                            Text("Dining Preferences")
                                .font(.headline)
                        }
                        
                        PreferenceToggle(icon: "leaf.fill", title: "Vegan Mode", isOn: .constant(false))
                        PreferenceToggle(icon: "flame.fill", title: "Spiciness Tolerance", value: "Medium")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Primary CTA
                    Button(action: { showingScanner = true }) {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("Scan Menu")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    
                    // Settings Link
                    Button(action: { showingSettings = true }) {
                        HStack {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(.gray)
                            Text("Settings")
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    Button(action: {
                        // Log out action
                    }) {
                        Text("Log Out")
                            .foregroundColor(.red)
                    }
                    .padding(.top)
                }
                .padding()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingScanner) {
                MenuScannerView(profileVM: profileVM)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(profileVM: profileVM)
            }
        }
    }
}

// MARK: - Supporting Views

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            Text(title)
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

struct PreferenceToggle: View {
    let icon: String
    let title: String
    var isOn: Binding<Bool>? = nil
    var value: String? = nil
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            Text(title)
                .foregroundColor(.primary)
            Spacer()
            if let isOn = isOn {
                Toggle("", isOn: isOn)
            } else if let value = value {
                Text(value)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct EditAllergiesView: View {
    @ObservedObject var profileVM: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            Section("Common Allergens") {
                ForEach(ReferenceData.commonAllergens) { allergen in
                    Button(action: {
                        if profileVM.user.dietaryProfile.allergens.contains(allergen.name) {
                            profileVM.removeAllergen(allergen.name)
                        } else {
                            profileVM.addAllergen(allergen.name)
                        }
                    }) {
                        HStack {
                            Text(allergen.icon)
                            Text(allergen.name)
                                .foregroundColor(.primary)
                            Spacer()
                            if profileVM.user.dietaryProfile.allergens.contains(allergen.name) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            
            Section("Diets") {
                ForEach(ReferenceData.commonDiets) { diet in
                    Button(action: {
                        if profileVM.user.dietaryProfile.diets.contains(diet.name) {
                            profileVM.removeDiet(diet.name)
                        } else {
                            profileVM.addDiet(diet.name)
                        }
                    }) {
                        HStack {
                            Text(diet.icon)
                            Text(diet.name)
                                .foregroundColor(.primary)
                            Spacer()
                            if profileVM.user.dietaryProfile.diets.contains(diet.name) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Edit Restrictions")
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
