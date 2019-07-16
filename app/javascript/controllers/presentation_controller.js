import { Controller } from "stimulus"

var markers_belongs_to_plan = [];
var markers_belongs_to_workbox = [];

export default class extends Controller {
  static targets = [ "map","plan_id","pins_belongs_to_plan","pins_belongs_to_workbox","index_item"]

  initialize() {
    this.map = new Y.Map(this.mapTarget.id,{configure : {
       scrollWheelZoom : true
   }});

        this.map.drawMap(new Y.LatLng(35.66572, 139.73100), 17, Y.LayerSetId.NORMAL);

        // var center = new Y.CenterMarkControl;
        var control = new Y.LayerSetControl();
        var sliderzoom = new Y.SliderZoomControlVertical();
        // var searchcontrol = new Y.SearchControl();
        // this.map.addControl(center);
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

    // 最後に、初めのピンを選択
    this.index_num = 0;
    this.move_to_index_pin;

    }
  }

  move(el) {
    // 押下したボタンが何番目のものなのかを「this.index_num」に保存
    this.index_num = Number(el.target.dataset.actionIndexNum);

    this.move_to_index_pin;
  }

  move_to_left(){
    if(this.index_num != 0){
      this.index_num -= 1
    }
    this.move_to_index_pin;
  }
  move_to_right(){
    if(this.index_num != this.index_itemTargets.length - 1){
      this.index_num += 1
    }
    this.move_to_index_pin;
  }
  move_to_leftmost(){
    this.index_num = 0;
    this.move_to_index_pin;
  }
  move_to_rightmost(){
    this.index_num = this.index_itemTargets.length - 1
    this.move_to_index_pin;
  }

  get move_to_index_pin(){

    $(this.index_itemTargets).removeClass("selected")
    $(this.index_itemTargets[this.index_num]).addClass("selected")

    var selected_info = JSON.parse(this.pins_belongs_to_planTarget.value)[this.index_num];
    var current_location = new Y.LatLng(selected_info.latitude,selected_info.longitude);

    this.map.panTo(current_location, true);
  }
  
}
