import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "btn"]



  // 登録済みの一覧情報を選択すると、その情報の位置に移動する
  change_btn(el) {

    if(el.target.checked == true){
      this.btnTargets.forEach((btn) => {
        btn.checked = false;
      })
      }
    el.target.checked = true;
  }
}
