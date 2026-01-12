import SwiftUI

struct DishDetailView: View {
    let dish: MenuItem
    let onAddToOrder: () -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Dish Image
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [riskColor.opacity(0.3), riskColor.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 200)
                        .overlay(
                            Image(systemName: "fork.knife")
                                .font(.system(size: 60))
                                .foregroundColor(riskColor.opacity(0.5))
                        )
                        .cornerRadius(12)
                    
                    // Dish Name
                    Text(dish.dishName)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    // Risk Badge
                    HStack(spacing: 8) {
                        Image(systemName: dish.riskLevel.icon)
                        Text(dish.riskLevel.displayName)
                            .fontWeight(.semibold)
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(riskColor)
                    .cornerRadius(20)
                    
                    // Risk Explanation
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Risk Analysis")
                            .font(.headline)
                        
                        Text(dish.reasoning)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Confidence
                    HStack {
                        Text("Confidence Level:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(dish.confidence)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Disclaimer
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.orange)
                        Text("Always verify with restaurant staff before ordering. This analysis is AI-generated and may not be 100% accurate.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    Spacer()
                    
                    // Action Button
                    if dish.riskLevel != .unsafe {
                        Button(action: {
                            onAddToOrder()
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: dish.isSelected ? "checkmark.circle.fill" : "plus.circle.fill")
                                Text(dish.isSelected ? "Remove from Order" : "Add to Order")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(dish.isSelected ? Color.red : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Dish Details")
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
    
    private var riskColor: Color {
        switch dish.riskLevel {
        case .safe: return .green
        case .caution: return .orange
        case .unsafe: return .red
        case .unknown: return .gray
        }
    }
}
