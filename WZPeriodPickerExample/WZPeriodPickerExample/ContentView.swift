//
//  ContentView.swift
//  WZPeriodPickerExample
//
//  Created by Jaehoon Lee on 1/29/26.
//

import SwiftUI
import WZPeriodPicker

struct ContentView: View {
    @State private var period1 = WZPeriod(
        selected: .now,
        minimum: .yearMonth(year: 2023, month: 5),
        maximum: .yearMonth(year: 2026, month: 10)
    )
    
    @State private var period2 = WZPeriod(
        selected: .year(2025),
        minimum: .yearMonth(year: 2023, month: 5),
        maximum: .yearMonth(year: 2026, month: 10)
    )
    
    @State private var period3 = WZPeriod(
        selected: .all,
        minimum: .yearMonth(year: 2023, month: 5),
        maximum: .yearMonth(year: 2026, month: 10)
    )

    
    var body: some View {
        VStack(spacing: 20) {
            Text("hello").font(.title)
            // System locale & localization information (also printed to console)
            VStack(alignment: .leading, spacing: 4) {
                Text("Locale: \(Locale.current.identifier)")
                    .font(.body)
                    .foregroundColor(.secondary)
            }

            VStack(spacing: 8) {
                Text("without all selection").font(.headline)
                Text("During : \(period1.minimum.description) ~ \(period1.maximum.description)").font(.subheadline)
                Text("Selected :\(period1.selected.description)").font(.subheadline)
                
                HStack(spacing: 15) {
                    // 이전 달 이동 버튼
                    Button(action: { period1.moveToPreviousIfPossible() }) {
                        Image(systemName: "chevron.left")
                            .padding(10)
                            .background(Color.secondary.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .disabled(!period1.canMovePrevious())
                    
                    // WZPeriodPicker 사용
                    WZPeriodPicker(period: $period1)
                    
                    // 다음 달 이동 버튼
                    Button(action: { period1.moveToNextIfPossible() }) {
                        Image(systemName: "chevron.right")
                            .padding(10)
                            .background(Color.secondary.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .disabled(!period1.canMoveNext())
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBackground)).shadow(radius: 2))
            
            VStack(spacing: 8) {
                Text("allow all year").font(.headline)
                Text("During : \(period2.minimum.description) ~ \(period2.maximum.description)")
                    .font(.subheadline)
                Text("Selected :\(period2.selected.description)")
                    .font(.subheadline)
                
                HStack(spacing: 15) {
                    // 이전 달 이동 버튼
                    Button(action: { period2.moveToPreviousIfPossible() }) {
                        Image(systemName: "chevron.left")
                            .padding(10)
                            .background(Color.secondary.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .disabled(!period2.canMovePrevious())
                    
                    // WZPeriodPicker 사용
                    WZPeriodPicker(period: $period2, allowAllPeriod: false, allowYearAll: true)
                    
                    // 다음 달 이동 버튼
                    Button(action: { period2.moveToNextIfPossible() }) {
                        Image(systemName: "chevron.right")
                            .padding(10)
                            .background(Color.secondary.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .disabled(!period2.canMoveNext())
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBackground)).shadow(radius: 2))
            
            VStack(spacing: 8) {
                Text("allow all period, allow all year").font(.headline)
                Text("During : \(period3.minimum.description) ~ \(period3.maximum.description)")
                    .font(.subheadline)
                Text("Selected :\(period3.selected.description)")
                    .font(.subheadline)
                
                HStack(spacing: 15) {
                    // 이전 달 이동 버튼
                    Button(action: { period3.moveToPreviousIfPossible() }) {
                        Image(systemName: "chevron.left")
                            .padding(10)
                            .background(Color.secondary.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .disabled(!period3.canMovePrevious())
                    
                    // WZPeriodPicker 사용
                    WZPeriodPicker(period: $period3, allowAllPeriod: true, allowYearAll: true)
                    
                    // 다음 달 이동 버튼
                    Button(action: { period3.moveToNextIfPossible() }) {
                        Image(systemName: "chevron.right")
                            .padding(10)
                            .background(Color.secondary.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .disabled(!period3.canMoveNext())
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBackground)).shadow(radius: 2))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}
