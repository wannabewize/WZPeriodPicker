//
//  PeriodCalculator.swift
//  WZPeriodPicker
//
//  Created by Jaehoon Lee on 1/29/26.
//


import Foundation

public struct PeriodCalculator {
    public let rangeStart: YearMonth
    public let rangeEnd: YearMonth
    
    public init(rangeStart: YearMonth, rangeEnd: YearMonth) {
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
    
    public func canMovePrevious(from current: YearMonth?) -> Bool {
        guard let current = current else { return true }
        return current > rangeStart
    }
    
    public func canMoveNext(from current: YearMonth?) -> Bool {
        guard let current = current else { return true }
        return current < rangeEnd
    }
    
    public func previousMonth(from current: YearMonth?) -> YearMonth {
        guard let current = current else { return rangeEnd }
        let prev = current.previousMonth()
        return prev >= rangeStart ? prev : current
    }
    
    public func nextMonth(from current: YearMonth?) -> YearMonth {
        guard let current = current else { return rangeStart }
        let next = current.nextMonth()
        return next <= rangeEnd ? next : current
    }
}
