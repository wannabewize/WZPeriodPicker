//
//  PeriodCalculator.swift
//  WZPeriodPicker
//
//  Created by Jaehoon Lee on 1/29/26.
//


import Foundation

public struct PeriodCalculator {
    public let rangeStart: WZYearMonth
    public let rangeEnd: WZYearMonth
    
    public init(rangeStart: WZYearMonth, rangeEnd: WZYearMonth) {
        self.rangeStart = rangeStart
        self.rangeEnd = rangeEnd
    }
    
    public var availableYears: [Int] {
        Array(rangeStart.year...rangeEnd.year).reversed()
    }
    
    public func availableMonths(for year: Int?) -> [Int] {
        guard let year = year else { return [] }
        
        let startMonth = (year == rangeStart.year) ? rangeStart.month : 1
        let endMonth = (year == rangeEnd.year) ? rangeEnd.month : 12
        
        return Array(startMonth...endMonth).reversed()
    }
    
    public func canMovePrevious(from current: WZYearMonth?) -> Bool {
        guard let current = current else { return true }
        return current > rangeStart
    }
    
    public func canMoveNext(from current: WZYearMonth?) -> Bool {
        guard let current = current else { return true }
        return current < rangeEnd
    }
    
    public func previousMonth(from current: WZYearMonth?) -> WZYearMonth {
        guard let current = current else { return rangeEnd }
        let prev = current.previousMonth()
        return prev >= rangeStart ? prev : current
    }
    
    public func nextMonth(from current: WZYearMonth?) -> WZYearMonth {
        guard let current = current else { return rangeStart }
        let next = current.nextMonth()
        return next <= rangeEnd ? next : current
    }
}
