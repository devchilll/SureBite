import SwiftUI

struct MenuResultsView: View {
    @ObservedObject var scannerVM: ScannerViewModel
    @ObservedObject var profileVM: ProfileViewModel
    @State private var showingChefCard = false
    @State private var selectedDish: MenuItem?
    
    var body: some View {
        VStack(spacing: 0) {
            // Stats Header
            HStack(spacing: 20) {
                StatBadge(count: scannerVM.safeCount, label: "Safe", color: .green)
                StatBadge(count: scannerVM.cautionCount, label: "Caution", color: .orange)
                StatBadge(count: scannerVM.unsafeCount, label: "Avoid", color: .red)
            }
            .padding()
            .background(Color(.systemGray6))
            
            // Filter Tabs
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(ScannerViewModel.RiskFilter.allCases, id: \.self) { filter in
                        FilterButton(
                            title: filter.rawValue,
                            isSelected: scannerVM.selectedFilter == filter
                        ) {
                            scannerVM.selectedFilter = filter
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            
            // Dishes List
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(scannerVM.filteredItems) { item in
                        DishCard(item: item) {
                            selectedDish = item
                        } onToggleSelection: {
                            scannerVM.toggleSelection(for: item.id)
                        }
                    }
                }
                .padding()
            }
            
            // Bottom Bar
            if !scannerVM.selectedItems.isEmpty {
                VStack(spacing: 0) {
                    Divider()
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(scannerVM.selectedItems.count) dishes selected")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Text("Ready to show waiter")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button(action: { showingChefCard = true }) {
                            HStack {
                                Image(systemName: "person.fill")
                                Text("Show to Waiter")
                                    .fontWeight(.semibold)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                }
            }
        }
        .sheet(item: $selectedDish) { dish in
            DishDetailView(dish: dish, onAddToOrder: {
                scannerVM.toggleSelection(for: dish.id)
            })
        }
        .sheet(isPresented: $showingChefCard) {
            ChefCardView(
                selectedDishes: scannerVM.selectedItems,
                profile: profileVM.user.dietaryProfile
            )
        }
    }
}

// MARK: - Supporting Views

struct StatBadge: View {
    let count: Int
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct DishCard: View {
    let item: MenuItem
    let onTap: () -> Void
    let onToggleSelection: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                // Dish Image (placeholder)
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color(riskColor).opacity(0.3), Color(riskColor).opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 120)
                    .overlay(
                        Image(systemName: "fork.knife")
                            .font(.system(size: 40))
                            .foregroundColor(Color(riskColor).opacity(0.5))
                    )
                
                // Dish Info
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.dishName)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            HStack(spacing: 4) {
                                Image(systemName: item.riskLevel.icon)
                                    .font(.caption)
                                Text(item.riskLevel.displayName)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(Color(riskColor))
                        }
                        
                        Spacer()
                        
                        // Selection checkbox (only for safe/caution items)
                        if item.riskLevel != .unsafe {
                            Button(action: onToggleSelection) {
                                Image(systemName: item.isSelected ? "checkmark.circle.fill" : "circle")
                                    .font(.title2)
                                    .foregroundColor(item.isSelected ? .blue : .gray)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    Text(item.reasoning)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                .padding()
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var riskColor: String {
        switch item.riskLevel {
        case .safe: return "green"
        case .caution: return "orange"
        case .unsafe: return "red"
        case .unknown: return "gray"
        }
    }
}
