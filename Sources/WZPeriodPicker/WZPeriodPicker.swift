import SwiftUI

public struct WZPeriodPicker: View {
    @Binding var selectedYear: Int?
    @Binding var selectedMonth: Int?
    
    let from: YearMonth
    let to: YearMonth
    let allOptionText: String
    
    public init(
        selectedYear: Binding<Int?>,
        selectedMonth: Binding<Int?>,
        from: YearMonth,
        to: YearMonth,
        allOptionText: String = "전체"
    ) {
        self._selectedYear = selectedYear
        self._selectedMonth = selectedMonth
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
    
    WZPeriodPicker(
        selectedYear: $year,
        selectedMonth: $month,
        from: YearMonth(year: 2020, month: 1),
        to: YearMonth.current
    )
}
