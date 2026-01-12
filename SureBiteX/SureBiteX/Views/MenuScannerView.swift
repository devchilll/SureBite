import SwiftUI
import PhotosUI
import UIKit

struct MenuScannerView: View {
    @ObservedObject var profileVM: ProfileViewModel
    @StateObject private var scannerVM = ScannerViewModel()
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .camera
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                if scannerVM.isLoading {
                    loadingView
                } else if !scannerVM.menuItems.isEmpty {
                    MenuResultsView(scannerVM: scannerVM, profileVM: profileVM)
                } else {
                    scanPromptView
                }
            }
            .navigationTitle("Scan Menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(
                    selectedImage: $selectedImage,
                    sourceType: imagePickerSourceType
                )
            }
            .onChange(of: selectedImage) { newImage in
                if let image = newImage {
                    Task {
                        await scannerVM.scanMenu(
                            image: image,
                            profile: profileVM.user.dietaryProfile
                        )
                    }
                }
            }
            .alert("Scan Error", isPresented: $scannerVM.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                if let error = scannerVM.errorMessage {
                    Text(error)
                }
            }
        }
    }
    
    private var scanPromptView: some View {
        VStack(spacing: 30) {
            Image(systemName: "doc.text.viewfinder")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("Scan a Menu")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Take a photo of the menu or upload an image to analyze dishes for allergens and dietary restrictions.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)
            
            VStack(spacing: 12) {
                Button(action: {
                    imagePickerSourceType = .camera
                    showingImagePicker = true
                }) {
                    HStack {
                        Image(systemName: "camera.fill")
                        Text("Take Photo")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                
                Button(action: {
                    imagePickerSourceType = .photoLibrary
                    showingImagePicker = true
                }) {
                    HStack {
                        Image(systemName: "photo.fill")
                        Text("Choose from Library")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .foregroundColor(.blue)
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, 40)
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Analyzing menu...")
                .font(.headline)
            
            Text("This may take a few seconds")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
