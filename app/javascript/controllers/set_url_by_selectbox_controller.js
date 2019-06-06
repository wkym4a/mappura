
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "selected_info","base_url","btn" ]

  initialize() {
    this.set_url;
  }

  select() {
    this.set_url;
  }

  get set_url() {
    console.log('Hello, Stimulusですよー');
    this.btnTarget.href = this.base_urlTarget.value + this.selected_infoTarget.value;
  }
}
