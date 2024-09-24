////
////  Test.swift
////  Trooute
////
////  Created by Muhammad Zafar on 2024-09-23.
////
//
//import SwiftUI
//
//struct TripPlannerView: View {
//    @State private var fromLocation: String = ""
//    @State private var toLocation: String = ""
//    @State private var selectedDate = Date()
//    @State private var selectedTime = Date()
//
//    var body: some View {
//        VStack(spacing: 20) {
//            // From and To Fields
//            VStack(alignment: .leading, spacing: 10) {
//                HStack(alignment: .top) {
//                    // Custom Dotted Line and From Pin
//                    VStack {
//                        Circle() // First Circle in "From"
//                            .strokeBorder(Color.blue, lineWidth: 1)
//                            .background(Circle().fill(Color.white))
//                            .frame(width: 12, height: 12)
//                        
//                        Circle() // Second Circle in "From"
//                            .fill(Color.blue)
//                            .frame(width: 6, height: 6)
//                            .padding(.top, -6)
//                        
//                        Spacer().frame(height: 10)
//                        
//                        // Dotted Line
//                        DashedLine()
//                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
//                            .frame(height: 20)
//                        
//                        Spacer().frame(height: 10)
//                        
//                        // "Where to" Pin Icon
//                        Image(systemName: "mappin.and.ellipse")
//                            .foregroundColor(.blue)
//                            .frame(width: 12, height: 12)
//                    }
//                    
//                    VStack(alignment: .leading, spacing: 10) {
//                        // "From" TextField
//                        VStack(alignment: .leading, spacing: 4) {
//                            Text("From")
//                                .font(.headline)
//                                .foregroundColor(.blue)
//                            TextField("Enter starting location", text: $fromLocation)
//                                .padding()
//                                .background(Color(.systemGray6))
//                                .cornerRadius(8)
//                        }
//
//                        // "Where to" TextField
//                        VStack(alignment: .leading, spacing: 4) {
//                            Text("Where to")
//                                .font(.headline)
//                                .foregroundColor(.blue)
//                            TextField("Enter destination location", text: $toLocation)
//                                .padding()
//                                .background(Color(.systemGray6))
//                                .cornerRadius(8)
//                        }
//                    }
//                }
//            }
//            .padding()
//
//            // Date Picker Section
//            VStack(alignment: .leading, spacing: 10) {
//                Text("Choose the date of the trip")
//                    .font(.headline)
//                    .foregroundColor(Color(hex: "3D4D9B"))
//                
//                // Custom Calendar View with Weekdays Header
//                CustomCalendarView(selectedDate: $selectedDate)
//            }
//            .padding()
//
//            // Time Picker Section
//            VStack(alignment: .leading, spacing: 10) {
//                Text("Specify the departure time")
//                    .font(.headline)
//                    .foregroundColor(Color(hex: "3D4D9B"))
//                
//                DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
//                    .datePickerStyle(CompactDatePickerStyle())
//                    .labelsHidden()
//                    .padding()
//                    .background(Color(.systemGray6))
//                    .cornerRadius(8)
//            }
//            .padding()
//
//            Spacer()
//        }
//        .padding()
//    }
//}
//
//// Custom Calendar View with Weekdays Header
//struct CustomCalendarView: View {
//    @Binding var selectedDate: Date
//    @State private var currentMonth = 0
//    
//    let calendar = Calendar.current
//    let dateFormatter = DateFormatter()
//    
//    var body: some View {
//        VStack {
//            // Month navigation
//            HStack {
//                // Hide left chevron if current month
//                if !isCurrentMonth() {
//                    Button(action: {
//                        currentMonth -= 1
//                    }) {
//                        Image(systemName: "chevron.left")
//                            .foregroundColor(.blue)
//                    }
//                }
//                
//                Spacer()
//
//                Text(getCurrentMonthYear())
//                    .font(.title2)
//                    .bold()
//                
//                Spacer()
//                
//                Button(action: {
//                    currentMonth += 1
//                }) {
//                    Image(systemName: "chevron.right")
//                        .foregroundColor(.blue)
//                }
//            }
//            .padding()
//
//            // Weekday headers
//            HStack {
//                ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
//                    Text(day)
//                        .frame(maxWidth: .infinity)
//                        .font(.headline)
//                        .foregroundColor(.gray)
//                }
//            }
//            .padding(.bottom, 5)
//            
//            // Calendar Grid
//            let days = generateDaysInMonth()
//            
//            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
//                ForEach(days, id: \.self) { day in
//                    Text(day)
//                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 30)
//                        .background(isSelected(day) ? Color.green : (isSelectable(day) ? Color.clear : Color.gray.opacity(0.3))) // Updated
//                        .cornerRadius(6)
//                        .onTapGesture {
//                            if isSelectable(day) {
//                                selectDate(day: day)
//                            }
//                        }
//                        .foregroundColor(isSelectable(day) ? .black : .gray)
//                }
//            }
//            .padding(.top, 10)
//        }
//    }
//    
//    func getCurrentMonthYear() -> String {
//        let date = Calendar.current.date(byAdding: .month, value: currentMonth, to: Date())!
//        dateFormatter.dateFormat = "MMMM yyyy"
//        return dateFormatter.string(from: date)
//    }
//    
//    func generateDaysInMonth() -> [String] {
//        let date = Calendar.current.date(byAdding: .month, value: currentMonth, to: Date())!
//        let range = Calendar.current.range(of: .day, in: .month, for: date)!
//        return range.map { String($0) }
//    }
//    
//    func isToday(_ day: String) -> Bool {
//        let today = Calendar.current.component(.day, from: Date())
//        let selectedMonth = Calendar.current.date(byAdding: .month, value: currentMonth, to: Date())!
//        return day == String(today) && Calendar.current.isDate(selectedMonth, equalTo: Date(), toGranularity: .month)
//    }
//    
//    func isSelectable(_ day: String) -> Bool {
//        let dayInt = Int(day) ?? 0
//        let today = Calendar.current.component(.day, from: Date())
//        let selectedMonth = Calendar.current.date(byAdding: .month, value: currentMonth, to: Date())!
//        
//        if Calendar.current.isDate(selectedMonth, equalTo: Date(), toGranularity: .month) {
//            return dayInt >= today
//        } else {
//            return true
//        }
//    }
//    
//    func isCurrentMonth() -> Bool {
//        let date = Calendar.current.date(byAdding: .month, value: currentMonth, to: Date())!
//        return Calendar.current.isDate(date, equalTo: Date(), toGranularity: .month)
//    }
//    
//    // Check if the given day is the selected day
//    func isSelected(_ day: String) -> Bool {
//        let dayInt = Int(day) ?? 0
//        let selectedComponents = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
//        let currentMonthComponents = Calendar.current.date(byAdding: .month, value: currentMonth, to: Date())!
//        let currentMonthDay = Calendar.current.dateComponents([.year, .month, .day], from: currentMonthComponents)
//        
//        return selectedComponents.year == currentMonthDay.year &&
//            selectedComponents.month == currentMonthDay.month &&
//            selectedComponents.day == dayInt
//    }
//    
//    func selectDate(day: String) {
//        let dayInt = Int(day) ?? 1
//        var components = Calendar.current.dateComponents([.year, .month], from: Calendar.current.date(byAdding: .month, value: currentMonth, to: Date())!)
//        components.day = dayInt
//        
//        if let date = Calendar.current.date(from: components) {
//            selectedDate = date
//        }
//    }
//}
//
//#Preview {
//    TripPlannerView()
//}


