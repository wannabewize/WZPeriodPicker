import SwiftUI

public struct WZPeriodPicker: View {
    @Binding var period: WZPeriod

    var minimum: WZYearMonth { period.minimum }
    var maximum: WZYearMonth { period.maximum }

    let allOptionText: String
    let allowAllPeriod: Bool
    let allowYearAll: Bool

    public init(
        period: Binding<WZPeriod>,
        allowAllPeriod: Bool = false,
        allowYearAll: Bool = false,
        allOptionText: String = "all"
    ) {
        self._period = period
        self.allOptionText = allOptionText
        self.allowAllPeriod = allowAllPeriod
        self.allowYearAll = allowYearAll
    }

    public var body: some View {
        HStack(spacing: 8) {
            // Period 기반 선택만 노출
            periodYearPicker
            if periodSelectedYear != nil {
                periodMonthPicker
            }
        }
        .fixedSize(horizontal: true, vertical: false)
    }

    // 기존 year/month 바인딩 대신 period에서 파생한 바인딩을 사용
    private var periodSelectedYear: Int? {
        switch period.selected {
        case .all: return nil
        case .year(let y): return y
        case .yearMonth(let y, _): return y
        }
    }

    private var periodSelectedMonth: Int? {
        switch period.selected {
        case .yearMonth(_, let m): return m
        default: return nil
        }
    }

    private var periodYearBinding: Binding<Int?> {
        Binding(
            get: { periodSelectedYear },
            set: { newYear in
                // Update period based on new year selection while preserving month when possible
                if let y = newYear {
                    if let m = periodSelectedMonth {
                        period.selected = .yearMonth(year: y, month: m)
                    } else {
                        period.selected = .year(y)
                    }
                } else {
                    period.selected = .all
                }
            })
    }

    private var periodMonthBinding: Binding<Int?> {
        Binding(
            get: { periodSelectedMonth },
            set: { newMonth in
                let currentYear = periodSelectedYear
                switch (currentYear, newMonth) {
                case (nil, nil):
                    period.selected = .all
                case (let y?, nil):
                    period.selected = .year(y)
                case (let y?, let m?):
                    period.selected = .yearMonth(year: y, month: m)
                case (nil, let m?):
                    // no year selected but month set -> pick earliest year in range
                    let y = minimum.yearComponent!
                    period.selected = .yearMonth(year: y, month: m)
                }
            })
    }

    private var periodYearPicker: some View {
        Picker("Period Year", selection: periodYearBinding) {
            if allowAllPeriod {
                Text(allOptionText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .tag(nil as Int?)
            }
            ForEach(availableYears, id: \.self) { year in
                Text(formattedYear(year))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .tag(year as Int?)
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
            if allowYearAll {
                Text(allOptionText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .tag(nil as Int?)
            }
            ForEach(availableMonths(for: periodSelectedYear), id: \.self) { month in
                Text(localizedMonthName(for: month))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .tag(month as Int?)
            }
        }
        .pickerStyle(.menu)
    }

    // Use system locale for month names and year formatting
    private func localizedMonthName(for month: Int) -> String {
        guard (1...12).contains(month) else { return "\(month)" }
        let df = DateFormatter()
        df.locale = Locale.current
        let symbols = df.standaloneMonthSymbols
        return symbols != nil ? symbols![month - 1] : String(month)
    }

    private func formattedYear(_ year: Int) -> String {
        var comps = DateComponents()
        comps.year = year
        comps.month = 1
        guard let date = Calendar.current.date(from: comps) else { return String(year) }
        let df = DateFormatter()
        df.locale = Locale.current
        df.setLocalizedDateFormatFromTemplate("y")
        return df.string(from: date)
    }

    

    private var availableYears: [Int] {
        Array(minimum.yearComponent!...maximum.yearComponent!).reversed()
    }

    private func availableMonths(for year: Int?) -> [Int] {
        guard let year = year else { return [] }

        if year == minimum.yearComponent {
            let startMonth = minimum.monthComponent ?? 1
            return Array(startMonth...12).reversed()
        }

        if year == maximum.yearComponent {
            let endMonth = maximum.monthComponent ?? 12
            return Array(1...endMonth).reversed()
        }

        return Array(1...12).reversed()
    }
}

#Preview {
    @Previewable @State var period: WZPeriod = WZPeriod(
        selected: .yearMonth(year: 2020, month: 10),
        minimum: .yearMonth(year: 2020, month: 5),
        maximum: .now
    )

    WZPeriodPicker(
        period: $period
    )
}

 