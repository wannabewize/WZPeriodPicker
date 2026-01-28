//
//  WZPeriodPickerTests 2.swift
//  WZPeriodPicker
//
//  Created by Jaehoon Lee on 1/29/26.
//


import Testing
@testable import WZPeriodPicker

@Suite("YearMonth 로직 테스트")
struct YearMonthTests {

    @Test("월 단위 이동 테스트 (연도 경계 포함)", arguments: [
        // (기준 연, 기준 월, 이동할 월 수, 기대하는 연, 기대하는 월)
        (2024, 11, 2, 2025, 1),
        (2024, 12, 1, 2025, 1),
        (2024, 2, -2, 2023, 12),
        (2024, 1, -13, 2022, 12),
        (2024, 1, 12, 2025, 1)
    ])
    func testAddingMonths(year: Int, month: Int, offset: Int, expectedYear: Int, expectedMonth: Int) {
        let base = YearMonth(year: year, month: month)
        let result = base.adding(months: offset)
        
        #expect(result.year == expectedYear)
        #expect(result.month == expectedMonth)
    }

    @Test("선후 관계 비교 테스트")
    func testComparison() {
        let early = YearMonth(year: 2023, month: 12)
        let late = YearMonth(year: 2024, month: 1)
        
        #expect(early < late)
        #expect(late > early)
        #expect(early != late)
    }

    @Test("편의 메서드 확인 (Next/Previous)")
    func testConvenienceMethods() {
        let dec = YearMonth(year: 2023, month: 12)
        #expect(dec.nextMonth() == YearMonth(year: 2024, month: 1))
        
        let jan = YearMonth(year: 2024, month: 1)
        #expect(jan.previousMonth() == YearMonth(year: 2023, month: 12))
    }
}
