//
//  ContentView.swift
//  DEX
//
//  Created by Oleh on 11.04.2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default)
    private var pokedex: FetchedResults<Pokemon>
    
    let fetcher = FetchService()

    var body: some View {
        NavigationView {
            List {
                ForEach(pokedex) { pokemon in
                    NavigationLink {
                        Text(pokemon.name ?? "no name")
                    } label: {
                        Text(pokemon.name ?? "no name")
                    }
                }
               
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button("Add Item", systemImage: "plus") {
                        getPokemon()
                    }
                }
            }
        }
    }
    
    private func getPokemon() {
        Task {
            for id in 1..<152 {
                do {
                    let fetchedPokemon = try await fetcher.fetchPokemon(id)
                    
                    let pokemon = Pokemon(context: viewContext)
                    pokemon.id = Int16(fetchedPokemon.id)
                    pokemon.name = fetchedPokemon.name
                    pokemon.types = fetchedPokemon.types
                    pokemon.attack = Int16(fetchedPokemon.attack)
                    pokemon.hp = Int16(fetchedPokemon.hp)
                    pokemon.defense = Int16(fetchedPokemon.defense)
                    pokemon.specialDefense = Int16(fetchedPokemon.specialDefense)
                    pokemon.specialAttack = Int16(fetchedPokemon.specialAttack)
                    pokemon.speed = Int16(fetchedPokemon.speed)
                    pokemon.sprite = fetchedPokemon.sprite
                    pokemon.shiny = fetchedPokemon.shiny
                    
                    try viewContext.save()
                } catch {
                    print(error)
                }
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
