import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var searchQuery = ""

    var filteredEvents: [Event] {
        let events = dataManager.sortedEvents
        if searchQuery.isEmpty {
            return events
        } else {
            return events.filter { event in
                event.name.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredEvents) { event in
                    NavigationLink(destination: EventDetailView(eventID: event.id)) {
                        HStack {
                            Circle()
                                .fill(event.categoryColor)
                                .frame(width: 10, height: 10)
                            
                            VStack(alignment: .leading) {
                                Text(event.name)
                                    .font(.headline)
                                Text(event.date, format: .dateTime)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteEvent)
            }
            .navigationTitle("Juggle")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddEventView()) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Event")
                        }
                    }
                }
            }
            .searchable(text: $searchQuery, prompt: "Search events")
        }
    }

    private func deleteEvent(at offsets: IndexSet) {
        dataManager.deleteEvent(at: offsets)
    }
}
