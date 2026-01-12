import SwiftUI

struct MainTabView: View {
    @ObservedObject var profileVM: ProfileViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Profile Tab
            ProfileView(profileVM: profileVM)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(0)
            
            // Scan Tab
            NavigationView {
                VStack {
                    Spacer()
                    
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text("Scan Menu")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    Text("Tap the camera icon to start scanning")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    NavigationLink(destination: MenuScannerView(profileVM: profileVM)) {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("Start Scanning")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .padding()
                }
                .navigationTitle("Scanner")
                .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("Scan", systemImage: "camera")
            }
            .tag(1)
            
            // Settings Tab (placeholder)
            SettingsView(profileVM: profileVM)
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(2)
        }
        .accentColor(.blue)
    }
}
