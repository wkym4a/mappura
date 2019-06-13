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
  static targets = [ "selected_info","form","selected_info_type","selected_info_id","pin_id","method","btn" ]
  // static targets = [ "pin","selected_info","selected_info_type","add_btn","remove_btn","testtttt" ]

  initialize() {
    this.set_selectbox;
  }

  select() {
    this.set_selectbox;
  }

  get set_selectbox() {
    console.log('Hello, Stimulus!');

    this.selected_info_idTarget.value = this.selected_infoTarget.value;

    var type = this.selected_info_typeTarget.value;
    var selected_id = this.selected_info_idTarget.value;
    var pin_id = this.pin_idTarget.value;

    var form = this.formTarget;
    // var action_url = this.formTarget.action;
    var method = this.methodTarget;
    var btn = this.btnTarget;
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
                     if(data.length==0){
                       btn.value = "に追加"
                       switch (type) {
                         case "workbox":
                           form.action = "/workboxes/" + selected_id + "/workbox_pins";
                           method.value = "post";
                           break;
                         case "plan":
                           form.action = "/plans/" + selected_id + "/plan_pins";
                           method.value = "post";
                           break;
                       }
                       // $(add_btn).removeClass("display_none");
                       // $(remove_btn).addClass("display_none");
                     }else{
                       btn.value = "から削除"
                       switch (type) {
                         case "workbox":
                           form.action = "/workboxes/" + selected_id + "/workbox_pins/" + data[0].id;
                           method.value = "delete";
                           break;
                         case "plan":
                           form.action = "/plans/" + selected_id + "/plan_pins/" + data[0].id;
                           method.value = "delete";
                           break;
                       }
                       // $(add_btn).addClass("display_none");
                       // $(remove_btn).removeClass("display_none");

                     }

                   });
    // ajax

  }
}
