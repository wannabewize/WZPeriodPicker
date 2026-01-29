//
//  WZPeriod.swift
//  WZPeriodPicker
//
//  Created by Jaehoon Lee on 1/29/26.
//
import Foundation

public enum WZPeriod: Equatable {
    case all
    case year(Int)
    case yearMonth(year: Int, month: Int)

    public init?(year: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: year)
        if let y = components.year {
            self = .year(y)
        } else {
            return nil
        }
    }

    public init?(yearMonth: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: yearMonth)
        if let y = components.year, let m = components.month {
            self = .yearMonth(year: y, month: m)
        } else {
            return nil        
        }
    }
    
    public init(year: Int?, month: Int?) {
        if let year = year {
            if let month = month {
                self = .yearMonth(year: year, month: month)
            }
            else {
                self = .year(year)
            }
        } else {
            self = .all
        }
    }

    public var description: String {
        switch self {
        case .all:
            return "all"
        case .year(let year):
            return "\(year)"
        case .yearMonth(let year, let month):
            return "\(year)-\(month)"
        }
    }
}

public extension WZPeriod {
    var yearComponent: Int? {
        switch self {
        case .year(let y),
             .yearMonth(let y, _):
            return y
        case .all:
            return nil
        }
    }

    var yearMonthComponent: (Int, Int)? {
        switch self {
        case .yearMonth(let y, let m):
            return (y, m)
        default:
            return nil
        }
    }
}

public extension WZPeriod {
    func next() -> WZPeriod {
        switch self {
        case .all:
            return self

        case .year(let year):
            return .year(year + 1)

        case .yearMonth(let year, let month):
            if month == 12 {
                return .yearMonth(year: year + 1, month: 1)
            } else {
                return .yearMonth(year: year, month: month + 1)
            }
        }
    }

    func previous() -> WZPeriod {
        switch self {
        case .all:
            return self

        case .year(let year):
            return .year(year - 1)

        case .yearMonth(let year, let month):
            if month == 1 {
                return .yearMonth(year: year - 1, month: 12)
            } else {
                return .yearMonth(year: year, month: month - 1)
            }
        }
    }
}



public enum WZPeriodGranularity {
    case all
    case year
    case month
}

public extension WZPeriod {
    var granularity: WZPeriodGranularity {
        switch self {
        case .all:
            return .all
        case .year:
            return .year
        case .yearMonth:
            return .month
        }
    }
}

public extension WZPeriod {
    func isBefore(_ other: WZPeriod) -> Bool? {
        guard granularity == other.granularity else {
            return nil
        }

        switch (self, other) {
        case let (.year(y1), .year(y2)):
            return y1 < y2

        case let (.yearMonth(y1, m1), .yearMonth(y2, m2)):
            return (y1, m1) < (y2, m2)

        default:
            return nil
        }
    }
}

public extension WZPeriod {

    func compare(_ other: WZPeriod) -> ComparisonResult? {

        // all 은 비교 대상이 아님 (정책적으로 nil)
        guard
            let y1 = self.yearComponent,
            let y2 = other.yearComponent
        else {
            return nil
        }

        // 1️⃣ 연 먼저 비교
        if y1 != y2 {
            return y1 < y2 ? .orderedAscending : .orderedDescending
        }

        // 2️⃣ 연이 같고, 둘 다 월을 가진 경우만 월 비교
        if
            let (_, m1) = self.yearMonthComponent,
            let (_, m2) = other.yearMonthComponent
        {
            if m1 != m2 {
                return m1 < m2 ? .orderedAscending : .orderedDescending
            }
        }

        // 3️⃣ 여기까지 오면 같은 연 (월은 같거나 무시)
        return .orderedSame
    }
    
    func isBefore(_ other: WZPeriod) -> Bool {
        compare(other) == .orderedAscending
    }

    func isAfter(_ other: WZPeriod) -> Bool {
        compare(other) == .orderedDescending
    }
}
