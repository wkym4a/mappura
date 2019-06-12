
import { Controller } from "stimulus"

var pin_location
var map_box

export default class extends Controller {
  static targets = ["map","latitude","longitude","btn_move"]

  initialize(e) {

    this.map = new Y.Map(this.mapTarget.id,{configure : {
      scrollWheelZoom : true
    }});
     pin_location = new Y.LatLng(this.latitudeTarget.textContent,this.longitudeTarget.textContent)

     this.map.drawMap(pin_location, 17, Y.LayerSetId.NORMAL);

     var center = new Y.CenterMarkControl
     var control = new Y.LayerSetControl();
     var sliderzoom = new Y.SliderZoomControlVertical();
     var searchcontrol = new Y.SearchControl();
     this.map.addControl(center);
     this.map.addControl(control);
     this.map.addControl(sliderzoom);
     this.map.addControl(searchcontrol);

     map_box = this.map

     var marker = new Y.Marker(pin_location);
     map_box.addFeature(marker);

  }





  move_return(){
    // ピンの場所に移動
    map_box.panTo(pin_location, true);
  }


}
