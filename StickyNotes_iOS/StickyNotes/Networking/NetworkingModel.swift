//
//  NetworkingModel.swift
//  StickyNotes
//
//  Created by Sam Wolf on 2/1/25.
//

import Foundation

struct NetworkingModel {
    let localHostName = "Sams-MacBook-Pro-2.local"
    let serverPort = 3000
    let standardTimeoutInterval: TimeInterval = 15.0
    
    var baseURL: URL? {
        return URL(string: "http://\(localHostName):\(serverPort)")
    }
    
    func getNotes() async throws -> [StickyNote] {
        guard let url = baseURL?.appending(path: "/notes") else {
            throw NetworkingError.invalidURL
        }
        
        var request = URLRequest(url: url, timeoutInterval: standardTimeoutInterval)
        request.httpMethod = "GET"
        
        let dataAndResponse = try await URLSession.shared.data(for: request)
        
        // Server is configured so that 200 is the OK status.
        // Anything else is an error
        guard let response = dataAndResponse.1 as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkingError.badServerResponse
        }
        
        return try JSONDecoder().decode([StickyNote].self, from: dataAndResponse.0)
    }
    
    func createNewNote(noteData: Data) async throws -> StickyNote {
        guard let url = baseURL?.appending(path: "/notes") else {
            throw NetworkingError.invalidURL
        }
        
        var request = URLRequest(url: url, timeoutInterval: standardTimeoutInterval)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") 
        request.httpMethod = "POST"
        request.httpBody = noteData
        
        let dataAndResponse = try await URLSession.shared.data(for: request)
        
        // Server is configured so that 200 is the OK status.
        // Anything else is an error
        guard let response = dataAndResponse.1 as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkingError.badServerResponse
        }
        
        return try JSONDecoder().decode(StickyNote.self, from: dataAndResponse.0)
    }
    
    func editNote() async throws {
        
    }
    
    func deleteNote() async throws {
        
    }
}

enum NetworkingError: Error {
    case invalidURL
    case badServerResponse
}
