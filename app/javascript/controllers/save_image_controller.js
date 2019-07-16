import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "image_field","msg","file_field" ]

  change_image(e){

    this.msgTarget.text=''

    var file = e.target.files[0];

    // キャンセルしたなら、画像も消す
    if (file == undefined){
      $("#" + this.image_fieldTarget.id).children().remove();
      return;
    }

    // 画像が6MBより大きければエラー……メッセージを表示し、キャンセル
    if (e.target.files[0].size > 6291456){
      this.msgTarget.text='容量が大きすぎます（アップロードできる画像は6MBまでです）。';
      this.file_fieldTarget.value="";
      $("#" + this.image_fieldTarget.id).children().remove();
      return;
    }

    var reader = new FileReader();
    var $preview = $("#" + this.image_fieldTarget.id);

    reader.onload = (function(file) {
      return function(e) {
        $preview.empty();
        $preview.append($('<img>').attr({
          src: e.target.result,
          class: "image_field_preview",
          title: file.name
        }));
      };
    })(file);
    reader.readAsDataURL(file);

  }

}
