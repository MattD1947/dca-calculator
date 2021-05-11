//
//  DCAService.swift
//  ios-dca-calculator
//
//  Created by Changrui Li on 5/8/21.
//

import Foundation

struct DCAService {
    
    func calculate(asset: Asset,
                   initialInvestmentAmout: Double,
                   monthlyDollarCostAveragingAmount: Double,
                   initialDateOfInvestmentIndex: Int)  -> DCAResult{
        
        let investmentAmount = getInvestmentAmout(
            initialInvestmentAmout: initialInvestmentAmout,
            monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
            initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        
        let latestSharePrice = getLatestSharePrice(asset: asset)
        
        let numberOfShares = getNumberOfShares(
            asset: asset,
            initialInvestmentAmout: initialInvestmentAmout,
            monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
            initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        
        
        let currentValue = getCurrentValue(numberOfShares: numberOfShares, latestSharePrice: latestSharePrice)
        
        let isProfitable = currentValue > investmentAmount
        
        let gain = currentValue - investmentAmount
        
        // exmaple
        
        let yield = gain / investmentAmount
        
        let annualReturn = getAnnualReturn(currentValue: currentValue, investmentAmount: investmentAmount, initialDateOfInvestmentIndex: initialDateOfInvestmentIndex)
        
        return .init(currentValue: currentValue,
                     investmentAmout: investmentAmount,
                     gain: gain,
                     yield: yield,
                     annualReturn: annualReturn,
                     isProfitable: isProfitable)
        
        
        //currentValue = numberOfShares (initial + DCA) * latest share price
        //dec $ 1000
        //nov $ 1000
        //oct $ 1000
        //sep $ 5000
        
        
        
    }
    
    private func getInvestmentAmout(initialInvestmentAmout: Double, monthlyDollarCostAveragingAmount: Double, initialDateOfInvestmentIndex: Int)-> Double {
        var totalAmount = Double()
        totalAmount += initialInvestmentAmout
        let dollarCostAveragingAmounts = initialDateOfInvestmentIndex.doubleValue * monthlyDollarCostAveragingAmount
        totalAmount += dollarCostAveragingAmounts
        
        return totalAmount
    }
    
    
    private func getAnnualReturn(currentValue: Double, investmentAmount: Double, initialDateOfInvestmentIndex: Int) -> Double {
        
        let rate = currentValue / investmentAmount
        let years = (initialDateOfInvestmentIndex.doubleValue + 1 ) / 12
        let result = pow(rate, 1 / years) - 1
        return result
    }
    
    
    
    private func getCurrentValue(numberOfShares: Double, latestSharePrice: Double) -> Double {
        return numberOfShares * latestSharePrice
    }
    
    private func getLatestSharePrice(asset: Asset) -> Double{
        return asset.timeSeriesMonthlyAdjusted.getMonthInfos().first?.adjustedClose ?? 0
    }
    
    private func getNumberOfShares(asset: Asset,
                                   initialInvestmentAmout: Double,
                                   monthlyDollarCostAveragingAmount: Double,
                                   initialDateOfInvestmentIndex: Int) -> Double {
        // dec
        // nov
        //oct
        // sep
        
        
        var totalShares = Double()
        
        let initialInvestmentOpenPrice = asset.timeSeriesMonthlyAdjusted.getMonthInfos()[initialDateOfInvestmentIndex].adjustedOpen
        
        let initialInvestmentShares = initialInvestmentAmout / initialInvestmentOpenPrice
        totalShares += initialInvestmentShares
        
        asset.timeSeriesMonthlyAdjusted.getMonthInfos().prefix(initialDateOfInvestmentIndex).forEach{(monthInfo) in
            let dcaInextmentShares = monthlyDollarCostAveragingAmount / monthInfo.adjustedOpen
            totalShares += dcaInextmentShares
        }
        
        return totalShares
    }
}


struct DCAResult {
    let currentValue: Double
    let investmentAmout: Double
    let gain: Double
    let yield: Double
    let annualReturn: Double
    let isProfitable: Bool
}
