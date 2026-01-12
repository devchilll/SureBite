import Foundation

class GeminiService {
    static let shared = GeminiService()
    
    private init() {}
    
    /// Analyze menu text against user's dietary profile
    func analyzeMenu(text: String, profile: DietaryProfile) async throws -> [MenuItem] {
        let prompt = buildPrompt(menuText: text, profile: profile)
        let response = try await callGeminiAPI(prompt: prompt)
        return try parseResponse(response)
    }
    
    // MARK: - Private Methods
    
    private func buildPrompt(menuText: String, profile: DietaryProfile) -> String {
        let allergensList = profile.allergens.joined(separator: ", ")
        let dietsList = profile.diets.joined(separator: ", ")
        
        return """
        You are a food safety expert analyzing a restaurant menu for someone with dietary restrictions.
        
        USER PROFILE:
        - Allergens to avoid: \(allergensList.isEmpty ? "None" : allergensList)
        - Dietary preferences: \(dietsList.isEmpty ? "None" : dietsList)
        - Custom restrictions: \(profile.customRestrictions.isEmpty ? "None" : profile.customRestrictions)
        
        MENU TEXT:
        \(menuText)
        
        TASK:
        Analyze each dish on the menu and classify it as SAFE, CAUTION, or UNSAFE based on the user's profile.
        - SAFE: No known allergens or conflicts with dietary preferences
        - CAUTION: May contain allergens or ambiguous ingredients, cross-contamination risk
        - UNSAFE: Definitely contains allergens or violates dietary restrictions
        
        Return ONLY valid JSON in this exact format (no markdown, no code blocks):
        {
          "dishes": [
            {
              "dish_name": "Dish name from menu",
              "risk_level": "SAFE|CAUTION|UNSAFE",
              "reasoning": "Brief explanation (max 15 words)",
              "confidence": "High|Medium|Low"
            }
          ]
        }
        
        IMPORTANT: If you're unsure about ingredients, mark as CAUTION. Prioritize user safety.
        """
    }
    
    private func callGeminiAPI(prompt: String) async throws -> String {
        let apiKey = APIConfig.geminiAPIKey
        
        guard apiKey != "YOUR_GEMINI_API_KEY_HERE" else {
            throw GeminiError.missingAPIKey
        }
        
        let urlString = "\(APIConfig.geminiBaseURL)/\(APIConfig.modelName):generateContent?key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            throw GeminiError.invalidURL
        }
        
        // Build request payload
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ],
            "generationConfig": [
                "temperature": 0.2,
                "topK": 40,
                "topP": 0.95,
                "maxOutputTokens": 2048
            ]
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        print("🤖 Calling Gemini API...")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GeminiError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("❌ API Error: \(errorMessage)")
            throw GeminiError.apiError(statusCode: httpResponse.statusCode, message: errorMessage)
        }
        
        // Parse Gemini response
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let candidates = json["candidates"] as? [[String: Any]],
              let firstCandidate = candidates.first,
              let content = firstCandidate["content"] as? [String: Any],
              let parts = content["parts"] as? [[String: Any]],
              let firstPart = parts.first,
              let text = firstPart["text"] as? String else {
            throw GeminiError.parsingError
        }
        
        print("✅ Gemini Response Received")
        return text
    }
    
    private func parseResponse(_ response: String) throws -> [MenuItem] {
        // Clean response (remove markdown code blocks if present)
        var cleanedResponse = response
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        print("📋 Parsing JSON Response...")
        print(cleanedResponse)
        
        guard let data = cleanedResponse.data(using: .utf8) else {
            throw GeminiError.parsingError
        }
        
        let decoder = JSONDecoder()
        let menuAnalysis = try decoder.decode(MenuAnalysisResponse.self, from: data)
        
        print("✅ Parsed \(menuAnalysis.dishes.count) dishes")
        return menuAnalysis.dishes
    }
}

// MARK: - Errors
enum GeminiError: LocalizedError {
    case missingAPIKey
    case invalidURL
    case invalidResponse
    case apiError(statusCode: Int, message: String)
    case parsingError
    
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "Please add your Gemini API key in Secrets.swift"
        case .invalidURL:
            return "Invalid API URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .apiError(let statusCode, let message):
            return "API Error (\(statusCode)): \(message)"
        case .parsingError:
            return "Failed to parse menu analysis"
        }
    }
}
