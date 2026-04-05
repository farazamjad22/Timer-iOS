import Foundation

final class TodoViewModel: ObservableObject {
    @Published var items: [TodoItem] = [
        TodoItem(title: "Buy groceries"),
        TodoItem(title: "Go for a walk"),
        TodoItem(title: "Read a book")
    ]
    @Published var newItemText: String = ""

    var completedCount: Int { items.filter(\.isDone).count }
    var totalCount: Int     { items.count }
    var progress: Double    { totalCount == 0 ? 0 : Double(completedCount) / Double(totalCount) }
    var isInputEmpty: Bool  { newItemText.trimmingCharacters(in: .whitespaces).isEmpty }

    func addItem() {
        let trimmed = newItemText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        items.append(TodoItem(title: trimmed))
        newItemText = ""
    }

    func toggle(_ item: TodoItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].isDone.toggle()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}
