
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "check","password","password_confirmation" ]

  initialize(){
    this.check()
  }

  check() {

    if (this.checkTarget.checked==true){
    this.passwordTarget.readOnly = false;
    this.password_confirmationTarget.readOnly = false;

    }else{
      this.passwordTarget.readOnly = true;
      this.passwordTarget.value="";
      this.password_confirmationTarget.readOnly = true;
      this.password_confirmationTarget.value="";
    }
  }
}
