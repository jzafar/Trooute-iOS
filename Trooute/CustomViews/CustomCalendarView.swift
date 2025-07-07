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
                
                Button(action: {
                    updateCurrentMonth(plus: false)
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                        .padding(10) // makes the tap target bigger
                        .contentShape(Rectangle()) // ensures tap works in padded area
                }.buttonStyle(PlainButtonStyle())
                .disabled(currentMonth == 0)
                
                
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
                        .padding(10) // makes the tap target bigger
                        .contentShape(Rectangle()) // ensures tap works in padded area
                }.buttonStyle(PlainButtonStyle())
            }
            .padding()

            // Weekday headers
            HStack {
                ForEach(orderedWeekdays, id: \.self) { day in
                    Text(day.prefix(1)) // Show only first character like "M", "T", etc.
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
        }.background(Color.white)
    }
        // Dynamically ordered weekday symbols
    let orderedWeekdays: [String] = {
        var calendar = Calendar.current
        calendar.locale = Locale.current
        let symbols = calendar.shortStandaloneWeekdaySymbols
        let startIndex = calendar.firstWeekday - 1 // firstWeekday is 1-based
        return Array(symbols[startIndex...] + symbols[..<startIndex])
    }()
    
    private func updateCurrentMonth(plus: Bool) {
        if plus {
            currentMonth += 1
        } else if currentMonth > 0 {
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
        
        var calendar = Calendar.current
        calendar.locale = Locale.current
        
            // Find what weekday the 1st of the month falls on
        let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let weekday = calendar.component(.weekday, from: firstOfMonth)
        
            // Shift based on firstWeekday (e.g., Monday = 2 in Gregorian calendar)
        let shift = (weekday - calendar.firstWeekday + 7) % 7
        
        let days = range.map { String($0) }
        return Array(repeating: "", count: shift) + days
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
        var components = Calendar.current.dateComponents([.year, .month, .hour, .minute], from: Calendar.current.date(byAdding: .month, value: currentMonth, to: Date())!)
        components.day = dayInt
        
        if let date = Calendar.current.date(from: components) {
            selectedDate = date
        }
    }
}

#Preview {
    CustomCalendarView(selectedDate: .constant(Date()))
}

