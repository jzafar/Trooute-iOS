import SwiftUI

import SwiftUI

struct UserCardView: View {
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 16) {
                // User Profile Image
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 75, height: 75)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                    .padding(1)
                
                VStack(alignment: .leading, spacing: 8) {
                    // User Name and Verified Icon
                    HStack {
                        Text("Not Provided")
                            .font(.headline)
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.blue)
                    }
                    
                    // Gender
                    Text("Gender")
                        .font(.subheadline)
                    
                    // Rating and Reviews Section
                    HStack {
                        HStack {
                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundColor(.yellow)
                            Text("0")
                                .font(.body)
                        }
                        
                        Text("(0)")
                            .font(.body)
                            .foregroundColor(Color.blue.opacity(0.7))
                    }
                    .padding(.top, 8)
                }
                
                Spacer()
                
                // Car Image
                Image(systemName: "car.fill")
                    .resizable()
                    .frame(width: 55, height: 55)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
                    .padding(1)
            }
            .padding()
            
            // Car Model and Registration Number
            HStack {
                Text("Not Provided")
                    .font(.headline)
                
                Text(" - ")
                    .font(.headline)
                    .foregroundColor(Color.blue.opacity(0.7))
                
                Text("Not Provided")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            .padding(.horizontal)
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
    }
}

struct UserCardView_Previews: PreviewProvider {
    static var previews: some View {
        UserCardView()
    }
}
