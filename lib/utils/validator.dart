class DataValidator{
  String validateEmail(String email) {
    // 1
    RegExp regex = RegExp(r'\w+@\w+\.\w+'); // translates to word@word.word
    // 2
    if (email.isEmpty) {
      return 'We need an email address';
    } else if (!regex.hasMatch(email)) {
      return "That doesn't look like an email address";
    } else {
      return "0";
    }
  }

}
class Sanitizer{
  String? isFullNameValid(String name){
    if(name.isEmpty){
      return 'Please enter Full name';
    }else if(!name.contains(" ")){
      return "Please input Full name";
    }else if(name.length < 5){
      return "Please use valid name";
    }
    return null;
  }
  String? isPhoneValid(String phone){
    if(phone.isEmpty){
      return "Phone number required";
    }else if(phone.length < 10){
      return "Phone number length must not be less than 10";
    }
    return null;
  }
  String? isValidField(String data,String tar){
    if(data.isEmpty){
      return "$tar is required";
    }
    return null;
  }

  bool _validEmail(String email){
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
  String? isEmailValid(String email){
    if(email.isEmpty){
      return null;//'Please enter Your Email';
    }else if(!_validEmail(email)){
      return 'Please use valid email';
    }
    return null;
  }
  String? isPasswordValid(String password){
    if(password.isEmpty){
      return 'Please enter Your Password';
    }else if(password.length < 6){
      return 'Password length must not be less than 6';
    }else if(password.length > 25){
      return 'Password length must not be greater than 25';
    }
    return null;
  }
  String? isPasswordMatch(String password1 , String password2){
     if(isPasswordValid(password1) == null &&
        isPasswordValid(password2) == null && password1 == password2){
       return null;
     }else if(password2.isEmpty){
       return 'Please confirm Your Password';
     }else if(password2.length < 6){
       return 'Password length must not be less than 6';
     }
     return "Password Didn't match";
  }
  String? isVerificationCodeValid(String code){
    if(code.isEmpty){
      return "Please insert code";
    }else if(code.length < 6){
      return "Code length must not be less than 6";
    }
    return null;
  }

}