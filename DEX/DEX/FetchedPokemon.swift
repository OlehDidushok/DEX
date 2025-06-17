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
    let spriteURL: URL
    let shinyURL: URL

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case types
        case stats
        case sprites
        case frontDefault
        case frontShiny
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)

        let typeElements = try container.decode([TypeElement].self, forKey: .types)
        var decodedTypes = typeElements.map { $0.type.name }
        if decodedTypes.count == 2 && decodedTypes[0] == "normal" {
            decodedTypes.swapAt(0, 1)
        }
        types = decodedTypes

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

        let spriteContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .sprites)
        spriteURL = try spriteContainer.decode(URL.self, forKey: .frontDefault)
        shinyURL = try spriteContainer.decode(URL.self, forKey: .frontShiny)
    }
}
