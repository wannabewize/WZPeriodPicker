import Testing
@testable import WZPeriodPicker

@Suite("WZPeriod 동작 테스트")
struct WZPeriodTests {

    @Test(".all 은 next/previous 시 변하지 않음")
    func testAll() {
        let p = WZPeriod.all
        #expect(p.next() == .all)
        #expect(p.previous() == .all)
    }

    @Test("연 단위 next/previous")
    func testYear() {
        let p = WZPeriod.year(2020)
        #expect(p.next() == .year(2021))
        #expect(p.previous() == .year(2019))
    }

    @Test("월 단위 단순 증감")
    func testYearMonthSimple() {
        let p = WZPeriod.yearMonth(year: 2020, month: 5)
        #expect(p.next() == .yearMonth(year: 2020, month: 6))
        #expect(p.previous() == .yearMonth(year: 2020, month: 4))
    }

    @Test("월 단위 연 경계에서 래핑")
    func testYearMonthWrap() {
        let endOfYear = WZPeriod.yearMonth(year: 2020, month: 12)
        #expect(endOfYear.next() == .yearMonth(year: 2021, month: 1))

        let startOfYear = WZPeriod.yearMonth(year: 2020, month: 1)
        #expect(startOfYear.previous() == .yearMonth(year: 2019, month: 12))
    }
}
