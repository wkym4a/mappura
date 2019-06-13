
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "check","password","password_confirmation" ]

  initialize(){
    this.check()
  }

  check() {
    // 「非公開」が選択されていた場合→パスワード入力可能とする
    if (this.checkTargets[1].checked==true){
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
