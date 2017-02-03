var base_embed_url = 'https://actionnetwork.org/widgets/v2/form/stop-rex-tillerson-2?format=js&source=widget&style=full'
query_string = new URLSearchParams(window.location.search);
var ref = query_string.get('referrer');
var full_embed_url = base_embed_url + '&referrer='+ref;
$.getScript(full_embed_url)
 .done(function (script, textStatus) {
   console.log('Loading AN embed script: ' + textStatus);
 });