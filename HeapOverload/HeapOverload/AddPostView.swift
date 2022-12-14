//
//  AddPost.swift
//  HeapOverload
//
//  Created by Adam Garcia on 12/10/22.
//

import Foundation
import SwiftUI

struct AddPost: View {
    @State private var ptitle = ""
    @State private var content = "Enter Post Content Here"
    @State private var tags = ""
    
    @State private var author = "63afea341d9ba12edc1bc1a"
    
    @State private var title = ""
    @State private var message = ""
    @State private var status = false
     
    var body: some View {
        VStack {
            Text("Add Post").font(.system(size: 24)).padding(5)
            TextField("Title", text: $ptitle).textFieldStyle(.roundedBorder).padding(5).font(.system(size: 24))
            TextEditor(text: $content).padding(5).font(.system(size: 24))
//            TextField("Tags seperate by ','", text: $tags).textFieldStyle(.roundedBorder).padding(5).font(.system(size: 24))
            Button("Add Post", action: {addPost()}).font(.system(size: 24)).buttonStyle(.bordered).padding(10)
        }.alert(isPresented: $status) {
            Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("OK")))
        }
    }
    
    func addPost() {
        let components = tags.components(separatedBy: ",")
        let trimmedComps = components.map{$0.trimmingCharacters(in: .whitespaces)}
        let lowerTrimComps = trimmedComps.map{$0.lowercased()}
        let set = Set(lowerTrimComps)
        let array = Array(set)

        let url = URL(string: "http://34.125.134.2:5000/api/post")!
        let data = "title=\(ptitle)&author=\(author)&content=\(content)&tag=\(array)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) {
            data, _, error in
            if let error = error {
                message = "\(error.localizedDescription)"
                title = "Error"
                status = true
            }
            
            if let data = data {
                let string = String(data: data, encoding: .utf8)!
                let json = """
                    \(string)
                    """
                let data = json.data(using: .utf8)!
                let dict = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                if string.contains("false") {
                    message = dict["message"] as! String
                    title = "Error"
                    status = true
                }
                else {
                    message = "Successfully Added Post"
                    title = "Success"
                    status = true
                }
            }
        }
        task.resume()
    }
}
