import { Controller } from "stimulus"

var markers = [];

export default class extends Controller {
  static targets = [ "map","pins","latitude","longitude"]

    // disconnect() { ←だめだった。
    connect() {
    // initialize() {

    this.map = new Y.Map(this.mapTarget.id);
    this.map.drawMap(new Y.LatLng(35.66572, 139.73100), 17, Y.LayerSetId.NORMAL);

    var center = new Y.CenterMarkControl;
    var control = new Y.LayerSetControl();
    var sliderzoom = new Y.SliderZoomControlVertical();
    var searchcontrol = new Y.SearchControl();
    this.map.addControl(center);
    this.map.addControl(control);
    this.map.addControl(sliderzoom);
    this.map.addControl(searchcontrol);

    this.pins = JSON.parse(this.pinsTarget.value)


    if(this.pins.length > 0){
      for (var i = 0; i < this.pins.length; i++) {

        var current_location = new Y.LatLng(this.pins[i].latitude,this.pins[i].longitude);

        // タイトルを付けるように変更
        var marker = new Y.Marker(current_location,{title: this.pins[i].pin_name});
        // var marker = new Y.Marker(current_location);

        //クリックすると詳細を表示(詳細の中身はまだ未作成)
        marker.bindInfoWindow(this.pins[i].pin_article);

        this.map.addFeature(marker);

        // // 作成したマーカーを保存（念の為
        markers.push(marker);

        //作成したマーカーをまとめる（Yahoo! Map Cluster
        new YmapCluster(this.map, markers);

      }
    }
  }



  // 登録済みの一覧情報を選択すると、その情報の位置に移動する
  move(el) {

    // 押下したボタンが何番目のものなのかを「this.index_num」に保存
    this.index_num = el.target.dataset.actionIndexNum

    // 座標（＝緯度経度）を取得……↑で取得した「this.index_num」に該当するターゲットがtextcontentに持つ値をハッシュで獲得
    var cordinate = this.get_cordinate_from_textcontent;

    var current_location = new Y.LatLng(cordinate["lat"],cordinate["lng"])

        this.map.panTo(current_location, true);

  }

  get get_cordinate_from_textcontent(){
     return {lat: this.latitudeTargets[this.index_num].value,
              lng: this.longitudeTargets[this.index_num].value}
  }


}
