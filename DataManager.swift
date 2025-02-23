import Foundation
import SwiftUI

@MainActor
class DataManager: ObservableObject {
    static let shared = DataManager()
    private let fileName = "events.json"
    
    @Published var events: [Event] = [] {
        didSet { saveEvents() }
    }
    
    var sortedEvents: [Event] {
        events.sorted { $0.date < $1.date }
    }
    
    init() {
        loadEvents()
    }
    
    private func fileURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
    }
    
    func loadEvents() {
        do {
            let fileURL = fileURL()
            guard FileManager.default.fileExists(atPath: fileURL.path) else { return }
            
            let data = try Data(contentsOf: fileURL)
            events = try JSONDecoder().decode([Event].self, from: data)
        } catch {
            print("Error loading events: \(error.localizedDescription)")
        }
    }
    
    func saveEvents() {
        do {
            let data = try JSONEncoder().encode(events)
            try data.write(to: fileURL())
        } catch {
            print("Error saving events: \(error)")
        }
    }
    
    func addEvent(_ event: Event) {
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events[index] = event
        } else {
            events.append(event)
        }
        events.sort { $0.date < $1.date }
    }
    
    func deleteEvent(at offsets: IndexSet) {
        events.remove(atOffsets: offsets)
    }
    
    func updateEvent(_ updatedEvent: Event) {
        addEvent(updatedEvent)
    }
    
    func index(for event: Event) -> Int? {
        events.firstIndex { $0.id == event.id }
    }
}
