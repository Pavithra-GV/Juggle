import SwiftUI

struct AddEventView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var date = Date()
    @State private var eventDescription = ""
    @State private var category = "Personal"
    @State private var recurrence: Recurrence = .none
    @State private var checklistItems: [ChecklistItem] = []
    @State private var newChecklistItem = ""

    let categories = ["Personal", "Interviews", "Hackathons", "Tech Events", "Cultural Events"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Event Name") {
                    TextField("Enter event name", text: $name)
                }

                Section("Date and Time") {
                    DatePicker("Select date and time", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }

                Section("Category") {
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    }
                }

                Section("Recurrence") {
                    Picker("Repeat Event", selection: $recurrence) {
                        ForEach(Recurrence.allCases, id: \.self) { recurrence in
                            Text(recurrence.rawValue)
                        }
                    }
                }

                Section("Description (optional)") {
                    TextEditor(text: $eventDescription)
                        .frame(minHeight: 100)
                }

                Section("Preparation Checklist (optional)") {
                    ForEach($checklistItems) { $item in
                        HStack {
                            Button(action: {
                                checklistItems.removeAll { $0.id == item.id }
                            }) {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.red)
                            }

                            TextField("Task", text: $item.title)
                            
                            Toggle("", isOn: $item.isCompleted)
                        }
                    }

                    HStack {
                        TextField("Add new item", text: $newChecklistItem)
                            .onSubmit {
                                addChecklistItem()
                            }
                        
                        Button(action: addChecklistItem) {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
            }
            .navigationTitle("New Event")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        addEvent()
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }

    private func addChecklistItem() {
        if !newChecklistItem.trimmingCharacters(in: .whitespaces).isEmpty {
            checklistItems.append(ChecklistItem(title: newChecklistItem))
            newChecklistItem = ""
        }
    }

    private func addEvent() {
        let newEvent = Event(
            name: name,
            date: date,
            eventDescription: eventDescription,
            category: category,
            recurrence: recurrence,
            checklistItems: checklistItems
        )
        dataManager.addEvent(newEvent)
    }
}
