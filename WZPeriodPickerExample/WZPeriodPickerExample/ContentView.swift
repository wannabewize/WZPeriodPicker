//
//  ContentView.swift
//  WZPeriodPickerExample
//
//  Created by Jaehoon Lee on 1/29/26.
//

import SwiftUI
import WZPeriodPicker

struct ContentView: View {
    @State private var selectedYear: Int? = WZYearMonth.current.year
    @State private var selectedMonth: Int? = WZYearMonth.current.month
    @State private var selectedPeriod = WZPeriod(yearMonth: Date())!
    
    // 데이터 범위 설정
    let startDate = WZYearMonth(year: 2023, month: 1)
    let endDate = WZYearMonth.current
    
    var body: some View {
        VStack(spacing: 20) {
            Text("선택된 기간: \(displayText)")
                .font(.headline)
            Text("선택된 Period: \(selectedPeriod.description)")
                .font(.headline)

            
            HStack(spacing: 15) {
                // 이전 달 이동 버튼
                Button(action: moveToPrevious) {
                    Image(systemName: "chevron.left")
                        .padding(10)
                        .background(Color.secondary.opacity(0.1))
                        .clipShape(Circle())
                }
                .disabled(!canMovePrevious)
                
                // WZPeriodPicker 사용
                WZPeriodPicker(
                    selectedYear: $selectedYear,
                    selectedMonth: $selectedMonth,
                    selectedPeriod: $selectedPeriod,
                    from: startDate,
                    to: endDate
                )
                
                // 다음 달 이동 버튼
                Button(action: moveToNext) {
                    Image(systemName: "chevron.right")
                        .padding(10)
                        .background(Color.secondary.opacity(0.1))
                        .clipShape(Circle())
                }
                .disabled(!canMoveNext)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBackground)).shadow(radius: 2))
        }
        .padding()
    }
    
    // 선택된 기간을 문자열로 표시
    private var displayText: String {
        if let year = selectedYear, let month = selectedMonth {
            return "\(year)년 \(month)월"
        } else {
            return "전체"
        }
    }
}

extension ContentView {
    private var currentSelection: WZYearMonth? {
        guard let y = selectedYear, let m = selectedMonth else { return nil }
        return WZYearMonth(year: y, month: m)
    }
    
    private var canMovePrevious: Bool {
        guard let current = currentSelection else { return true }
        return current > startDate
    }
    
    private var canMoveNext: Bool {
        guard let current = currentSelection else { return true }
        return current < endDate
    }
    
    private func moveToPrevious() {
        // 현재 선택이 없으면(전체) 가장 최근(endDate)으로, 있으면 이전 달로 이동
        let target = currentSelection?.previousMonth() ?? endDate
        if target >= startDate {
            updateSelection(to: target)
        }
        
        selectedPeriod = selectedPeriod.previous()
    }
    
    private func moveToNext() {
        // 현재 선택이 없으면(전체) 가장 과거(startDate)로, 있으면 다음 달로 이동
        let target = currentSelection?.nextMonth() ?? startDate
        if target <= endDate {
            updateSelection(to: target)
        }
        
        selectedPeriod = selectedPeriod.next()
    }
    
    private func updateSelection(to ym: WZYearMonth) {
        selectedYear = ym.year
        selectedMonth = ym.month
    }
}

#Preview {
    ContentView()
}
