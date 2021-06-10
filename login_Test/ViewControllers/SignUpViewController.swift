//
//  SignUpViewController.swift
//  portfolio
//
//  Created by 김은중 on 2021/06/10.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
       

    }
    
    func setUpElements() {
        // errorLabel 숨기기
        errorLabel.alpha = 0
        
        // 버튼 및 텍스트필드 스타일링
        Utilities.styleTextFiled(firstNameTextField)
        Utilities.styleTextFiled(lastNameTextField)
        Utilities.styleTextFiled(emailTextField)
        Utilities.styleTextFiled(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }
    
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
             return "모든 필드를 입력하세요."
        }
        
        // Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "암호가 8자 이상이고 특수 문자 및 숫자를 포함하고 있는지 확인하세요."
        }
        
        return nil
    }

    @IBAction func signUpTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            // 필드쪽에 에러 발생 시, 에러 메시지 보여주기
            showError(error!)
        }
        else {
            
            // 데이터의 정리된 버전 생성
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // 사용자 만들기
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                // 에러 체크
                if err != nil {
                    
                    // 사용자 생성 오류 메시지
                    self.showError("사용자 생성 오류")
                }
                else {
                    
                    // 사용자가 성공적으로 만들어지면, 이름과 성을 저장.
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["firstname":firstName, "lastname":lastName, "uid": result!.user.uid]) { (error) in
                        
                        if error != nil {
                            // 에러 메시지 보여주기
                            self.showError("사용자 데이터를 저장하는데 오류가 생겼습니다.")
                        }
                    }
                    
                    // 홈 화면으로 이동
                    self.transitionToHome()
                }
            }
            
            
            
        }
        
    }
    
    func showError(_ message: String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        
       let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
