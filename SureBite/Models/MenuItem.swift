import Foundation

// MARK: - Risk Level
enum RiskLevel: String, Codable {
    case safe = "SAFE"
    case caution = "CAUTION"
    case unsafe = "UNSAFE"
    case unknown = "UNKNOWN"
    
    var displayName: String {
        switch self {
        case .safe: return "Safe"
        case .caution: return "Caution"
        case .unsafe: return "Avoid"
        case .unknown: return "Unknown"
        }
    }
    
    var color: String {
        switch self {
        case .safe: return "green"
        case .caution: return "yellow"
        case .unsafe: return "red"
        case .unknown: return "gray"
        }
    }
    
    var icon: String {
        switch self {
        case .safe: return "checkmark.circle.fill"
        case .caution: return "exclamationmark.triangle.fill"
        case .unsafe: return "xmark.circle.fill"
        case .unknown: return "questionmark.circle.fill"
        }
    }
}

// MARK: - Menu Item
struct MenuItem: Identifiable, Codable {
    let id: UUID
    let dishName: String
    let riskLevel: RiskLevel
    let reasoning: String
    let confidence: String
    var isSelected: Bool
    
    // Custom decoder for API response
    enum CodingKeys: String, CodingKey {
        case dishName = "dish_name"
        case riskLevel = "risk_level"
        case reasoning
        case confidence
        case isSelected
    }
    
    init(dishName: String, riskLevel: RiskLevel, reasoning: String, confidence: String, isSelected: Bool = false) {
        self.id = UUID()
        self.dishName = dishName
        self.riskLevel = riskLevel
        self.reasoning = reasoning
        self.confidence = confidence
        self.isSelected = isSelected
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.dishName = try container.decode(String.self, forKey: .dishName)
        self.riskLevel = try container.decode(RiskLevel.self, forKey: .riskLevel)
        self.reasoning = try container.decode(String.self, forKey: .reasoning)
        self.confidence = try container.decode(String.self, forKey: .confidence)
        self.isSelected = try container.decodeIfPresent(Bool.self, forKey: .isSelected) ?? false
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dishName, forKey: .dishName)
        try container.encode(riskLevel, forKey: .riskLevel)
        try container.encode(reasoning, forKey: .reasoning)
        try container.encode(confidence, forKey: .confidence)
        try container.encode(isSelected, forKey: .isSelected)
    }
}
}

// MARK: - Menu Analysis Response
struct MenuAnalysisResponse: Codable {
    let dishes: [MenuItem]
}
