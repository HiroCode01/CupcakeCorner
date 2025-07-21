//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by HiRO on 08/06/25.
//

import SwiftUI

struct CheckoutView: View {
    var order: Order
    @State private var confirmationTitleAlert = ""
    @State private var confirmationMessageAlert = ""
    @State private var showingConfirmationAlert = false
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                .accessibilityElement(children: .ignore)
                
                Text("Your total is: \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                }
                    .padding()
            }
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("\(confirmationTitleAlert)", isPresented: $showingConfirmationAlert) { } message: {
            Text(confirmationMessageAlert)
        }
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode")
            return
        }
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Server response: \(jsonString)")
            }

            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationTitleAlert = "Thank you!"
            confirmationMessageAlert = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmationAlert = true
        } catch {
            print("Error: \(error.localizedDescription)")
            confirmationTitleAlert = "Oops!"
            confirmationMessageAlert = "An error occurred while placing your order. Please try again later."
            showingConfirmationAlert = true
        }
    }
}

#Preview {
    CheckoutView(order: Order())
}
