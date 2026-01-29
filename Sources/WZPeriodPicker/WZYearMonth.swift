//
//  YearMonth.swift
//  WZPeriodPicker
//
//  Created by Jaehoon Lee on 1/29/26.
//


import Foundation

public struct WZYearMonth: Equatable, Comparable, Hashable {
    public let year: Int
    public let month: Int
    
    public init(year: Int, month: Int) {
        self.year = year
        self.month = month
    }
    
    public static func < (lhs: WZYearMonth, rhs: WZYearMonth) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        }
        return lhs.month < rhs.month
    }
    
    // 현재 날짜 기준 생성
    public static var current: WZYearMonth {
        let now = Date()
        return WZYearMonth(
            year: Calendar.current.component(.year, from: now),
            month: Calendar.current.component(.month, from: now)
        )
    }
}
