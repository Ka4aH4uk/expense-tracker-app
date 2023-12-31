//
//  AddCostsView.swift
//  Expense Tracker
//

import SwiftUI

struct AddCostsView: View {
    @Binding var showSheet: Bool
    @Binding var categoryText: String
    var onAddCategory: (String, String?) -> Void
    @State private var selectedIconName: String = ""

    let availableIcons = ["relationship", "house", "car", "baby", "heart", "cat", "shop", "shirt", "gift", "shopping", "ticket", "repair", "shovel", "roller", "money", "rest", "sport", "holiday", "computer", "beach", "park", "cafe", "travel", "tree"]
    
    let columns = Array(repeating: GridItem(.flexible()), count: 4)
    
    var body: some View {
        VStack {
            Spacer()
            TextField("Наименование", text: $categoryText)
                .floatingPlaceholder(NSLocalizedString("Наименование", comment: ""), text: $categoryText)
                .disableAutocorrection(true)
                .autocapitalization(.sentences)
            Divider()
                .padding(.horizontal, 15)
            
            ScrollView {
                Spacer()
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(availableIcons, id: \.self) { iconName in
                        Image(iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedIconName == iconName ? .purple : .clear, lineWidth: 2)
                            )
                            .onTapGesture {
                                selectedIconName = iconName
                            }
                    }
                }
                Spacer()
            }
            .padding(.vertical, 10)
            Divider()
                .padding(.horizontal, 15)
            
            Button(action: {
                onAddCategory(categoryText, selectedIconName)
                showSheet = false
                categoryText = ""
            }) {
                HStack {
                    Spacer()
                    Text("Добавить категорию расходов")
                    Spacer()
                }
            }
            .disabled(categoryText.isEmpty || selectedIconName.isEmpty)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame( height: 50)
            .background(LinearGradient(gradient: Gradient(colors: [.red, .pink.opacity(0.8)]), startPoint: .top, endPoint: .center).opacity(categoryText.isEmpty || selectedIconName.isEmpty ? 0.5 : 1.0))
            .cornerRadius(30)
            .padding(.bottom).padding(.horizontal)
        }
    }
}

struct AddCostsView_Previews: PreviewProvider {
    @State static var showSheet = false
    @State static var categoryText = "Категория"
    
    static func onAddCategory(_ category: String, _ iconName: String?) {
        print("Добавлена категория: \(category) с иконкой: \(iconName ?? "нет иконки")")
    }

    static var previews: some View {
        AddCostsView(showSheet: $showSheet, categoryText: $categoryText, onAddCategory: onAddCategory)
    }
}
