import { Controller } from "stimulus"

var markers_belongs_to_plan = [];
var markers_belongs_to_workbox = [];

export default class extends Controller {
  static targets = [ "map","plan_id","pins_belongs_to_plan","pins_belongs_to_workbox","index_item"]

  initialize() {

    // ↓20190908add_前回表示していたマーカーが残再表示されないようにする
    // （念の為。再表示されることがあるように思えたが、完全に再現性を確認したわけではない）
    markers_belongs_to_plan = [];
    markers_belongs_to_workbox = [];
    // ↑20190908add_前回表示していたマーカーが残再表示されないようにする

    this.map = new Y.Map(this.mapTarget.id,{configure : {
       scrollWheelZoom : true
   }});

        this.map.drawMap(new Y.LatLng(35.66572, 139.73100), 17, Y.LayerSetId.NORMAL);

        // var center = new Y.CenterMarkControl;
        var control = new Y.LayerSetControl();
        var sliderzoom = new Y.SliderZoomControlVertical();
        var scale = new Y.ScaleControl();
        // var searchcontrol = new Y.SearchControl();
        // this.map.addControl(center);
        this.map.addControl(control);
        this.map.addControl(sliderzoom);
        this.map.addControl(scale);
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

            //////// ↓前のピンからの経路」を表示するための追加↓ ////////
            if(i > 0 ){
              switch (this.pins[i].route){
                // case 0:
                //前のピンからの経路タイプが「0：非表示」である場合は、何もしない

                case 1:
                  //前のピンからの経路タイプが「1：青い直線表示」である場合
                  var line_style = new Y.Style("0000FF", 1.6, 0.8);
                  var line_latlngs = []

                  line_latlngs.push(new Y.LatLng(this.pins[i-1].latitude,this.pins[i-1].longitude))
                  line_latlngs.push(new Y.LatLng(this.pins[i].latitude,this.pins[i].longitude))

                  var polyline = new Y.Polyline(line_latlngs, {strokeStyle: line_style});this.map.addFeature(polyline);
                  break;

                case 2:
                case 3:
                  //経路探索レイヤーを生成・追加します。
                  var route = new Y.RouteSearchLayer();
                  this.map.addLayer(route);
                  var latlngs = [new Y.LatLng(this.pins[i-1].latitude,this.pins[i-1].longitude),
                                 new Y.LatLng(this.pins[i].latitude,this.pins[i].longitude)]

                  if(this.pins[i].route==2){
                    route.execute( latlngs);

                  }else{
                    route.execute( latlngs, {"useCar": false });
                  }

              }
            }
            //////// ↑前のピンからの経路」を表示するための追加↑ ////////

            break;

          case "workbox":
          // 該当するピンタイプがない場合は、アイコン指定せずに（デフォルトで）ピンを立てる
            var marker = new Y.Marker(current_location,{title: this.pins[i].pin_name});

            break;
        }

        // urlが設定されていた場合、そのページを別窓で開くようにする。
        var url_info = ""
        if(!this.pins[i].url==false){
          url_info = 'href = "' + this.pins[i].url + '" target = "_blank"'
        }

        if(this.pins[i].image.url==null){
          marker.bindInfoWindow('<div><a ' + url_info +  '>' + this.pins[i].pin_name + '</a></div><div>' + this.pins[i].pin_article + '</div>');
        }else{
          marker.bindInfoWindow('<div><a ' + url_info +  '>' + this.pins[i].pin_name + '</a></div><img src = "' + this.pins[i].image.url + '"><div>' + this.pins[i].pin_article + '</div>');
        }

        // // 作成したマーカーを保存
        pin_storage_box.push(marker);

      }

    //↓ 20190908change_プレゼン画面ではピンを纏めない。
    this.map.addFeatures(pin_storage_box);
    // //作成したマーカーをまとめる（Yahoo! Map Cluster
    // new YmapCluster(this.map, pin_storage_box);
    //↑ 20190908change_プレゼン画面ではピンを纏めない。

    // 最後に、初めのピンを選択
    this.index_num = 0;
    this.move_to_index_pin;

    }
  }

  move(el) {

    if (!el.target.dataset.actionIndexNum == false){
      // 「actionIndexNum」を取得できた場合のみ、処理実行

        // 押下したボタンが何番目のものなのかを「this.index_num」に保存
        this.index_num = Number(el.target.dataset.actionIndexNum);

        this.move_to_index_pin;

    }

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
