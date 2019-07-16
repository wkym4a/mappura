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
  static targets = [ "pin_id"]

initialize() {

  var pin_id = this.pin_idTarget.value

    // $.get('/drawing_pins/make_speech_bubble', {id: pin_id})
    //↑これは省略形、こちらでも動作する。
    // ajax
    $.ajax({
       type: 'GET',
       url: '/drawing_pins/make_speech_bubble',
       data: {id: pin_id}
    })
    .done(function (data) {
        console.log('success');
    });
    // ajax
    //注意：【,dataType: 'json'】とjson形式指定すると動かなくなる。
  }
}
