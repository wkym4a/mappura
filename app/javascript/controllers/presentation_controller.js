import { Controller } from "stimulus"

var markers_belongs_to_plan = [];
var markers_belongs_to_workbox = [];

export default class extends Controller {
  static targets = [ "map","plan_id","pins_belongs_to_plan","pins_belongs_to_workbox"]

  initialize() {
    this.map = new Y.Map(this.mapTarget.id,{configure : {
       scrollWheelZoom : true
   }});

        this.map.drawMap(new Y.LatLng(35.66572, 139.73100), 17, Y.LayerSetId.NORMAL);


        var center = new Y.CenterMarkControl;
        var control = new Y.LayerSetControl();
        var sliderzoom = new Y.SliderZoomControlVertical();
        // var searchcontrol = new Y.SearchControl();
        this.map.addControl(center);
        this.map.addControl(control);
        this.map.addControl(sliderzoom);
        // this.map.addControl(searchcontrol);

        //「プラン」由来のピンを作成
        this.make_pins(this.pins_belongs_to_planTarget,"plan",markers_belongs_to_plan);

        //「ワークボックス」由来のピンを作成
        this.make_pins(this.pins_belongs_to_workboxTarget,"workbox",markers_belongs_to_workbox);

      }






  make_pins(pins_info,pin_type,pin_storage_box){

    this.pins = JSON.parse(pins_info.value)

    if(this.pins.length > 0){
      for (var i = 0; i < this.pins.length; i++) {

        var current_location = new Y.LatLng(this.pins[i].latitude,this.pins[i].longitude);

        switch (pin_type) {
          case "plan":
            var icon = new Y.Icon('https://chart.googleapis.com/chart?chst=d_map_pin_letter_withshadow&chld=' + (i+1) +'|00BFFF|000000');
            var marker = new Y.Marker(current_location,{icon: icon,title: this.pins[i].pin_name});

            if(i == 0){
              this.map.panTo(current_location, true);
            }


            break;

          case "workbox":
          // 該当するピンタイプがない場合は、アイコン指定せずに（デフォルトで）ピンを立てる
            var marker = new Y.Marker(current_location,{title: this.pins[i].pin_name});

          break;
        }


        if(this.pins[i].image.url==null){
          marker.bindInfoWindow('<div>' + this.pins[i].pin_name + '</div><div>' + this.pins[i].pin_article + '</div>');
        }else{
          marker.bindInfoWindow('<div>' + this.pins[i].pin_name + '</div><img src = "' + this.pins[i].image.url + '"><div>' + this.pins[i].pin_article + '</div>');
        }

        // // 作成したマーカーを保存
        pin_storage_box.push(marker);

      }

    //作成したマーカーをまとめる（Yahoo! Map Cluster
    new YmapCluster(this.map, pin_storage_box);

    }
  }


  move(el) {

    console.log('awsへの変更適用確認用（20190618');

    // 押下したボタンが何番目のものなのかを「this.index_num」に保存
    this.index_num = el.target.dataset.actionIndexNum;

    var selected_info = JSON.parse(this.pins_belongs_to_planTarget.value)[this.index_num];
    var current_location = new Y.LatLng(selected_info.latitude,selected_info.longitude);

    this.map.panTo(current_location, true);
  }


}
