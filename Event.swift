import SwiftUI

enum Recurrence: String, CaseIterable, Codable {
    case none = "None"
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}

struct ChecklistItem: Identifiable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
}

struct Event: Identifiable, Codable {
    var id = UUID()
    var name: String
    var date: Date
    var eventDescription: String
    var category: String
    var recurrence: Recurrence
    var checklistItems: [ChecklistItem]
    
    var categoryColor: Color {
        categoryColors[category] ?? .gray
    }
}

let categoryColors: [String: Color] = [
    "Personal": .mint,
    "Interviews": .purple,
    "Hackathons": .orange,
    "Tech Events": .green,
    "Cultural Events": .pink
]
