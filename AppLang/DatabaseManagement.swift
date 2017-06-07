//
//  DatabaseManagement.swift
//  AppLang
//
//  Created by cagdas on 08/06/2017.
//  Copyright © 2017 Emir Kartal. All rights reserved.

import Foundation
/*
import SQLite

class DatabaseManagement {
    static let shared:DatabaseManagement = DatabaseManagement()
    private let db: Connection?
    
    private let tblProduct = Table("products")
    private let id = Expression<Int64>("id")
    private let name = Expression<String?>("name")
    private let imageName = Expression<String>("imageName")
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do {
            db = try Connection("\(path)/ishop.sqlite3")
            createTableProduct()
        } catch {
            db = nil
            print ("Unable to open database")
        }
    }
    
    func createTableProduct() {
        do {
            try db!.run(tblProduct.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(name)
                //                table.column(phone, unique: true)
                table.column(imageName)
            })
            print("create table successfully")
        } catch {
            print("Unable to create table")
        }
    }
    
    func addProduct(inputName: String, inputImageName: String) -> Int64? {
        do {
            let insert = tblProduct.insert(name <- inputName, imageName <- inputImageName)
            let id = try db!.run(insert)
            print("Insert to tblProduct successfully")
            return id
        } catch {
            print("Cannot insert to database")
            return nil
        }
    }
    
    func queryAllProduct() -> [Product] {
        var products = [Product]()
        
        do {
            for product in try db!.prepare(self.tblProduct) {
                let newProduct = Product(id: product[id],
                                         name: product[name] ?? "",
                                         imageName: product[imageName])
                products.append(newProduct)
            }
        } catch {
            print("Cannot get list of product")
        }
        for product in products {
            print("each product = \(product)")
        }
        return products
    }
    
    func updateContact(productId:Int64, newProduct: Product) -> Bool {
        let tblFilterProduct = tblProduct.filter(id == productId)
        do {
            let update = tblFilterProduct.update([
                name <- newProduct.name,
                imageName <- newProduct.imageName
                ])
            if try db!.run(update) > 0 {
                print("Update contact successfully")
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }
    
    func deleteProduct(inputId: Int64) -> Bool {
        do {
            let tblFilterProduct = tblProduct.filter(id == inputId)
            try db!.run(tblFilterProduct.delete())
            print("delete sucessfully")
            return true
        } catch {
            
            print("Delete failed")
        }
        return false
    }
    
}*/
