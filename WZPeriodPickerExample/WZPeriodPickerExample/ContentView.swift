//
//  ContentView.swift
//  WZPeriodPickerExample
//
//  Created by Jaehoon Lee on 1/29/26.
//

import SwiftUI
import WZPeriodPicker

struct ContentView: View {
    @State private var selectedPeriod = WZPeriod(yearMonth: Date())!
    
    // 데이터 범위 설정
    let startDate = WZPeriod(year: 2023, month: 5)
    let endDate = WZPeriod(yearMonth: Date())!
    
    var body: some View {
        VStack(spacing: 20) {
            Text("\(selectedPeriod.description)")
                .font(.headline)
            Text("During : \(startDate.description) ~ \(endDate.description)")

            
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
}

extension ContentView {
    private var canMovePrevious: Bool {
        true
    }
    
    private var canMoveNext: Bool {
        true
    }
    
    private func moveToPrevious() {
        selectedPeriod = selectedPeriod.previous()
    }
    
    private func moveToNext() {
        selectedPeriod = selectedPeriod.next()
    }
}

#Preview {
    ContentView()
}