import SwiftUI
struct ExpandableCellView: View {
    @State private var expandedCells: Set<Int> = []

    var body: some View {
        List(0..<5) { index in
            VStack(alignment: .leading) {
                HStack {
                    Text("Cell Title \(index + 1)")  // Replace with your actual cell title
                        .font(.headline)
                    Spacer()
                    Button(action: {
                        // Toggle expand/collapse state
                        if expandedCells.contains(index) {
                            expandedCells.remove(index)
                        } else {
                            expandedCells.insert(index)
                        }
                    }) {
                        Image(systemName: expandedCells.contains(index) ? "chevron.up" : "chevron.down")
                            .foregroundColor(.gray)
                    }
                }
                .padding()

                if expandedCells.contains(index) {
                    // Expanded content goes here (replace with your actual content)
                    Text("This is the expanded content for Cell \(index + 1). Replace this with your dummy text.")
                        .padding([.leading, .bottom, .trailing])
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .background(Color.white)  // Optional: add background color for the cell
            .cornerRadius(8)
            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)  // Optional: add shadow for better UI
            .padding(.vertical, 5)
        }
        .listStyle(PlainListStyle())  // Use plain list style to make it look cleaner
    }
}

struct ExpandableCellView_Previews: PreviewProvider {
    static var previews: some View {
        ExpandableCellView()
    }
}
