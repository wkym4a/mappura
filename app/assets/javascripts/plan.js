
$(function() {

  console.log('js入ってる？');

  var el, sortable;
  el = document.getElementById("sortable_list");
  if (el !== null) {
    return sortable = Sortable.create(el, {
      delay: 80,
      onUpdate: function(evt) {
        return $.ajax({
          url: '/plan/' + $("#plan_id").val() + '/sort',
          type: 'patch',
          data: {
            from: evt.oldIndex,
            to: evt.newIndex
          }
        });
      }
    });
  }
});
