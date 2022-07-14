//
//  WelcomeViewController.swift
//  ShopOnlineUdem
//
//  Created by admin on 06.07.2022.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView

class WelcomeViewController: UIViewController {
    
    //MARK: - IBOutlets

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var resendButtonOutlet: UIButton!
    
    //MARK: - Vars
     
     let hud = JGProgressHUD(style: .dark)
     var activityIdicator: NVActivityIndicatorView?
    
    //MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIdicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60.0, height: 60.0), type: .ballPulse, color: #colorLiteral(red: 0.9998469949, green: 0.4941213727, blue: 0.4734867811, alpha: 1.0), padding: nil)

    }
    
    //MARK: - IBActions

    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismissView()
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        print("login")

        if textFieldsHaveText() {
                  
                  loginUser()
              } else {
                  hud.textLabel.text = "Заполните все поля"
                  hud.indicatorView = JGProgressHUDErrorIndicatorView()
                  hud.show(in: self.view)
                  hud.dismiss(afterDelay: 2.0)
              }

    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        print("registr")
        if textFieldsHaveText() {
            
            registerUser()
        } else {
            hud.textLabel.text = "Заполните все поля"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }

    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        print("forgot")
        
        if emailTextField.text != "" {
                  resetThePassword()
              } else {
                  hud.textLabel.text = "Пожалуйста, введите адрес электронной почты!"
                  hud.indicatorView = JGProgressHUDErrorIndicatorView()
                  hud.show(in: self.view)
                  hud.dismiss(afterDelay: 2.0)
              }
    }
    
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
        print("resend")
        
        MUser.resendVerificationEmail(email: emailTextField.text!) { (error) in
            
            print("error resending email", error?.localizedDescription)
        }
    }
    
    
    //MARK: - Login User
    
    private func loginUser() {
        
        showLoadingIdicator()
        
        MUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
            
            if error == nil {
                
                if  isEmailVerified {
                    self.dismissView()
                    print("Электронная почта подтверждена")
                } else {
                    self.hud.textLabel.text = "Пожалуйста, подтвердите ваш электронной адрес!"
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                    self.resendButtonOutlet.isHidden = false
                }
                
            } else {
                print("error loging in the iser", error!.localizedDescription)
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
            
            
            self.hideLoadingIdicator()
        }
        
    }
    
    //MARK: - Register User

    
    private func registerUser() {
            
            showLoadingIdicator()
            
            MUser.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
                
                if error == nil {
                    self.hud.textLabel.text = "Письмо с подтверждением отправлено!"
                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                } else {
                    print("error registering", error!.localizedDescription)
                    self.hud.textLabel.text = "Электронный адрес уже используется"
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }
                
                
                self.hideLoadingIdicator()
            }
            
        }
    
    //MARK: - Helpers
    
    private func resetThePassword() {
        
        MUser.resetPasswordFor(email: emailTextField.text!) { (error) in
            
            if error == nil {
                self.hud.textLabel.text = "Письмо для сброса пароля отправлено!"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            } else {
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
    }
    
    private func textFieldsHaveText() -> Bool {
        return (emailTextField.text != "" && passwordTextField.text != "")
    }

    
    private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Activity Indicator
    
    private func showLoadingIdicator() {
        
        if activityIdicator != nil {
            self.view.addSubview(activityIdicator!)
            activityIdicator!.startAnimating()
        }
        
    }
    
    private func hideLoadingIdicator() {
        
        if activityIdicator != nil {
            activityIdicator!.removeFromSuperview()
            activityIdicator!.stopAnimating()
        }
    }

    
}
