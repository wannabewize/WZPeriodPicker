//
//  YearMonth.swift
//  WZPeriodPicker
//
//  Created by Jaehoon Lee on 1/29/26.
//


import Foundation

public struct YearMonth: Equatable, Comparable, Hashable {
    public let year: Int
    public let month: Int
    
    public init(year: Int, month: Int) {
        self.year = year
        self.month = month
    }
    
    public static func < (lhs: YearMonth, rhs: YearMonth) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        }
        return lhs.month < rhs.month
    }
    
    // 현재 날짜 기준 생성
    public static var current: YearMonth {
        let now = Date()
        return YearMonth(
            year: Calendar.current.component(.year, from: now),
            month: Calendar.current.component(.month, from: now)
        )
    }
}

extension YearMonth {
    /// 지정된 개월 수만큼 이동한 새로운 YearMonth 객체를 반환합니다.
    /// - Parameter value: 더하거나 뺄 개월 수 (음수 가능)
    public func adding(months value: Int) -> YearMonth {
        // 전체 개월 수로 변환하여 계산
        let totalMonths = (year * 12) + (month - 1) + value
        
        let newYear = totalMonths / 12
        let newMonth = (totalMonths % 12) + 1
        
        // 음수 나머지 처리를 위해 (Swift의 % 연산자 특성 대응)
        if newMonth <= 0 {
            return YearMonth(year: newYear - 1, month: newMonth + 12)
        }
        
        return YearMonth(year: newYear, month: newMonth)
    }
    
    /// 다음 달로 이동
    public func nextMonth() -> YearMonth {
        adding(months: 1)
    }
    
    /// 이전 달로 이동
    public func previousMonth() -> YearMonth {
        adding(months: -1)
    }
}

// Date 변환 편의 기능
extension Date {
    var toYearMonth: YearMonth {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return YearMonth(year: components.year ?? 0, month: components.month ?? 1)
    }
}
