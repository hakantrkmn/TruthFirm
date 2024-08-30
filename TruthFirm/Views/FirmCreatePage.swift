import SwiftUI

struct FirmCreatePage: View {
    var body: some View {
        VStack {
            Text("Create a New Firm")
                .font(.largeTitle)
                .padding()

            // Add your form fields here for firm creation

            Spacer()
        }
        .navigationTitle("Create Firm")
    }
}

struct FirmCreatePage_Previews: PreviewProvider {
    static var previews: some View {
        FirmCreatePage()
    }
}
