
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "image_field" ]

  change_image(e){

    var file = e.target.files[0];
    var reader = new FileReader();
    var $preview = $("#" + this.image_fieldTarget.id);

    reader.onload = (function(file) {
      return function(e) {
        $preview.empty();
        $preview.append($('<img>').attr({
          src: e.target.result,
          class: "image_field_pin_create_preview",
          title: file.name
        }));
      };
    })(file);
    reader.readAsDataURL(file);

  }

}
