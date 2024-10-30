//
//  FirebaseViewModel.swift
//  Firebase Todo App
//
//  Created by Jerry Joy on 2024-10-30.
//

import Foundation
import FirebaseFirestore
import Combine

class FirebaseViewModel: ObservableObject{
    static let shared = FirebaseViewModel()
    
    private let db = Firestore.firestore() // initialize the database
    
    @Published var todos: [Todo] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchTodos()
    }
    
    func fetchTodos() {
        db.collection("todos").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching todos: \(error)")
                return
            }
            
            self.todos = querySnapshot?.documents.compactMap { document in
                try? document.data(as: Todo.self)
            } ?? []
        }
    }
    
    func addTodo(title: String) {
        let newTodo = Todo(title: title, isDone: false)
        do {
            try db.collection("todos").addDocument(from: newTodo)
        } catch {
            print("Error adding todo: \(error)")
        }
    }
    
    func updateTodoStatus(todo: Todo, isDone: Bool) {
        guard let todoId = todo.id else { return }
        db.collection("todos").document(todoId).updateData(["isDone": isDone])
    }
    
    func deleteTodo(todo: Todo) {
        guard let todoId = todo.id else { return }
        db.collection("todos").document(todoId).delete { error in
            if let error = error {
                print("Error deleting todo: \(error)")
            }
        }
    }
    
}
