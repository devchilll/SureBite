import SwiftUI

struct SettingsView: View {
    @ObservedObject var profileVM: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                // Profile Section
                Section {
                    HStack {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Text(profileVM.user.name.prefix(1).uppercased())
                                    .font(.title3)
                                    .foregroundColor(.blue)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(profileVM.user.name.isEmpty ? "User" : profileVM.user.name)
                                .font(.headline)
                            Text(profileVM.user.email.isEmpty ? "No email" : profileVM.user.email)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            if !profileVM.allergensList.isEmpty {
                                Text("Gluten Free")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.2))
                                    .foregroundColor(.blue)
                                    .cornerRadius(8)
                            }
                            if !profileVM.dietsList.isEmpty {
                                Text("Peanut Free")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.orange.opacity(0.2))
                                    .foregroundColor(.orange)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                
                // General Section
                Section("GENERAL") {
                    NavigationLink(destination: EmptyView()) {
                        SettingsRow(icon: "person.circle.fill", title: "Account Settings", color: .blue)
                    }
                    
                    NavigationLink(destination: EditAllergiesView(profileVM: profileVM)) {
                        SettingsRow(icon: "cross.case.fill", title: "Food Allergy Profile", color: .red)
                    }
                    
                    NavigationLink(destination: LanguageSettings(profileVM: profileVM)) {
                        HStack {
                            SettingsRow(icon: "globe", title: "Language", color: .green)
                            Spacer()
                            Text(profileVM.user.dietaryProfile.language)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    NavigationLink(destination: LocationSettings(profileVM: profileVM)) {
                        HStack {
                            SettingsRow(icon: "location.fill", title: "Current Location", color: .purple)
                            Spacer()
                            Text(profileVM.user.dietaryProfile.location)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // Preferences Section
                Section("PREFERENCES") {
                    HStack {
                        SettingsRow(icon: "bell.fill", title: "Notifications", color: .orange)
                        Spacer()
                        Text("On")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        SettingsRow(icon: "paintbrush.fill", title: "App Theme", color: .pink)
                        Spacer()
                        Text("System")
                            .foregroundColor(.secondary)
                    }
                    
                    Toggle(isOn: .constant(true)) {
                        SettingsRow(icon: "chart.bar.fill", title: "Show Safety Score", color: .blue)
                    }
                }
                
                // Privacy & Support
                Section("PRIVACY & SUPPORT") {
                    NavigationLink(destination: EmptyView()) {
                        SettingsRow(icon: "lock.fill", title: "Data & Privacy", color: .gray)
                    }
                    
                    NavigationLink(destination: EmptyView()) {
                        SettingsRow(icon: "questionmark.circle.fill", title: "Help & Support", color: .teal)
                    }
                }
                
                // Sign Out
                Section {
                    Button(action: {
                        // Sign out action
                    }) {
                        HStack {
                            Image(systemName: "arrow.right.square.fill")
                                .foregroundColor(.red)
                            Text("Sign Out")
                                .foregroundColor(.red)
                        }
                    }
                }
                
                // Version
                Section {
                    HStack {
                        Spacer()
                        Text("AllerGenius v1.0.4")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
            }
            .navigationTitle("Settings")
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
}

// MARK: - Supporting Views

struct SettingsRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 25)
            Text(title)
                .foregroundColor(.primary)
        }
    }
}

struct LanguageSettings: View {
    @ObservedObject var profileVM: ProfileViewModel
    
    var body: some View {
        List {
            ForEach(ReferenceData.languages, id: \.self) { language in
                Button(action: {
                    profileVM.updateLanguage(language)
                }) {
                    HStack {
                        Text(language)
                            .foregroundColor(.primary)
                        Spacer()
                        if profileVM.user.dietaryProfile.language == language {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .navigationTitle("Language")
    }
}

struct LocationSettings: View {
    @ObservedObject var profileVM: ProfileViewModel
    
    var body: some View {
        List {
            ForEach(ReferenceData.locations, id: \.self) { location in
                Button(action: {
                    profileVM.updateLocation(location)
                }) {
                    HStack {
                        Text(location)
                            .foregroundColor(.primary)
                        Spacer()
                        if profileVM.user.dietaryProfile.location == location {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        }
        .navigationTitle("Current Location")
    }
}
