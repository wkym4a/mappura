
import { Controller } from "stimulus"

var markers = [];

export default class extends Controller {
  static targets = ["map","latitude","longitude" ]

  initialize(e) {

       this.map = new Y.Map(this.mapTarget.id);
       this.map.drawMap(new Y.LatLng(35.66572, 139.73100), 17, Y.LayerSetId.NORMAL);


       var center = new Y.CenterMarkControl
       var control = new Y.LayerSetControl();
       var sliderzoom = new Y.SliderZoomControlVertical();
       var searchcontrol = new Y.SearchControl();
       this.map.addControl(center);
       this.map.addControl(control);
       this.map.addControl(sliderzoom);
       this.map.addControl(searchcontrol);

       var txt_latitude = this.latitudeTarget
       var txt_longitude = this.longitudeTarget
       var map_box = this.map

      this.map.bind('dblclick', function(e) {
        
        txt_latitude.value = e.Lat;
        txt_longitude.value = e.Lon;

        var current_location = new Y.LatLng(e.Lat,e.Lon)

        var marker = new Y.Marker(current_location);
        map_box.addFeature(marker);

        if(markers.length > 0){
          for (var i = 0; i < markers.length; i++) {

              map_box.removeFeature(markers[i]);
              // markers[i].setMap(null);
          }
            markers = [];	//参照を開放
        }
        // // 作成したマーカーを保存
        markers.push(marker);

        // ピンの場所に移動
        map_box.panTo(current_location, true);

      });

  }



}
