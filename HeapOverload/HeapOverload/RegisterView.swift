//
//  RegisterView.swift
//  HeapOverload
//
//  Created by Adam Garcia on 12/10/22.
//

import Foundation
import SwiftUI

struct RegisterView: View {
    @State private var username  = ""
    @State private var email = ""
    @State private var password = ""
    @State private var comfirmPassword = ""
    
    @State private var status = false
    @State private var title = "Error"
    @State private var message = ""
    
    var body: some View {
        VStack {
            Text("Register").font(.system(size: 24))
            TextField("Username", text: $username).frame(width: 300).padding(5).textFieldStyle(.roundedBorder).font(.system(size: 24)).disableAutocorrection(true)
            TextField("Email", text: $email).frame(width: 300).padding(5).textFieldStyle(.roundedBorder).font(.system(size: 24)).disableAutocorrection(true)
            SecureField("Password", text: $password).frame(width: 300).padding(5).textFieldStyle(.roundedBorder).font(.system(size: 24)).disableAutocorrection(true)
            SecureField("Confirm Password", text: $comfirmPassword).frame(width: 300).padding(5).textFieldStyle(.roundedBorder).font(.system(size: 24)).disableAutocorrection(true)
            Button("Register", action: {register()}).padding(5).buttonStyle(.bordered).font(.system(size: 24))
        }.alert(isPresented: $status) {
            Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("OK")))
        }
    }
    
    func register() {
        if password != comfirmPassword {
            message = "Passwords do not match."
            status = true
            
            return
        }
        
        let url = URL(string: "http://34.125.134.2:5000/api/user/signup")!
        let data = "email=\(email)&password=\(password)&username=\(username)"
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
                    message = "Successfully Registered"
                    title = "Success"
                    status = true
                }
            }
        }
        task.resume()
    }
}
