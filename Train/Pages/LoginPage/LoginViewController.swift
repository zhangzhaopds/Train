//
//  LoginViewController.swift
//  Train
//
//  Created by 张昭 on 06/01/2017.
//  Copyright © 2017 Jmsp. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var codeImageView: RandCodeImageView2!
    //    var codeImageView: RandCodeImageView2?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 
        SVProgressHUD.show(withStatus: "正在加载图片验证码...")
        refreshCodeImageBtnClicked(UIButton())
    }
    
    @IBAction func refreshCodeImageBtnClicked(_ sender: UIButton) {
        
//        SVProgressHUD.show(withStatus: "正在加载图片验证码...")
        
        codeImageView.clearRandCodes()
        
        let successHandler = {(image: UIImage) -> Void in
            //            logger("成功")
            print("成功")
//            print(image.size)// 293 190
            self.codeImageView.image = image
            SVProgressHUD.dismiss()
            
        }
        let failureHandler = {(error: NSError) -> Void in
            print("失败")
            SVProgressHUD.showError(withStatus: "验证码加载失败")
        }
        
        Service.sharedInstance.preLoginFlow(success: successHandler, failure: failureHandler)
        
    }
    @IBAction func loginBtnClicked(_ sender: UIButton) {
        SVProgressHUD.show(withStatus: "登录中...")
        
        let successHandler = {() -> Void in
            SVProgressHUD.dismiss()
            print("登陆成功")
            let story = UIStoryboard(name: "Main", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "TabBarController")
            UIApplication.shared.keyWindow?.rootViewController = vc
            
        }
        let failureHandler = {(error: NSError) -> Void in
            
            SVProgressHUD.showError(withStatus: translate(error))
            // 出现错误，冲洗刷新图片二维码
            self.refreshCodeImageBtnClicked(UIButton())
        }
        if codeImageView.randCodeStr == nil {
            SVProgressHUD.showError(withStatus: "验证码不能为空")
            return
        }
        if (userNameTextField.text?.characters.count)! < 1 {
            SVProgressHUD.showError(withStatus: "用户名不能为空")
            return
        }
        if (passwordTextField.text?.characters.count)! < 1 {
            SVProgressHUD.showError(withStatus: "密码不能为空")
            return
        }
        
        
        Service.sharedInstance.loginFlow(user: userNameTextField.text!, passWord: passwordTextField.text!, randCodeStr: codeImageView.randCodeStr!, success: successHandler, failure: failureHandler)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
