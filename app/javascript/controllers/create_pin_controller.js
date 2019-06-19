
import { Controller } from "stimulus"

// マーカー保存用の枠
var markers = [];

// 座標が確定されているかどうが」のフラグ
var latlng_decided_flg = false;

export default class extends Controller {
  static targets = ["map","latitude","longitude","btn_set","btn_reset","address","btn_save","msg" ]

  initialize(e) {

    // 座標が確定されているかどうが」のフラグを「F」にする
    latlng_decided_flg = false

    // 初期表示状態
    this.latitudeTarget.readOnly = false;
    this.longitudeTarget.readOnly = false;
    this.btn_setTargets[0].style.backgroundColor = '#A7F1FF';
    this.btn_setTargets[1].style.backgroundColor = '#A7F1FF';
    this.btn_resetTarget.style.backgroundColor = '#555555';
    this.btn_saveTarget.disabled = true;

      this.map = new Y.Map(this.mapTarget.id,{configure : {
         scrollWheelZoom : true
     }});
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
     var txt_address = this.addressTarget
     var map_box = this.map

    this.map.bind('dblclick', function(e) {

      // すでに座標が確定されている場合は、処理せず抜ける
      if(latlng_decided_flg==true){
        return;
      }

      txt_latitude.value = e.Lat;
      txt_longitude.value = e.Lon;
      txt_address.value = ""//「住所」を初期化……「座標→住所」で設定し直すため

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

  // 【座標→住所】による「座標確定」処理
  set_address_by_latlng(){
    // すでに座標が確定されている場合は、処理せず抜ける
    if(latlng_decided_flg==true){
      return;
    }

    if((this.latitudeTarget.value == "") || (this.longitudeTarget.value == "") ){
      this.msgTarget.text='緯度、経度を入力してください。'
      return;
    }

    if(isNaN(this.latitudeTarget.value)==true || isNaN(this.longitudeTarget.value)==true ){
      this.msgTarget.text="緯度、経度には数値を入力してください。"
      return;
    }

    if((this.latitudeTarget.value < -90) || (this.latitudeTarget.value > 90) ||
     (this.longitudeTarget.value < -180) || (this.longitudeTarget.value > 180) ){
      this.msgTarget.text='存在しない座標です。\n緯度は「-90」〜「90」、経度は「-180」〜「180」の範囲で入力してください。'
      return;
    }

    var address = this.addressTarget;
    var txt_msg = this.msgTarget;

    var current_location = new Y.LatLng(this.latitudeTarget.value,this.longitudeTarget.value)
    var request = { "latlng": current_location };

    var geocoder = new Y.GeoCoder();
    geocoder.execute( request , function(ydf) {
        if ( ydf.features.length > 0 ) {
            var feature = ydf.features[0];

            if(feature.property.Address==""){
              address.value=feature.property.Country.Name;
            }else{
              address.value=feature.property.Address;
            }

        }else{
            txt_msg.text="住所から座標を獲得できませんでした。住所は手入力で入力してください。";
        }

    } );

    // ↓マーカー作成→既存マーカー削除→作成したメーカーを設置→作成マーカーを保存
    var marker = new Y.Marker(current_location);
    this.map.addFeature(marker);

    if(markers.length > 0){
      for (var i = 0; i < markers.length; i++) {

          this.map.removeFeature(markers[i]);
          // markers[i].setMap(null);
      }
        markers = [];	//参照を開放
    }
    // // 作成したマーカーを保存
    markers.push(marker);

    // ピンの場所に移動
    this.map.panTo(current_location, true);
    //
    // ↑マーカー作成→既存マーカー削除→作成したメーカーを設置→作成マーカーを保存

    //画面のボタンなどをリセット
    this.reset_form_active

  }

    // 【住所→座標】による「座標確定」処理
    set_latlng_by_address(){
      // すでに座標が確定されている場合は、処理せず抜ける
      if(latlng_decided_flg==true){
        return;
      }

      var address = this.addressTarget;
      var latitude = this.latitudeTarget;
      var longitude = this.longitudeTarget;
      var txt_msg = this.msgTarget;

      //画面再設定用に格納
      var btn_sets = this.btn_setTargets;
      var btn_reset = this.btn_resetTarget;
      var btn_save = this.btn_saveTarget;

      var map_box = this.map

      var request = { query : address.value };

      var geocoder = new Y.GeoCoder();

      geocoder.execute( request , function( ydf ) {
        if ( ydf.features.length > 0 ) {

          latitude.value =ydf.features[0]["latlng"]["Lat"];
          longitude.value =ydf.features[0]["latlng"]["Lon"];

          // ↓マーカー作成→既存マーカー削除→作成したメーカーを設置→作成マーカーを保存
          var current_location = new Y.LatLng(latitude.value,longitude.value)

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
          //
          // ↑マーカー作成→既存マーカー削除→作成したメーカーを設置→作成マーカーを保存

              latlng_decided_flg = true
              latitude.readOnly = true;
              longitude.readOnly = true;
              btn_sets[0].style.backgroundColor = '#555555';
              btn_sets[1].style.backgroundColor = '#555555';
              btn_reset.style.backgroundColor = '#A7F1FF';
              btn_save.disabled = false;
              txt_msg.text="";

        }else{
          //【住所から座標を獲得できなかった場合の処理】
          txt_msg.text="住所から座標を獲得できませんでした。"
          return;
        }
      } );

      // //画面のボタンなどをリセット
      // this.reset_form_active

    }

  // 「座標確定解除」処理
  reset_latlng(){
    // まだ座標が確定されていない場合は、処理せず抜ける
    if(latlng_decided_flg==false){
      return;
    }

    this.reset_form_active

  }


get reset_form_active(){
  this.msgTarget.text=""//メッセージ枠は空欄に戻す

  if(latlng_decided_flg==false){

    latlng_decided_flg = true
    this.latitudeTarget.readOnly = true;
    this.longitudeTarget.readOnly = true;
    this.btn_setTargets[0].style.backgroundColor = '#555555';
    this.btn_setTargets[1].style.backgroundColor = '#555555';
    this.btn_resetTarget.style.backgroundColor = '#A7F1FF';
    this.btn_saveTarget.disabled = false;

  } else {

    latlng_decided_flg = false
    this.latitudeTarget.readOnly = false;
    this.longitudeTarget.readOnly = false;
    this.btn_setTargets[0].style.backgroundColor = '#A7F1FF';
    this.btn_setTargets[1].style.backgroundColor = '#A7F1FF';
    this.btn_resetTarget.style.backgroundColor = '#555555';
    this.btn_saveTarget.disabled = true;

  }

}


}
