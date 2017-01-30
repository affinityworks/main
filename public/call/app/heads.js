dir = 'heads'
imgs =
  { 
    'devos': { 
      'name' : 'Betsy DeVos',
      'img' : 'devos-300.jpg'
    },
    'mnuchin': { 
      'name' : 'Steve Mnuchin',
      'img' : 'mnuchin-300.jpg'
    },
    'price' : {
			'name': 'Tom Price',
			'img' : 'price-300.jpg'
		},
		'pruitt' : {
		  'name' : 'Scott Pruitt',
		  'img' : 'pruitt-300.jpg'
		},
		'puzder' : {
		  'name' : 'Andrew Puzder',
		  'img' : 'puzder-300.jpg'
		},
		'sessions' : {
		  'name' : 'Jeff Sessions',
		  'img' : 'sessions-300.jpg'
		},
		'tillerson' : {
		  'name' : 'Rex Tillerson',
		  'img' : 'tillerson-300.jpg'
		}
  }

$(document).on('can_embed_loaded',function(){
	for (var key in imgs) {
		var nominee = imgs[key];
		div = $('<div>')
		  .addClass('nominee');
		img = $('<img>')
			.attr('src','/democrats/app/'+dir+'/'+nominee.img)
			.attr('id',key)
			.addClass('nominee-img');
		label = $('<label>')
		  .text(nominee.name)
		  .attr('for',key)
		  .addClass('nominee-label');
    
    $(div).append(img).append(label).appendTo($(head_container));


	}
});