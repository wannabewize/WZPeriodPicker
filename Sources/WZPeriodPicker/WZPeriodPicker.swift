import SwiftUI

public struct WZPeriodPicker: View {
    @Binding var selectedPeriod: WZPeriod
    
    let from: WZYearMonth
    let to: WZYearMonth
    let allOptionText: String
    
    public init(
        selectedPeriod: Binding<WZPeriod>,
        from: WZYearMonth,
        to: WZYearMonth,
        allOptionText: String = "전체"
    ) {
        self._selectedPeriod = selectedPeriod
        self.from = from
        self.to = to
        self.allOptionText = allOptionText
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            // Period 기반 선택만 노출
            periodYearPicker
            if periodSelectedYear != nil {
                periodMonthPicker
            }
        }
    }
    
    // 기존 year/month 바인딩 대신 period에서 파생한 바인딩을 사용

    // MARK: - Period-driven bindings & pickers

    private var periodSelectedYear: Int? {
        switch selectedPeriod {
        case .all: return nil
        case .year(let y): return y
        case .yearMonth(let y, _): return y
        }
    }

    private var periodSelectedMonth: Int? {
        switch selectedPeriod {
        case .yearMonth(_, let m): return m
        default: return nil
        }
    }

    private var periodYearBinding: Binding<Int?> {
        Binding(get: { periodSelectedYear }, set: { newYear in
            // Update period based on new year selection while preserving month when possible
            if let y = newYear {
                if let m = periodSelectedMonth {
                    selectedPeriod = .yearMonth(year: y, month: m)
                } else {
                    selectedPeriod = .year(y)
                }
            } else {
                selectedPeriod = .all
            }
        })
    }

    private var periodMonthBinding: Binding<Int?> {
        Binding(get: { periodSelectedMonth }, set: { newMonth in
            let currentYear = periodSelectedYear
            switch (currentYear, newMonth) {
            case (nil, nil):
                selectedPeriod = .all
            case (let y?, nil):
                selectedPeriod = .year(y)
            case (let y?, let m?):
                selectedPeriod = .yearMonth(year: y, month: m)
            case (nil, let m?):
                // no year selected but month set -> pick earliest year in range
                let y = from.year
                selectedPeriod = .yearMonth(year: y, month: m)
            }
        })
    }

    private var periodYearPicker: some View {
        Picker("Period Year", selection: periodYearBinding) {
            Text(allOptionText).tag(nil as Int?)
            ForEach(availableYears, id: \.self) { year in
                Text("\(String(year))년").tag(year as Int?)
            }
        }
        .pickerStyle(.menu)
        .onChange(of: periodSelectedYear) { _, _ in
            // when year changes via period picker, clear month selection
            // handled by binding setter above
        }
    }

    private var periodMonthPicker: some View {
        Picker("Period Month", selection: periodMonthBinding) {
            Text(allOptionText).tag(nil as Int?)
            ForEach(availableMonths(for: periodSelectedYear), id: \.self) { month in
                Text("\(month)월").tag(month as Int?)
            }
        }
        .pickerStyle(.menu)
    }
    
    private var availableYears: [Int] {
        Array(from.year...to.year).reversed()
    }
    
    private func availableMonths(for year: Int?) -> [Int] {
        guard let year = year else { return [] }
        
        let startMonth = (year == from.year) ? from.month : 1
        let endMonth = (year == to.year) ? to.month : 12
        
        return Array(startMonth...endMonth).reversed()
    }
}

#Preview {
    @Previewable @State var period: WZPeriod = .yearMonth(year: 2020, month: 10)

    WZPeriodPicker(
        selectedPeriod: $period,
        from: WZYearMonth(year: 2020, month: 1),
        to: WZYearMonth.current
    )
}
