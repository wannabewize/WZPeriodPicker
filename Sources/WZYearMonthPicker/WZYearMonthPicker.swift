import SwiftUI

public struct WZYearMonthPicker<Emblem: View>: View {
    @Binding var period: WZPeriod
    private let emblem: () -> Emblem

    @Environment(\.font) private var inheritedFont: Font?

    var minimum: WZYearMonth { period.minimum }
    var maximum: WZYearMonth { period.maximum }

    let allOptionText: String
    let allowAllPeriod: Bool
    let allowYearAll: Bool

    public init(
        period: Binding<WZPeriod>,
        allowAllPeriod: Bool = false,
        allowYearAll: Bool = false,
        allOptionText: String = "all",
        @ViewBuilder emblem: @escaping () -> Emblem = { EmptyView() }
    ) {
        self._period = period
        self.allOptionText = allOptionText
        self.allowAllPeriod = allowAllPeriod
        self.allowYearAll = allowYearAll
        self.emblem = emblem
    }

    public var body: some View {
        HStack(spacing: 8) {
            // optional emblem icon
            emblem()
                .frame(width: 20, height: 20)

            // Period 기반 선택만 노출
            periodYearPicker
            if periodSelectedYear != nil {
                periodMonthPicker
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        // Use Menu to allow per-item text modifiers and consistent label styling
        Menu {
            if allowAllPeriod {
                Button(action: { periodYearBinding.wrappedValue = nil }) {
                    Text(allOptionText)
                        .font(inheritedFont)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            ForEach(availableYears, id: \.self) { year in
                Button(action: { periodYearBinding.wrappedValue = year }) {
                    Text(formattedYear(year))
                        .font(inheritedFont)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        } label: {
            HStack(spacing: 6) {
                if let y = periodSelectedYear {
                    Text(formattedYear(y))
                        .font(inheritedFont)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                } else if allowAllPeriod {
                    Text(allOptionText)
                        .font(inheritedFont)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                } else {
                    Text("")
                }
                Image(systemName: "chevron.down")
            }
            .frame(maxWidth: .infinity)
        }
    }

    private var periodMonthPicker: some View {
        // Use a Menu instead of a Picker so item text modifiers (lineLimit, minimumScaleFactor)
        // are respected and we can constrain the label width.
        Menu {
            if allowYearAll {
                Button(action: { periodMonthBinding.wrappedValue = nil }) {
                    Text(allOptionText)
                        .font(inheritedFont)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            ForEach(availableMonths(for: periodSelectedYear), id: \.self) { month in
                Button(action: { periodMonthBinding.wrappedValue = month }) {
                    Text(localizedMonthName(for: month))
                        .font(inheritedFont)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        } label: {
            HStack(spacing: 6) {
                if let m = periodSelectedMonth {
                    Text(localizedMonthName(for: m))
                        .font(inheritedFont)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                } else if allowYearAll {
                    Text(allOptionText)
                        .font(inheritedFont)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                } else {
                    Text("")
                }
                Image(systemName: "chevron.down")
            }
            .frame(maxWidth: .infinity)
        }
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

    WZYearMonthPicker(
        period: $period
    ) {
        Image(systemName: "calendar")
            .foregroundStyle(.blue)
    }
}

 
