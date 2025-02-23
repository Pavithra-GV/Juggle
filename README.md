# Juggle - An Event Tracking App for College Students

## 1. Problem  

`College students` often struggle to manage their time effectively due to `hectic schedules` filled with lectures, assignments, extracurricular activities, and personal commitments. Keeping track of important events like project deadlines, hackathons, club meetings, and personal goals becomes overwhelming.  
Without a structured way to manage events, students may forget crucial dates, leading to stress, last-minute cramming, and `missed opportunities`.  

## 2. Why We Need This App  

### The Need for a Smarter Time Management Solution  

- Traditional calendar apps often lack flexibility for college students, who require **custom categorization, reminders, and checklists** to stay on top of their schedules.  
- There is a need for an app that not only logs **event dates** but also **helps prepare for events** by allowing users to add a checklist.  
- A simple, **offline, lightweight**, and **interactive** app specifically designed for students can help **reduce mental load** and **improve productivity**.  

## 3. About the App and What It Does  

### What is Juggle?  

Juggle is a **SwiftUI-based** iOS app designed for students to organize and manage their schedules effortlessly. The app allows users to:  

- **Add, Edit, and Delete Events**: Quickly create events with a name, date, category, recurrence, and description.  
- **Categorization with Colors**: Events are categorized (e.g., Interviews, Hackathons, Tech Events) and color-coded for easy identification.  
- **Recurrence Feature**: Set events to repeat daily, weekly, or monthly.  
- **Preparation Checklist**: Each event has an optional checklist to track preparation tasks.  
- **Search and Filter**: Easily find events with a search bar.  
- **Persistence**: Events are stored locally using JSON files, ensuring data is not lost.  

## 4. Code Implementation  

### Core Components  

#### **Event Model (`Event.swift`)**  
The **`Event`** struct defines an event with properties such as name, date, category, and a checklist. Recurrence is also supported.  

```swift
struct Event: Identifiable, Codable {
    var id = UUID()
    var name: String
    var date: Date
    var eventDescription: String
    var category: String
    var recurrence: Recurrence
    var checklistItems: [ChecklistItem]
}
```
### **Data Management (`DataManager.swift`)**
Juggle stores events persistently using `JSON encoding/decoding`. The DataManager class manages adding, updating, and deleting events.

```swift
class DataManager: ObservableObject {
    static let shared = DataManager()
    @Published var events: [Event] = [] {
        didSet { saveEvents() }
    }
    
    func addEvent(_ event: Event) {
        events.append(event)
        events.sort { $0.date < $1.date }
        saveEvents()
    }
}
```
### **User Interface Components**
- `ContentView.swift`: Displays a searchable list of events sorted by date.
- `AddEventView.swift`: Provides a form to add a new event.
- `EditEventView.swift`: Allows editing of an existing event.
- `EventDetailView.swift`: Shows event details, including checklists and recurrence settings.

### **How the UI Works**
**Navigation and Event List (`ContentView.swift`)**
```swift
List {
    ForEach(filteredEvents) { event in
        NavigationLink(destination: EventDetailView(eventID: event.id)) {
            HStack {
                Circle().fill(event.categoryColor).frame(width: 10, height: 10)
                VStack(alignment: .leading) {
                    Text(event.name).font(.headline)
                    Text(event.date, format: .dateTime).font(.subheadline).foregroundColor(.gray)
                }
            }
        }
    }
}
```

**Adding an Event (`AddEventView.swift`)**
```swift
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
```

**Editing an Event (`EditEventView.swift`)**
```swift
@Binding var event: Event

Section("Recurrence") {
    Picker("Repeat Event", selection: $event.recurrence) {
        ForEach(Recurrence.allCases, id: \.self) { recurrence in
            Text(recurrence.rawValue)
        }
    }
}
```

### **5. How This Helps College Students**
1. `Organization Without Overload`
Juggle allows students to quickly input events without unnecessary complexity. The clean UI ensures they can see their important dates at a glance.

2. `Event Preparation & Productivity`
With checklists, students can track tasks related to an event, such as preparing slides for a presentation or submitting an assignment before the deadline.

3. `Offline & Lightweight`
Unlike cloud-based solutions, Juggle stores data locally on the device. This ensures that students can access their schedules without an internet connection.

4. `Recurring Events to Reduce Repetitive Work`
Many college events repeat weekly or monthly (e.g., club meetings, lab deadlines, exams). The recurrence feature removes the need to manually add the same event multiple times.

5. `Quick Search for Fast Access`
A search bar makes it easy to find an event without scrolling through long lists.

6. `Color-Coded Categories for Easy Identification`
Events are categorized using custom colors, helping students quickly differentiate personal tasks from academic ones.

### 6. Conclusion
Juggle is a simple yet powerful event tracking app designed to help college students manage their time better, reduce stress, and stay organized.
By integrating search, event recurrence, checklists, and categorization, it goes beyond a standard calendar and serves as an intelligent event planner tailored for students' needs.
