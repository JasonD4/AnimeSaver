//
//  LogInViewController.swift
//  AnimeSaver
//
//  Created by Jason on 3/4/19.
//  Copyright © 2019 Jason. All rights reserved.
//

import UIKit
import FirebaseAuth

enum AccountLoginState{
    case newAccount
    case exsistingAccount
}

protocol LoginViewDelegate: AnyObject {
    func didSelectLoginButton(_ loginView: LogInViewController, accountLoginState: AccountLoginState)
}


class LogInViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var toLogIn: UIButton!
    @IBOutlet weak var logInStatus: UIButton!
    
    private weak var delegate: LoginViewDelegate?
    
    private var usersession: UserSession!
    private var accountLoginState = AccountLoginState.newAccount
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
        usersession.userSessionAccountDelegate = self
        usersession.usersessionSignInDelegate = self
        toLogIn.setTitle("Create", for: .normal)
        logInStatus.setTitle("Login into your account", for: .normal)
        // Do any additional setup after loading the view.
    }
    


    @IBAction func logInButtonPressed(_ sender: UIButton) {
        delegate?.didSelectLoginButton(self, accountLoginState: accountLoginState)
    
    }
    
    @IBAction func logInStatusButton(_ sender: UIButton) {
        accountLoginState = accountLoginState == .newAccount ? .exsistingAccount : .newAccount
        switch accountLoginState {
        case .newAccount:
            toLogIn.setTitle("Create", for: .normal)
            logInStatus.setTitle("Login into your account", for: .normal)
        case .exsistingAccount:
            toLogIn.setTitle("Login", for: .normal)
            logInStatus.setTitle("New User? Create an account", for: .normal)
        }
    }
}
    


extension LogInViewController: UITextFieldDelegate{
    
}

extension LogInViewController: LoginViewDelegate{
    func didSelectLoginButton(_ loginView: LogInViewController, accountLoginState: AccountLoginState) {
        guard let email = email.text,
            let password = password.text,
            !email.isEmpty,
            !password.isEmpty else {
                showAlert(title: "Missing Required Fields", message: "Email and Password Required", actionTitle: "Try Again")
                return
        }
        switch accountLoginState {
        case .newAccount:
            usersession.createNewUser(email: email, password: password)
        case .exsistingAccount:
            usersession.signInWithExsistingUser(email: email, password: password)
        }
    }
}


extension LogInViewController: UserSessionAccountCreationDelegate{
    func didCreateAccount(_ userSession: UserSession, user: User) {
        showAlert(title: "Account Created", message: "Account created using \(user.email ?? "No Email Provided")", style: .alert) { (alert) in
            
            let story = UIStoryboard(name: "Main", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "AnimeViewContoller")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didRecieveErrorCreatingAccount(_ userSession: UserSession, error: Error) {
        showAlert(title: "Account Creation Error", message: error.localizedDescription, actionTitle: "Try Again")
    }
    
    
}

extension LogInViewController: UserSessionSignInDelegate{
    func didRecieveSignInError(_ usersession: UserSession, error: Error) {
        showAlert(title: "Sign In Error", message: error.localizedDescription, actionTitle: "Try Again")
    }
    
    func didSignInExistingUser(_ usersession: UserSession, user: User) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let tabController = story.instantiateViewController(withIdentifier: "test")
        present(tabController, animated: true)
        
    }
    
    
}

