import SwiftUI

struct EventDetailView: View {
    @EnvironmentObject var dataManager: DataManager
    let eventID: UUID
    @State private var showingEditView = false
    
    private var eventBinding: Binding<Event> {
        Binding {
            dataManager.events.first { $0.id == eventID } ?? Event.empty
        } set: { newValue in
            if let index = dataManager.events.firstIndex(where: { $0.id == eventID }) {
                dataManager.events[index] = newValue
            }
        }
    }
    
    var body: some View {
        let event = eventBinding.wrappedValue
        
        List {
            Section {
                VStack(alignment: .leading, spacing: 16) {
                    Text(event.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(event.categoryColor)
                    
                    InfoRow(icon: "calendar", text: event.date.formatted(date: .abbreviated, time: .shortened))
                    InfoRow(icon: "arrow.clockwise", text: "Recurrence: \(event.recurrence.rawValue)")
                }
                .padding(.vertical)
            }
            .listRowBackground(Color.clear)
            
            CategorySection(event: event)
            
            if !event.eventDescription.isEmpty {
                DescriptionSection(event: event)
            }
            
            if !event.checklistItems.isEmpty {
                ChecklistSection(event: eventBinding)
            }
        }
        .listStyle(.insetGrouped)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") { showingEditView = true }
                    .tint(event.categoryColor)
            }
        }
        .sheet(isPresented: $showingEditView) {
            EditEventView(event: eventBinding)
                .environmentObject(dataManager)
        }
    }
}

// MARK: - Subviews
private struct CategorySection: View {
    let event: Event
    
    var body: some View {
        Section {
            HStack {
                Text(event.category)
                    .categoryTag(event.categoryColor)
                Spacer()
            }
        } header: {
            SectionHeader(icon: "tag", title: "Category")
        }
    }
}

private struct DescriptionSection: View {
    let event: Event
    
    var body: some View {
        Section {
            Text(event.eventDescription)
                .padding(.vertical, 8)
        } header: {
            SectionHeader(icon: "text.alignleft", title: "Description")
        }
    }
}

private struct ChecklistSection: View {
    @Binding var event: Event
    
    var body: some View {
        Section {
            ForEach($event.checklistItems) { $item in
                HStack {
                    Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(item.isCompleted ? event.categoryColor : .gray)
                    
                    Text(item.title)
                        .strikethrough(item.isCompleted)
                    
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture { item.isCompleted.toggle() }
            }
        } header: {
            SectionHeader(icon: "checklist", title: "Preparation Checklist")
        }
    }
}

// MARK: - Reusable Components
struct SectionHeader: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(title)
        }
        .font(.subheadline)
        .foregroundColor(.gray)
        .padding(.bottom, 4)
    }
}

struct InfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(text)
        }
    }
}

extension Text {
    func categoryTag(_ color: Color) -> some View {
        self
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(color.opacity(0.2))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(color, lineWidth: 1)
            )
            .foregroundColor(color)
    }
}

extension Event {
    static var empty: Event {
        Event(
            name: "",
            date: Date(),
            eventDescription: "",
            category: "Personal",
            recurrence: .none,
            checklistItems: []
        )
    }
}
