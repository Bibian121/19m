//
//  ViewController.swift
//  19m
//
//  Created by Matilda Davydov on 26.10.2022.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    

    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var birthText: UITextField!
    
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var occupationText: UITextField!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var lastnameText: UITextField!
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryText: UITextField!
    
    @IBAction func buttonAlomofire(_ sender: Any) {
        sendReguestWithAlomofire()
    }
    @IBOutlet weak var resultLabel: UILabel!
    @IBAction func buttonS(_ sender: Any) {
        setupPostMethod()
    }
    
    func sendReguestWithAlomofire() {
        let birthtext = self.birthText.text ?? ""
        let occupationtext = self.occupationText.text ?? ""
        let nametext = self.nameText.text ?? ""
        let lastnametext = self.lastnameText.text ?? ""
        let coutrytext = self.countryText.text ?? ""
        
      //  let item = Item(birth: 2002, occupation: occupationtext, name: nametext, lastname: lastnametext, country: coutrytext)
        
        AF.request(
            "https://jsonplaceholder.typicode.com/posts",
            method: .post,
            parameters: [birthtext,occupationtext,nametext,lastnametext,coutrytext],
            encoder: JSONParameterEncoder.default
        ).response { [weak self] response in
            guard response.error == nil else {
                self?.displayFailure()
                return
            }
            self?.displaySuccess()
            debugPrint(response)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        sendReguestWithAlomofire()
        setupPostMethod()
        birthText.delegate = self
    }
        
    private func displaySuccess() {
        resultLabel.textColor = .systemGreen
        resultLabel.text = "Success"
    }

    private func displayFailure() {
        resultLabel.textColor = .systemRed
        resultLabel.text = "Failure"
    }
    
    func setupPostMethod() {
        guard let birthtext = self.birthText.text else { return }
        guard let occupationtext = self.occupationText.text else { return }
        guard let nametext = self.nameText.text else { return }
        guard let lastnametext = self.lastnameText.text else { return }
        guard let coutrytext = self.countryText.text else { return }
        
        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
        request.httpMethod = "POST"
        let parameters: [ String : Any ] = [
            "birthtext": birthtext,
            "occupationtext": occupationtext,
            "nametext": nametext,
            "lastnametext": lastnametext,
            "coutrytext": coutrytext
        ]
        request.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let data = data else {
                if error == nil {
                    print(error?.localizedDescription ?? "Unknown Error")
                }
                return
            }
            
            if let response = response as? HTTPURLResponse {
                guard (200 ... 209) ~= response.statusCode else {
                    print("Status code :- \(response.statusCode)")
                    print(response)
                    return
                }
            }
            
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            }catch let error{
                print(error.localizedDescription)
            }
        }.resume()
    }
}

extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if (birthText.text?.contains("+7"))! {
                guard NSCharacterSet(charactersIn: "+0123456789").isSuperset(of: NSCharacterSet(charactersIn: string) as CharacterSet) else {
                return false
                   }
                }
                return true
    }
}


