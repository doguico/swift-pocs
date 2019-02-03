import Foundation

// credentials encoded in base64
let username = "myuser"
let password = "mypasswd"
let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
let base64LoginData = loginData.base64EncodedString()

// create the request
let url = URL(string: "http://myurl.com")!
var request = URLRequest(url: url)
request.httpMethod = "GET"
request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")

//making the request
let task = URLSession.shared.dataTask(with: request) { data, response, error in
    guard let data = data, error == nil else {
        print("\(error)")
        return
    }
    
    if let httpStatus = response as? HTTPURLResponse {
        // check status code returned by the http server
        print("status code = \(httpStatus.statusCode)")
        // process result
    }
}
task.resume()
