import SwiftUI

struct EditEventView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss
    @Binding var event: Event
    
    @State private var newChecklistItem = ""
    let categories = ["Personal", "Interviews", "Hackathons", "Tech Events", "Cultural Events"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Event Name") {
                    TextField("Enter event name", text: $event.name)
                }
                
                Section("Date and Time") {
                    DatePicker("Select date and time", selection: $event.date, displayedComponents: [.date, .hourAndMinute])
                }
                
                Section("Category") {
                    Picker("Category", selection: $event.category) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    }
                }
                
                Section("Recurrence") {
                    Picker("Repeat Event", selection: $event.recurrence) {
                        ForEach(Recurrence.allCases, id: \.self) { recurrence in
                            Text(recurrence.rawValue)
                        }
                    }
                }
                
                Section("Description (optional)") {
                    TextEditor(text: $event.eventDescription)
                        .frame(minHeight: 100)
                }
                
                Section("Preparation Checklist (optional)") {
                    ForEach($event.checklistItems) { $item in
                        HStack {
                            Button(action: {
                                event.checklistItems.removeAll { $0.id == item.id }
                            }) {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.red)
                            }
                            
                            TextField("Task", text: $item.title)
                            
                            Toggle("", isOn: $item.isCompleted)
                        }
                    }
                    
                    HStack {
                        TextField("Add new task", text: $newChecklistItem)
                            .onSubmit {
                                addChecklistItem()
                            }
                        
                        Button(action: addChecklistItem) {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
            }
            .navigationTitle("Edit Event")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        dataManager.updateEvent(event)
                        dismiss()
                    }
                    .disabled(event.name.isEmpty)
                }
            }
        }
    }
    
    private func addChecklistItem() {
        let trimmedItem = newChecklistItem.trimmingCharacters(in: .whitespaces)
        guard !trimmedItem.isEmpty else { return }
        
        event.checklistItems.append(ChecklistItem(title: trimmedItem))
        newChecklistItem = ""
    }
}
