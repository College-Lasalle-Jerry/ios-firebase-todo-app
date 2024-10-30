//
//  ContentView.swift
//  Firebase Todo App
//
//  Created by Jerry Joy on 2024-10-30.
//

import SwiftUI
import FirebaseCore



struct ContentView: View {
    
    
    @StateObject private var firebaseManager = FirebaseViewModel.shared
    
    @State private var newTodoTitle = ""
    
    var body: some View {
        NavigationView {
            VStack{
                List {
                    ForEach(firebaseManager.todos){
                        todo in
                        HStack{
                            Text(todo.title)
                                .strikethrough(todo.isDone, color: .gray)
                            Spacer()
                            Toggle(isOn: Binding(get: {
                                todo.isDone
                            }, set: { newValue in
                                firebaseManager.updateTodoStatus(todo: todo, isDone: newValue)
                            })){
                                EmptyView()
                            }
                        }
                    }.onDelete(perform: deleteTodo)
                }
                .onAppear{
                    if !firebaseManager.todos.isEmpty {
                        Task{
                            firebaseManager.fetchTodos()
                        }
                    }
                }
                
                HStack {
                    TextField("Enter new todo", text: $newTodoTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        if !newTodoTitle.isEmpty {
                            firebaseManager.addTodo(title: newTodoTitle)
                            newTodoTitle = ""
                        }
                    }) {
                        Image(systemName: "plus")
                    }
                    .padding(.leading, 8)
                }
                .padding()
            }.navigationTitle("Todos")
        }
    }
    
    private func deleteTodo(at offsets: IndexSet) {
        offsets.forEach { index in
            let todo = firebaseManager.todos[index]
            firebaseManager.deleteTodo(todo: todo)
        }
    }
    
}

#Preview {
    ContentView()
}
