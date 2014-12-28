//
//  AboutVC.swift
//  SouthwestTravelManager
//
//  Created by Colin Regan on 12/3/14.
//  Copyright (c) 2014 Red Cup. All rights reserved.
//

import Foundation
import MessageUI

class AboutVC: UITableViewController, MFMailComposeViewControllerDelegate {
    
    var user: Passenger {
        get {
            return Passenger(firstName: firstNameTextField.text, lastName: lastNameTextField.text, accountNumber: accountNumberTextField.text)
        }
        set {
            firstNameTextField.text = newValue.firstName
            lastNameTextField.text = newValue.lastName
            accountNumberTextField.text = newValue.accountNumber
        }
    }
    
    @IBOutlet weak var versionCell: UITableViewCell!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var accountNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        versionCell.detailTextLabel?.text = NSBundle.mainBundle().versionString
        user = Passenger.defaultPassenger
    }
    
    @IBAction func doneTapped(sender: UIBarButtonItem) {
        Passenger.defaultPassenger = user
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    // TODO: disable mail buttons if MFMailComposeViewController.canSendMail() returns false
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 2) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            switch (indexPath.row) {
            case 0: // Facebook
                UIApplication.sharedApplication().openUntilSuccessful([AboutVC.Constants.FACEBOOK_LINK, AboutVC.Constants.FACEBOOK_SAFARI_LINK].map({ NSURL(string: $0)! }))
            case 1: // App Store
                UIApplication.sharedApplication().openUntilSuccessful([AboutVC.Constants.REVIEW_LINK, AboutVC.Constants.FACEBOOK_SAFARI_LINK].map({ NSURL(string: $0)! }))
            case 2: // Tell a friend
                presentMailComposeViewControllerTo(nil, subject: "SW Travel Manager app", messageBody: AboutVC.Constants.TELL_FRIEND_BODY(user.firstName))
            case 3: // Email support
                presentMailComposeViewControllerTo(["support@redcup.la"], subject: nil, messageBody: AboutVC.Constants.EMAIL_SUPPORT_BODY)
                
            default: break
            }
        }
    }
    
    // MARK: Email
    
    func presentMailComposeViewControllerTo(recipients: [String]?, subject: String?, messageBody: String?) {
        let mailVC = MFMailComposeViewController()
        mailVC.setToRecipients(recipients)
        mailVC.setSubject(subject)
        mailVC.setMessageBody(messageBody, isHTML: false)
        mailVC.mailComposeDelegate = self
        presentViewController(mailVC, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    struct Constants {
        
        static let FACEBOOK_LINK = "fb://profile/117102751770408"
        static let FACEBOOK_SAFARI_LINK = "http://www.facebook.com/SouthwestTravelManager"
        static let ITUNES_LINK = "itms-apps://itunes.apple.com/us/app/sw-travel-manager/id559944769?ls=1&mt=8"
        static let REVIEW_LINK = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=559944769&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8"
        
        static var EMAIL_SUPPORT_BODY: String {
            return "\n\n\n\nVersion \(NSBundle.mainBundle().versionString)\n\(UIDevice.currentDevice().systemName) \(UIDevice.currentDevice().systemVersion)\n\(UIDevice.currentDevice().machineName)"
        }
        
        static func TELL_FRIEND_BODY(from: String) -> String {
            return "Hey check out this app:\n\nhttp://itunes.apple.com/us/app/sw-travel-manager/id559944769?ls=1&mt=8\n\nIt's a utility app for Southwest Airlines travelers that reminds you to check in for upcoming flights and manages your unused travel funds.\n\n\nRegards,\n\(from)"
        }
        
    }


}
