import UIKit

func fsdf() async throws {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
    
    if let url = URL(string: "https://firestore.googleapis.com/v1/projects/wois-5152e/databases/(default)/documents/feedback") {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Content-Type", forHTTPHeaderField: "text/plain")
        
        // let date = dateFormatter.string(from: model.date) ?? ""
        
        let dictionary: [String: Any] = [
            "fields": [
                "text": [
                    "stringValue": "model.text"
                ],
                "userAuthId": [
                    "stringValue": "$var2"
                ],
                "userEmail": [
                    "stringValue": "$var2"
                ],
                "timestamp": [
                    "stringValue": "$var2"
                ]
            ]
        ]
      
        do {
            let dataOut = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            request.httpBody = dataOut
            
            print(String(data: request.httpBody!, encoding: .utf8)!)
            //print(request.httpBody)
            let (data, responce) = try await URLSession.shared.data(for: request)
            let stringResponse = String(data: data, encoding: .utf8)
           // let dictttt = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            print(responce.description, stringResponse)
        } catch {
            print(error.localizedDescription)
        }
        
    }
}
Task {
    try await fsdf()
}
