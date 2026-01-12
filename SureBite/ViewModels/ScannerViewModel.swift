import Foundation
import SwiftUI
import UIKit

@MainActor
class ScannerViewModel: ObservableObject {
    @Published var menuItems: [MenuItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var selectedFilter: RiskFilter = .all
    
    private let ocrService = OCRService.shared
    private let geminiService = GeminiService.shared
    
    enum RiskFilter: String, CaseIterable {
        case all = "All"
        case safe = "Safe"
        case caution = "Caution"
        case unsafe = "Avoid"
        
        var riskLevel: RiskLevel? {
            switch self {
            case .all: return nil
            case .safe: return .safe
            case .caution: return .caution
            case .unsafe: return .unsafe
            }
        }
    }
    
    // MARK: - Scan Flow
    
    func scanMenu(image: UIImage, profile: DietaryProfile) async {
        isLoading = true
        errorMessage = nil
        menuItems = []
        
        do {
            // Step 1: Extract text using OCR
            let extractedText = try await ocrService.extractText(from: image)
            
            // Step 2: Analyze with Gemini
            let items = try await geminiService.analyzeMenu(text: extractedText, profile: profile)
            
            // Step 3: Update UI
            menuItems = items
            isLoading = false
            
            print("✅ Menu scan complete: \(items.count) dishes analyzed")
            
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            showError = true
            print("❌ Scan error: \(error)")
        }
    }
    
    // MARK: - Item Selection
    
    func toggleSelection(for itemId: UUID) {
        if let index = menuItems.firstIndex(where: { $0.id == itemId }) {
            menuItems[index].isSelected.toggle()
        }
    }
    
    var selectedItems: [MenuItem] {
        menuItems.filter { $0.isSelected }
    }
    
    // MARK: - Filtering
    
    var filteredItems: [MenuItem] {
        guard let riskLevel = selectedFilter.riskLevel else {
            return menuItems
        }
        return menuItems.filter { $0.riskLevel == riskLevel }
    }
    
    // MARK: - Stats
    
    var safeCount: Int {
        menuItems.filter { $0.riskLevel == .safe }.count
    }
    
    var cautionCount: Int {
        menuItems.filter { $0.riskLevel == .caution }.count
    }
    
    var unsafeCount: Int {
        menuItems.filter { $0.riskLevel == .unsafe }.count
    }
    
    // MARK: - Reset
    
    func reset() {
        menuItems = []
        isLoading = false
        errorMessage = nil
        showError = false
        selectedFilter = .all
    }
}
