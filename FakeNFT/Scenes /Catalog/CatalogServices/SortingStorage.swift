//
//  SortingStorage.swift
//  FakeNFT
//
//  Created by Artem Dubovitsky on 25.01.2024.
//
import Foundation

protocol SortingStorageProtocol {
    func saveSorting(_ sorting: Sorting)
    func getSorting() -> Sorting?
}

final class SortingStorage: SortingStorageProtocol {
    // MARK: - Properties
    private let sortingStorageKey = "SortingType"
    private let userDefaults = UserDefaults.standard
    private var sorting: Sorting?

    // MARK: - Public Methods
    func saveSorting(_ sorting: Sorting) {
        userDefaults.set(sorting.rawValue, forKey: sortingStorageKey)
    }

    func getSorting() -> Sorting? {
        guard let saveSorting = userDefaults.string(
            forKey: sortingStorageKey) else {
            return Sorting.byNftCount
        }
        return Sorting(rawValue: saveSorting)
    }
}
