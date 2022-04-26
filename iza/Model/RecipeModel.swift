//
//  RecipeModel.swift
//  TrainingDiary
//
//  Created by Pavel Kratochvil on 19.04.2022.
//

import Foundation


enum Category: String {
    case breakfast = "Breakfast"
    case soup = "Soup"
    case salad = "Salad"
    case appetizer = "Appetizer"
    case main = "Main"
    case side = "Side"
    case dessert = "Dessert"
    case snack = "Snack"
    case drink = "Drink"
}

enum Gender: String, CaseIterable {
    case male = "male"
    case female = "female"
}


struct Recipe: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    let description: String
    let ingredients: String
    let directions: String
    let category: Category.RawValue
    let datePublished: String
    let url: String
}

extension Recipe {
    static let all: [Recipe] = [
        Recipe(
            name: "recp1",
            image: "dsa",
            description: "dsa",
            ingredients: "das",
            directions: "dsa",
            category: "main",
            datePublished: "dsa",
            url: "das"
        ),
        Recipe(
            name: "hgf",
            image: "hgf",
            description: "hfg",
            ingredients: "hfg",
            directions: "hgf",
            category: "salad",
            datePublished: "kuy",
            url: "hgf"
        ),
        Recipe(
            name: "jhg",
            image: "jgh",
            description: "jhg",
            ingredients: "fsdgs",
            directions: "gfds",
            category: "soup",
            datePublished: "jhg",
            url: "gfds"
        )
    ]
}

let allGrades: [String] = ["8a+"]

struct Boulder: Identifiable {
    let id: String
    let year: String
    let month: String
    let number: String
    let sector: String
    let color: String
    let grade: String
    let photo: String
    let url: String
}
