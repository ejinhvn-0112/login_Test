//
//  LoginViewController.swift
//  portfolio
//
//  Created by 김은중 on 2021/06/10.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
    }
    
    func setUpElements() {
        // error Label 숨기기
        errorLabel.alpha = 0
        
        // 버튼 및 텍스트필드 스타일링
        Utilities.styleTextFiled(emailTextField)
        Utilities.styleTextFiled(passwordTextField)
        Utilities.styleFilledButton(loginButton)
    }
    
    

    @IBAction func loginTapped(_ sender: Any) {
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 사용자 로그인
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // 로그인 불가
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                
                let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
        
        
    }
}
