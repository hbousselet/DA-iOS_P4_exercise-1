import SwiftUI

final class ToDoListViewModel: ObservableObject {
    // MARK: - Private properties

    private let repository: ToDoListRepositoryType

    // MARK: - Init

    init(repository: ToDoListRepositoryType) {
        self.repository = repository
        self.toDoItems = repository.loadToDoItems()
    }

    // MARK: - Outputs

    /// Publisher for the list of to-do items.
    @Published var toDoItems: [ToDoItem] = [] {
        didSet {
            repository.saveToDoItems(toDoItems)
        }
    }

    // MARK: - Inputs

    // Add a new to-do item with priority and category
    func add(item: ToDoItem) {
        toDoItems.append(item)
    }

    /// Toggles the completion status of a to-do item.
    func toggleTodoItemCompletion(_ item: ToDoItem) {
        if let index = toDoItems.firstIndex(where: { $0.id == item.id }) {
            toDoItems[index].isDone.toggle()
        }
    }

    /// Removes a to-do item from the list.
    func removeTodoItem(_ item: ToDoItem) {
        toDoItems.removeAll { $0.id == item.id }
    }

    /// Apply the filter to update the list.
    func applyFilter(at index: Int) {
        //load toDoItems before editiing it
        let oldToDoItems = repository.loadToDoItems()
        //iterate through filtering logic. Case one, we want to filter only the done todo, case 2 we want to filter only the undo of the todos, then default for all
        switch index {
        case 1:
            //we apply the filter
            toDoItems = oldToDoItems.filter { $0.isDone == true }
            // we save the oldToDoItems into document directory using model methods
            repository.saveToDoItems(oldToDoItems)
        case 2:
            toDoItems = oldToDoItems.filter { $0.isDone == false }
            repository.saveToDoItems(oldToDoItems)
        default:
            toDoItems = oldToDoItems
        }
    }
}
