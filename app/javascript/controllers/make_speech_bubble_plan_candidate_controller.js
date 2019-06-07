// プランピン編集画面における、「プランに含まれていないピン」の吹き出し作成用
// →吹き出し内には「プラン〇〇（固定）に追加する」ボタンを持つ

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["plan_id","pin_id"]

initialize() {
// 後回し、一時無効化
  var pin_id = this.pin_idTarget.value
  var plan_id = this.plan_idTarget.value

    // ajax
    $.ajax({
       type: 'GET',
       url: '/plans/' + plan_id + '/plan_pins/new',
       data: {pin_id: pin_id,plan_id: plan_id}
    })
    //注意：【,dataType: 'json'】とjson形式指定すると動かなくなる。
  }

}



// url: '/plans/make_speech_bubble_plan_candidate',
