//
//  LoginView.swift
//  HeapOverload
//
//  Created by Adam Garcia on 12/10/22.
//

import SwiftUI
import Foundation

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    @State private var status = false
    @State private var title = "Error"
    @State private var message = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Login").font(.system(size: 24))
                TextField("Email", text: $email).frame(width: 300).padding(5).textFieldStyle(.roundedBorder).font(.system(size: 24)).autocorrectionDisabled(true)
                SecureField("Password", text: $password).frame(width: 300).padding(5).textFieldStyle(.roundedBorder).font(.system(size: 24)).autocorrectionDisabled(true)
                Button("Login", action: {login()}).padding(5).buttonStyle(.bordered).font(.system(size: 24))
                NavigationLink(destination: RegisterView()) {
                    Text("Sign Up").font(.system(size: 24))
                }.buttonStyle(.bordered).padding(5).frame(width: 300)
            }.alert(isPresented: $status) {
                Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func login() {
        let url = URL(string: "http://34.125.134.2:5000/api/user/login")!
        let data = "email=\(email)&password=\(password)"
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
                    message = "Successfully Logged In"
                    title = "Success"
                    status = true
                }
            }
        }
        task.resume()
    }
    
}
