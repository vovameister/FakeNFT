//
//  CartService.swift
//  FakeNFT
//
//  Created by Кира on 30.01.2024.
//

import Foundation

protocol CartServiceProtocol {
    func loadNfts(with id: String, completion: @escaping (Result<[Nft], Error>) -> Void)
}

final class CartService: CartServiceProtocol {
    private let networkClient: NetworkClient
    private let storage: CartStorage
    
    init(networkClient: NetworkClient, storage: CartStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    
    func loadCart(id: String, completion: @escaping (Result<CartModel, Error>) -> Void) {
        let request = CartRequest(id: id)
        networkClient.send(request: request, type: CartModel.self, onResponse: completion)
    }
    
    func loadNft(id: String, completion: @escaping NftCompletion) {
        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: Nft.self, onResponse: completion)
    }
    
    func removeFromCart(id: String, nfts: [Nft], completion: @escaping (Result<CartModel, Error>) -> Void) {
        let nftsString = nfts.map{ $0.id }
        let request = CartPutRequest(id: id, nfts: nftsString)

        networkClient.send(request: request, type: CartModel.self, onResponse: completion)
    }
    
    func loadNfts(with id: String, completion: @escaping (Result<[Nft], Error>) -> Void) {
        loadCart(id: id){ [weak self] result in
            guard let self = self else { return }
            switch result{
            case .success(let cartModel):
                var nfts: [Nft] = []
                var cartModelNFTs = cartModel.nfts.count
                for id in cartModel.nfts {
                    if id.count == 36 {
                        self.loadNft(id: id) { result1 in
                            switch result1 {
                            case .success(let nft):
                                nfts.append(nft)
                                if nfts.count == cartModelNFTs {
                                    completion(.success(nfts))
                                }
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    } else {
                        cartModelNFTs -= 1
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}
