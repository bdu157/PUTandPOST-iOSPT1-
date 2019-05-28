//
//  TodolistTableViewController.swift
//  PUTandPOST(iOSPT1)
//
//  Created by Dongwoo Pae on 5/27/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class TodolistTableViewController: UITableViewController {
    
    var todoController = TodoController()
    
    var pushMethod : PushMethod = .post    //.put it replaces wholl data with whatever you swipe left
    
    @IBOutlet weak var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchTodos()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoController.todos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let todo = todoController.todos[indexPath.row]
        cell.textLabel?.text = todo.title
        return cell
    }
 
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let todo = todoController.todos[indexPath.row]
        
        let title: String
        switch pushMethod {
        case .put:
            title = "PUT Again"
        default:
            title = "POST Again"
        }
        let againAction = UIContextualAction(style: .normal, title: title) { (action, view, handler) in
            
            self.todoController.push(todo: todo, using: self.pushMethod) { (error) in
                if let error = error {
                    NSLog("Error pushing todo to server again: \(error)")
                    return
                }
                self.fetchTodos()
                handler(true)
            }
        }
        againAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [againAction])
    }
    


    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let input = textField.text else {return}
        
           let todo = todoController.createTodo(withTitle: input)
        todoController.push(todo: todo, using: pushMethod) { (error) in
            if let error = error {
                print(error)
            } else {
                self.fetchTodos()
            }
        }
    }
    
    func fetchTodos() {
        todoController.fetchTodo { (error) in
            if let error = error {
                print(error)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
