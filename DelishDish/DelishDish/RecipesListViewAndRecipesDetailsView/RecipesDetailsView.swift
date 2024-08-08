//
//  RecipesDetailsView.swift
//  DelishDish
//
//  Created by Volkan Yücel on 10.07.24.
//

import SwiftUI

struct RecipesDetailsView: View {
    
    let meal: Meal
    
    @EnvironmentObject var favouriteViewModel: FavouriteViewModel
    
    @State private var selectedTab: Tab = .ingredients
    @State private var isFavourite: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                    image
                        .resizable()
                        .cornerRadius(10)
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 300)
                .padding()
                
                HStack {
                    Spacer()
                    Button(action: {
                        if isFavourite {
                            favouriteViewModel.removeMealFromFavorites(withId: meal.idMeal)
                        } else {
                            favouriteViewModel.addMealToFavorites(meal: meal)
                        }
                        isFavourite.toggle()
                    }) {
                        VStack {
                            Image(systemName: isFavourite ? "heart.fill" : "heart")
                                .foregroundColor(.red)
                                .font(.title)
                            Text("Favourite")
                                .foregroundStyle(.red)
                        }
                    }
                    Spacer(minLength: 210)
                    
                    Button(action: {
                        if let urlString = meal.strYoutube, let url = URL(string: urlString) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        VStack {
                            Image(systemName: "video.bubble")
                                .foregroundColor(.red)
                                .font(.title)
                            Text("Youtube")
                                .foregroundStyle(.red)
                        }
                    }
                    Spacer()
                }
                .padding(.vertical)
                
                Divider()
                
                HStack {
                    Text("Name:")
                        .font(.title2)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(meal.strMeal)
                        .font(.title3)
                }
                .padding(.horizontal)
                
                Divider()
                
                HStack {
                    Text("Category:")
                        .font(.callout)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(meal.strCategory)
                        .font(.callout)
                }
                .padding(.horizontal)
                
                Divider()
                
                HStack {
                    Text("Area:")
                        .font(.callout)
                        .foregroundColor(.gray)
                    Spacer()
                    Text(meal.strArea)
                        .font(.callout)
                }
                .padding(.horizontal)
                
                Divider()
                
                Picker("Select", selection: $selectedTab) {
                    Text("Ingredient").tag(Tab.ingredients)
                    Text("Measure").tag(Tab.measures)
                    Text("Instructions").tag(Tab.instructions)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                switch selectedTab {
                case .ingredients:
                    Text(meal.ingredientsList())
                        .padding(.horizontal)
                case .measures:
                    Text(meal.measuresList())
                        .padding(.horizontal)
                case .instructions:
                    Text(meal.strInstructions)
                        .padding(.horizontal)
                }
            }
            .navigationTitle("Recipe Details")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                isFavourite = favouriteViewModel.favoriteMeals.contains(where: { $0.idMeal == meal.idMeal })
            }
        }
    }
    
    enum Tab {
        case ingredients, measures, instructions
    }
}

#Preview {
    RecipesListView()
        .environmentObject(FavouriteViewModel())
}

