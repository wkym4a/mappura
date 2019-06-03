// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "pin","selected_info","selected_info_type","add_btn","remove_btn" ]

  initialize() {
    console.log('Hello, Stimulus222552!');
    this.set_selectbox();
    // set_selectbox();
  }

  select() {
    this.set_selectbox();
  }

  get set_selectbox() {
    console.log('Hello, Stimulus!');

var type = this.selected_info_typeTarget.value;
var pin_id = this.pinTarget.value;
var selected_id = this.selected_infoTarget.value;
var add_btn = this.add_btnTarget;
var remove_btn = this.remove_btnTarget;
    // ajax
               $.ajax({
                   type: 'GET',
                   url: '/drawing_pins/judge_add_or_remove',
                   data: {
                       type: type,
                       pin_id: pin_id,
                       selected_id: selected_id
                   },
                   dataType: 'json'  //json形式指定
               })
                   .done(function (data) {
                     if(data==0){
                       $(add_btn).removeClass("display_none");
                       $(remove_btn).addClass("display_none");
                     }else{
                       $(add_btn).addClass("display_none");
                       $(remove_btn).removeClass("display_none");

                     }


                       console.log('success');
                   });
    // ajax

return 0;

  }
}
