// プランピン編集画面における、「プランに含まれていないピン」の吹き出し作成用
// →吹き出し内には「プラン〇〇（固定）に追加する」ボタンを持つ

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["plan_id","plan_pin_id"]

initialize() {
// 後回し、一時無効化
  var plan_pin_id = this.plan_pin_idTarget.value
  var plan_id = this.plan_idTarget.value

    // ajax
    $.ajax({
       type: 'GET',
       url: '/plans/' + plan_id + '/plan_pins/' + plan_pin_id
    })
    //注意：【,dataType: 'json'】とjson形式指定すると動かなくなる。
  }

}

// type: 'GET',
// url: '/plans/' + plan_id + '/plan_pins/show',
// data: {plan_pin_id: plan_pin_id}
// から、変更

// url: '/plans/make_speech_bubble_plan_candidate',
