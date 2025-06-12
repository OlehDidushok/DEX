//
//  FetchedPokemon.swift
//  DEX
//
//  Created by Oleh on 01.05.2025.
//

import Foundation

struct FetchedPokemon: Decodable {
    let id: Int
    let name: String
    let types: [String]
    let hp: Int
    let attack: Int
    let defense: Int
    let specialAttack: Int
    let specialDefense: Int
    let speed: Int
    let sprite: URL
    let shiny: URL

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case types
        case stats
        case sprites
    }

    struct TypeElement: Decodable {
        struct TypeName: Decodable {
            let name: String
        }
        let type: TypeName
    }

    struct StatElement: Decodable {
        let baseStat: Int
         let stat: StatName

         struct StatName: Decodable {
             let name: String
         }
    }

    struct SpriteContainer: Decodable {
        let front_default: URL
        let front_shiny: URL
        
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)

        // Parse types
        let typeElements = try container.decode([TypeElement].self, forKey: .types)
        types = typeElements.map { $0.type.name }

        // Parse stats
        let statElements = try container.decode([StatElement].self, forKey: .stats)
        var statDict: [String: Int] = [:]
        for stat in statElements {
            statDict[stat.stat.name] = stat.baseStat
        }

        hp = statDict["hp"] ?? 0
        attack = statDict["attack"] ?? 0
        defense = statDict["defense"] ?? 0
        specialAttack = statDict["special-attack"] ?? 0
        specialDefense = statDict["special-defense"] ?? 0
        speed = statDict["speed"] ?? 0

        // Parse sprites
        if let spriteContainer = try? container.decode(SpriteContainer.self, forKey: .sprites) {
            sprite = spriteContainer.front_default
            shiny = spriteContainer.front_shiny
        } else {
            sprite = URL(string: "https://example.com/default.png")!
            shiny = URL(string: "https://example.com/shiny.png")!
        }
    }
}
