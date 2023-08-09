//
//  Strings.swift
//  DearDiaryStrings
//
//  Created by Abhijit Singh on 15/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import Foundation

public enum Strings {
    
    public enum Registration {
        public static let createAccount = "Create account"
        public static let welcomeBack = "Welcome back!"
        
        public static let fillDetails = "Please fill in the form to continue"
        public static let signInToAccount = "Please sign in to your account"
        
        public static let fullName = "Full Name"
        public static let emailAddress = "Email Address"
        public static let password = "Password"
        public static let confirmPassword = "Confirm Password"
        public static let forgotPassword = "Forgot password?"
        
        public static let signUp = "Sign Up"
        public static let signIn = "Sign In"
        public static let signInWithGoogle = "Sign In with Google"
        public static let haveAnAccount = "Have an account?"
        public static let dontHaveAnAccount = "Don't have an account?"
        
        public static let otp = "OTP"
        public static let verificationCode = "Verification Code"
        public static let otpSentTo = "We have sent a one-time password to"
        public static let submit = "Submit"
        
        public static let genericError = "This field is mandatory"
        public static let emailIncorrectError = "The entered email is incorrect"
        public static let passwordIncorrectError = "The entered password is incorrect"
        public static let passwordsDontMatchError = "Entered passwords don't match"
        public static let userRegisteredError = "A user with this email address is already registered"
        public static let userNotRegisteredError = "No user is registered with this email address"
    }
    
    public enum Folders {
        public static let title = "Folders"
        public static let search = "Search"
    }
    
    public enum Calendar {
        public static let monday = "Monday"
        public static let tuesday = "Tuesday"
        public static let wednesday = "Wednesday"
        public static let thursday = "Thursday"
        public static let friday = "Friday"
        public static let saturday = "Saturday"
        public static let sunday = "Sunday"
        
        public static let january = "January"
        public static let february = "February"
        public static let march = "March"
        public static let april = "April"
        public static let may = "May"
        public static let june = "June"
        public static let july = "July"
        public static let august = "August"
        public static let september = "September"
        public static let october = "October"
        public static let november = "November"
        public static let decemeber = "December"
    }

    public enum Profile {
        public static let email = "Email"
        public static let theme = "Theme"
        public static let light = "Light"
        public static let system = "System"
        public static let dark = "Dark"
        public static let changePassword = "Change password"
        public static let deleteAccount = "Delete account"
    }
    
    public enum Folder {
        public static let done = "Done"
        public static let folder = "Folder"
    }
    
    public enum Note {
        public static let note = "Note"
        public static let textFormatting = "Aa"
        
        public enum Text {
            public static let format = "Format"
            public static let title = "Title"
            public static let heading = "Heading"
            public static let body = "Body"
            public static let monospaced = "Monospaced"
        }
    }
    
    public enum Alert {
        public static let deleteFolderMessage = "Deleting this folder will also delete its contents."
        public static let deleteAccountTitle = "Delete account?"
        public static let deleteAccountMessage = "Deleting your account will also delete all your folders and their content."
        public static let logoutMessage = "You will have to sign in again once you log out."
        public static let logout = "Logout"
        public static let cancel = "Cancel"
        public static let delete = "Delete"
    }
    
}
