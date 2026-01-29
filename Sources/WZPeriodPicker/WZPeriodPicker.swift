import SwiftUI

public struct WZPeriodPicker: View {
    @Binding var selectedYear: Int?
    @Binding var selectedMonth: Int?
    @Binding var selectedPeriod: WZPeriod
    
    let from: WZYearMonth
    let to: WZYearMonth
    let allOptionText: String
    
    public init(
        selectedYear: Binding<Int?>,
        selectedMonth: Binding<Int?>,
        selectedPeriod: Binding<WZPeriod>,
        from: WZYearMonth,
        to: WZYearMonth,
        allOptionText: String = "전체"
    ) {
        self._selectedYear = selectedYear
        self._selectedMonth = selectedMonth
        self._selectedPeriod = selectedPeriod
        self.from = from
        self.to = to
        self.allOptionText = allOptionText
    }
    
    public var body: some View {
        HStack(spacing: 8) {
            // 연도 선택
            yearPicker
            
            // 월 선택 (연도가 선택된 경우에만 노출하거나 비활성화)
            if selectedYear != nil {
                monthPicker
            }
            
            // selectedPeriod 기반 선택기 (추가 표시)
            Divider()
                .frame(height: 28)

            VStack(spacing: 4) {
                Text("Period 기반")
                    .font(.caption)
                periodYearPicker
                if periodSelectedYear != nil {
                    periodMonthPicker
                }
            }
        }
    }
    
    private var yearPicker: some View {
        Picker("Year", selection: $selectedYear) {
            Text(allOptionText).tag(nil as Int?)
            ForEach(availableYears, id: \.self) { year in
                Text("\(String(year))년").tag(year as Int?)
            }
        }
        .pickerStyle(.menu)
        .onChange(of: selectedYear) { _, _ in
            // 연도가 바뀌거나 전체로 돌아가면 월 선택 초기화
            selectedMonth = nil
        }
    }
    
    private var monthPicker: some View {
        Picker("Month", selection: $selectedMonth) {
            Text(allOptionText).tag(nil as Int?)
            ForEach(availableMonths(for: selectedYear), id: \.self) { month in
                Text("\(month)월").tag(month as Int?)
            }
        }
        .pickerStyle(.menu)
    }

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
            switch selectedPeriod {
            case .all:
                if let y = newYear {
                    selectedPeriod = .year(y)
                } else {
                    selectedPeriod = .all
                }
            case .year(_):
                if let y = newYear {
                    selectedPeriod = .year(y)
                } else {
                    selectedPeriod = .all
                }
            case .yearMonth(_, let m):
                if let y = newYear {
                    selectedPeriod = .yearMonth(year: y, month: m)
                } else {
                    selectedPeriod = .all
                }
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
    @Previewable @State var year: Int? = 2024
    @Previewable @State var month: Int? = nil // 2024년 전체 선택 상태
    @Previewable @State var period: WZPeriod = .yearMonth(year: 2020, month: 10)

    WZPeriodPicker(
        selectedYear: $year,
        selectedMonth: $month,
        selectedPeriod: $period,
        from: WZYearMonth(year: 2020, month: 1),
        to: WZYearMonth.current
    )
}
