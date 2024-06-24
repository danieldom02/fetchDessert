//
//  ContentView.swift
//  FetchDessert
//
//  Created by Daniel Dominguez on 6/24/24.
//

import SwiftUI

struct ContentView: View {
    @State private var recipes: [Recipe]?
    @State private var isDetailViewActive = false
    @State private var loadedText: String = ""
    @State private var mealImage: String = ""
    @State private var ingredients: [String] = []
    @State private var measurements: [String] = []
    @State private var instructions: String = ""
    
    var body: some View {
        NavigationStack {
            
            if let recipes {
                List(recipes.indices) { meal in
                    
                    HStack {
                        Button("\(recipes[meal].strMeal)") {
                            Task {
                                try await Task.sleep(nanoseconds: 1_000_000_000)
                                let result = try await getRecipeDetails(recipeId: recipes[meal].idMeal)
                                loadedText = result[0].strMeal
                                mealImage = result[0].strMealThumb
                                ingredients = [
                                    result[0].strIngredient1,
                                    result[0].strIngredient2,
                                    result[0].strIngredient3,
                                    result[0].strIngredient4,
                                    result[0].strIngredient5,
                                    result[0].strIngredient6,
                                    result[0].strIngredient7,
                                    result[0].strIngredient8,
                                    result[0].strIngredient9,
                                    result[0].strIngredient10,
                                    result[0].strIngredient11,
                                    result[0].strIngredient12,
                                    result[0].strIngredient13,
                                    result[0].strIngredient14,
                                    result[0].strIngredient15,
                                    result[0].strIngredient16,
                                    result[0].strIngredient17,
                                    result[0].strIngredient18,
                                    result[0].strIngredient19,
                                    result[0].strIngredient20].filter{!$0.isEmpty}
                                measurements = [
                                    result[0].strMeasure1,
                                    result[0].strMeasure2,
                                    result[0].strMeasure3,
                                    result[0].strMeasure4,
                                    result[0].strMeasure5,
                                    result[0].strMeasure6,
                                    result[0].strMeasure7,
                                    result[0].strMeasure8,
                                    result[0].strMeasure9,
                                    result[0].strMeasure10,
                                    result[0].strMeasure11,
                                    result[0].strMeasure12,
                                    result[0].strMeasure13,
                                    result[0].strMeasure14,
                                    result[0].strMeasure15,
                                    result[0].strMeasure16,
                                    result[0].strMeasure17,
                                    result[0].strMeasure18,
                                    result[0].strMeasure19,
                                    result[0].strMeasure20].filter{!$0.isEmpty}
                                instructions = result[0].strInstructions
                                isDetailViewActive = true
                            }
                        }
                        NavigationLink(
                            destination: DetailView( name: loadedText, picture: mealImage, listOfIng: ingredients, listOfMeas: measurements, mealInstruc: instructions),
                            isActive: $isDetailViewActive
                        ) {
                            Text("").hidden()
                        }.frame(width: 10)
                    }
                    
                    
                }
                
                
                
            } else {
                Text("No data available")
            }
        }
        .navigationTitle("SwiftUI")
        .padding(30.0)
//        .background(Color.purple)
        .task {
            do {
                recipes = try await getAllRecipes()
            } catch {
                recipes = nil
            }
        }
    }
    
    struct DetailView: View {
        let name: String
        let picture: String
        let listOfIng: [String]
        let listOfMeas: [String]
        let mealInstruc: String

        var body: some View {
            Text("\(name)").bold()
            List{
                AsyncImage(url: URL(string: picture)){ result in
                    result.image?
                        .resizable()
                        .scaledToFill()
                }
                .frame(width: UIScreen.main.bounds.size.width - 100, height: 200)
                Text("Ingredients:\n").bold()
                List(listOfIng.indices){ ingredient in
                    Text("\(listOfIng[ingredient] + ": " + listOfMeas[ingredient])")
                }.frame(height: 200)
                Text("Instructions:\n").bold()
                ScrollView{
                    Text("\(mealInstruc)")
                }
            }
        }
    }
    
    func getAllRecipes() async throws -> [Recipe] {
        let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let wrapper = try JSONDecoder().decode(Wrapper.self, from: data)
        return wrapper.meals
    }
    
    func getRecipeDetails(recipeId: String) async throws -> [Details] {
        let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(recipeId)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let results = try JSONDecoder().decode(DetailsWrapper.self, from: data)
        return results.meals
    }
}

#Preview {
    ContentView()
}
