//
//  TodoController.swift
//  PUTandPOST(iOSPT1)
//
//  Created by Dongwoo Pae on 5/27/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation

enum PushMethod: String {
    case post = "POST"
    case put = "PUT"
}

private let baseURL = URL(string: "https://put-and-post-a464c.firebaseio.com/examples")!

class TodoController {
    
    private(set) var todos : [Todo] = []
    
    func createTodo(withTitle title: String) -> Todo {
        let todo = Todo(title: title)
       // todos.append(todo)  we are adding this directly to the server and get int from the server so we wont need to append them here 
        return todo
    }
    
    
    func push(todo:Todo, using method: PushMethod, completion: @escaping (Error?) -> Void ) {
        
        var url = baseURL
        
        if method == .put {   //by adding this when we use .put it is only updating that particular data in firebase
          url.appendingPathComponent(todo.identifier)
        }
        
        let urlTwo = url.appendingPathExtension("json")
        
        var request = URLRequest(url: urlTwo)
        request.httpMethod = method.rawValue
        
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(todo)
        } catch {
            print(error)
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print(error)
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    

    func fetchTodo(completion: @escaping (Error?) -> Void) {
        
        let url = baseURL.appendingPathExtension("json")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        
        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let decodedDictionary = try jsonDecoder.decode([String: Todo].self, from: data)  //because data type in firebase is dictionary  ?????  identifier and title - we did not have to specifically get array of values before. is it because this (json in firebase) is under their own UUID code??
                let todos = Array(decodedDictionary.values) //this will create an array of values of decodedDictionary
                self.todos = todos
                completion(nil)
            } catch {
                print("Error decoding received data: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
}
