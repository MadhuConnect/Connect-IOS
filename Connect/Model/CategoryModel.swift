//
//  CategoryModel.swift
//  Connect
//
//  Created by Venkatesh Botla on 07/08/20.
//  Copyright © 2020 Venkatesh Botla. All rights reserved.
//

import Foundation

struct CategoryModel: Codable {
    let status: Bool
    let message: String?
    let data: [MainCategoryModel]?
}

struct MainCategoryModel: Codable {
    let categoryId: Int
    let name: String
    let image: String
    let uniqueId: String
    let subCategory: Bool
    let subCategoryData: [SubCategoryModel]?
    let products: [ProductModel]?
}

struct SubCategoryModel: Codable {
    let subCategoryId: Int
    let name: String
    let image: String
    let uniqueId: String
    let status: String
    let miniCategory: Bool
    let miniCategoryData: [MiniCategoryModel]?
    let products: [ProductModel]?
}

struct MiniCategoryModel: Codable {
    let miniCategoryId: Int
    let name: String
    let image: String
    let uniqueId: String
    let status: String
    let products: [ProductModel]?
}

struct ProductModel: Codable {
    let productId: Int
    let name: String
    let image: String
    let uniqueId: String
    let status: String
}



