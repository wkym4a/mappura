import { Controller } from "stimulus"

var markers = [];
var test = 0;

// 非同期検索時の地図再表示用変数
var first_load = true;//初回ロードかどうかを判断
var disconnected_lat
var disconnected_lon
var disconnected_zoom


export default class extends Controller {
  static targets = [ "map","pins","latitude","longitude"]

disconnect() {
  first_load = false;
  disconnected_lat = this.map.center.Lat;
  disconnected_lon = this.map.center.Lon;
  disconnected_zoom = this.map.zoom;
  test += 1;
}

connect() {
  test += 2;
  console.log("1111");

}

    // disconnect() { ←だめだった。
    initialize() {
      test += 3;
    // initialize() {console.log("2222");
    console.log("2222");

    this.map = new Y.Map(this.mapTarget.id);

    if(first_load){
      this.map.drawMap(new Y.LatLng(35.66572, 139.73100), 17, Y.LayerSetId.NORMAL);
    }else{

      // 検索前に表示していたマーカーはいったん削除
      markers = [];
      //検索前に表示していた地点を地図で再表示
      this.map.drawMap(new Y.LatLng(disconnected_lat, disconnected_lon), disconnected_zoom, Y.LayerSetId.NORMAL);


    }



    var center = new Y.CenterMarkControl;
    var control = new Y.LayerSetControl();
    var sliderzoom = new Y.SliderZoomControlVertical();
    var searchcontrol = new Y.SearchControl();
    this.map.addControl(center);
    this.map.addControl(control);
    this.map.addControl(sliderzoom);
    this.map.addControl(searchcontrol);
      // this.map.setConfigure("dragging", true);

    this.pins = JSON.parse(this.pinsTarget.value)


    if(this.pins.length > 0){
      for (var i = 0; i < this.pins.length; i++) {

        var current_location = new Y.LatLng(this.pins[i].latitude,this.pins[i].longitude);

        // タイトルを付けるように変更
        var marker = new Y.Marker(current_location,{title: this.pins[i].pin_name});
        // var marker = new Y.Marker(current_location);

        //クリックすると詳細を表示(詳細の中身はまだ未作成)
        // marker.bindInfoWindow('<div data-controller="make-speech-bubble"><input type = "submit" data-action="click->make-speech-_bubble#tttt"></div>');
        // marker.bindInfoWindow('<div data-controller="tete"><input type = "submit" data-action="click->tete#tttt"></div>');
        marker.bindInfoWindow('<div data-controller="make-speech-bubble" class="speech_bubble_box"><input type="hidden" data-target = "make-speech-bubble.pin_id" value= ' + this.pins[i].id  +  ' ><div id = "pin_id_' + this.pins[i].id  +  '_onmap" >aaaa</div></div>');





        // marker.bindInfoWindow('<div id="pin_id_' + this.pins[i].id  +  '">' + '222222' + '</div>');
        // $("#pin_id_" + this.pins[i].id  +  ).html("<div>aaaaaavvvvvv</div>")


        // marker.bindInfoWindow('<%= render "index_item", pin: pin , item_num: i ,currentuser_info: currentuser_info,currentuser_workboxes: currentuser_workboxes,currentuser_plans: currentuser_plans %>');
        // marker.bindInfoWindow(this.pins[i].pin_article);

        // 「YmapCluster」を使用するため、不要
        // this.map.addFeature(marker);

        // // 作成したマーカーを保存
        markers.push(marker);
        console.log("tesutesutesu");
        // $('#pin_id_' + this.pins[i].id).html("<div>aaaaaavvvvvv</div>");

        //作成したマーカーをまとめる（Yahoo! Map Cluster
        new YmapCluster(this.map, markers);

      }
    }
  }


  tttt() {
  console.log("tesutesutesu");
  }

  // 登録済みの一覧情報を選択すると、その情報の位置に移動する
  move(el) {

    // 押下したボタンが何番目のものなのかを「this.index_num」に保存
    this.action_pin_id = el.target.dataset.actionPinId

    // 座標（＝緯度経度）を取得……↑で取得した「this.index_num」に該当するターゲットがtextcontentに持つ値をハッシュで獲得
    var cordinate = this.get_cordinate_from_textcontent;

    var current_location = new Y.LatLng(cordinate["lat"],cordinate["lng"])

        this.map.panTo(current_location, true);

  }



  get get_cordinate_from_textcontent(){
    for(var row = 0; row < this.latitudeTargets.length; row++){

      if (this.action_pin_id == this.latitudeTargets[row]["dataset"].actionPinId){
        return {lat: this.latitudeTargets[row].value,
                 lng: this.longitudeTargets[row].value}
      }

    }
     return {lat: 0,lng: 0}
  }


}
