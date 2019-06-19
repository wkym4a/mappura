
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "selected_info","base_url_1","base_url_2" ,"btn"]

  initialize() {
    this.set_url;
  }

  select() {
    this.set_url;
  }

  get set_url() {
    if(this.selected_infoTarget.value==""){
      this.btnTarget.disabled = true;
      this.btnTarget.style.backgroundColor = '#555555';
    }else{
      this.btnTarget.disabled = false;
      this.btnTarget.style.backgroundColor = '#007bff';
    }

    this.btnTarget.href = this.base_url_1Target.value + this.selected_infoTarget.value + this.base_url_2Target.value ;
  }
}
