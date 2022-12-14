//
//  ViewPostView.swift
//  HeapOverload
//
//  Created by Adam Garcia on 12/10/22.
//

import Foundation
import SwiftUI

struct ViewPost: View {
    @Binding var post: Array<String>
    
    var body: some View{
        VStack{
            Text(post[0]).padding(5).textFieldStyle(.roundedBorder).font(.system(size: 24))
            Text(post[1]).padding(5).textFieldStyle(.roundedBorder).font(.system(size: 24))
//            Text("Tags: \(post[2])").padding(5).textFieldStyle(.roundedBorder).font(.system(size: 24))
        }
    }
}
