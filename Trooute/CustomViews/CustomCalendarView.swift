//
//  CustomCalendarView.swift
//  Trooute
//
//  Created by Muhammad Zafar on 2024-09-22.
//
import SwiftUI

struct CustomCalendarView: View {
    @Binding var selectedDate: Date
    @State private var currentMonth = 0
    
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    var body: some View {
        VStack {
            // Month navigation
            HStack {
                // Hide left chevron if current month
                if !isCurrentMonth() {
                    Button(action: {
                        updateCurrentMonth(plus: false)
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                    }
                }
                
                Spacer()

                Text(getCurrentMonthYear())
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Button(action: {
                    updateCurrentMonth(plus: true)
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.blue)
                }
            }
            .padding()

            // Weekday headers
            HStack {
                ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom, 5)
            
            // Calendar Grid
            let days = generateDaysInMonth()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .frame(width: 35, height: 35)
                        .background(isSelected(day) ? Color.green :  Color.clear)
                        .cornerRadius(17)
                        .onTapGesture {
                            if isSelectable(day) {
                                selectDate(day: day)
                            }
                        }
                        .foregroundColor(isSelectable(day) ? .black : .gray)
                }
            }
            .padding(.top, 10)
        }
    }
    
    private func updateCurrentMonth(plus: Bool) {
        if plus {
            currentMonth += 1
        } else {
            currentMonth -= 1
        }
       
    }
    
    func getCurrentMonthYear() -> String {
        let date = Calendar.current.date(byAdding: .month, value: currentMonth, to: Date())!
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func generateDaysInMonth() -> [String] {
        let date = Calendar.current.date(byAdding: .month, value: currentMonth, to: Date())!
        let range = Calendar.current.range(of: .day, in: .month, for: date)!
        return range.map { String($0) }
    }
    
    func isToday(_ day: String) -> Bool {
        let today = Calendar.current.component(.day, from: Date())
        let selectedMonth = Calendar.current.date(byAdding: .month, value: currentMonth, to: Date())!
        return day == String(today) && Calendar.current.isDate(selectedMonth, equalTo: Date(), toGranularity: .month)
    }
    
    func isSelectable(_ day: String) -> Bool {
        let dayInt = Int(day) ?? 0
        let today = Calendar.current.component(.day, from: Date())
        let selectedMonth = Calendar.current.date(byAdding: .month, value: currentMonth, to: Date())!
        
        if Calendar.current.isDate(selectedMonth, equalTo: Date(), toGranularity: .month) {
            return dayInt >= today
        } else {
            return true
        }
    }
    
    func isCurrentMonth() -> Bool {
        let date = Calendar.current.date(byAdding: .month, value: currentMonth, to: Date())!
        return Calendar.current.isDate(date, equalTo: Date(), toGranularity: .month)
    }
    
    // Check if the given day is the selected day
    func isSelected(_ day: String) -> Bool {
        let dayInt = Int(day) ?? 0
        let selectedComponents = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
        let currentMonthComponents = Calendar.current.date(byAdding: .month, value: currentMonth, to: Date())!
        let currentMonthDay = Calendar.current.dateComponents([.year, .month, .day], from: currentMonthComponents)
        
        return selectedComponents.year == currentMonthDay.year &&
            selectedComponents.month == currentMonthDay.month &&
            selectedComponents.day == dayInt
    }
    
    func selectDate(day: String) {
        let dayInt = Int(day) ?? 1
        var components = Calendar.current.dateComponents([.year, .month], from: Calendar.current.date(byAdding: .month, value: currentMonth, to: Date())!)
        components.day = dayInt
        
        if let date = Calendar.current.date(from: components) {
            selectedDate = date
        }
    }
}

#Preview {
    CustomCalendarView(selectedDate: .constant(Date()))
}

