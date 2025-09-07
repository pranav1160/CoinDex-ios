//
//  PortfolioDataService.swift
//  CoinDex
//
//  Created by Pranav on 07/09/25.
//

import Foundation
import CoreData

class PortfolioDataService{
    
    private let container:NSPersistentContainer
    private let context :NSManagedObjectContext
    private let containerName = "PortfolioContainer"
    private let entityName = "PortfolioEntity"

    
    @Published var savedPortfolios:[PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("ERROR loading core data: \(error.localizedDescription)")
            } else {
                print("CoreData loaded successfully")
            }
        }
        context = container.viewContext
        fetchPortfolio()
    }
    
    func update(coin:Coin,amount:Double){
        guard let portfolio = savedPortfolios.first(where: {$0.id == coin.id }) else {
            addPortfolio(coin: coin, amount: amount)
            return
        }
        
        if amount>0{
            updatePortfolio(portfolio: portfolio, amount: amount)
        }else{
            deletePortfolio(portfolio: portfolio)
        }
    }
    
    //MARK: - PRIVATE METHODS
    
    private func addPortfolio(coin:Coin,amount:Double){
        let newPortfolio = PortfolioEntity(context: context)
        newPortfolio.id=coin.id
        newPortfolio.amount=amount
        applyChanges()
    }
    
    private func fetchPortfolio() {
        let request: NSFetchRequest<PortfolioEntity> = NSFetchRequest(
            entityName: entityName
        )
        
        do {
            let portfolios = try container.viewContext.fetch(request)
            DispatchQueue.main.async {
                self.savedPortfolios = portfolios
            }
        } catch {
            print("Error fetching portfolios: \(error)")
        }
    }

    
    private func updatePortfolio(portfolio:PortfolioEntity,amount:Double){
        portfolio.amount = amount
        applyChanges()
    }
    
    private func deletePortfolio(portfolio:PortfolioEntity){
      
        context.delete(portfolio)
        applyChanges()
    }
    
    private func applyChanges(){
        do{
            try context.save()
            fetchPortfolio()
        }catch let err{
            print("ERROR Saving in core data: \(err.localizedDescription)")
        }
    }
    
}
