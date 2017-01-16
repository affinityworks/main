$('#can_thank_you').ready(setScript(this,res));

setScript = function(el,resp){
  console.log('setScript called with this=' + el);
  $(el)
    .empty()
    .text('Hello world');
}