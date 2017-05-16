//Pass the page-level referrer through to the AN script.
query_string = new URLSearchParams(window.location.search);
var ref = ""
if (query_string.has('referrer')) ref = '&referrer='+query_string.get('referrer');
			
requirejs.config({
    shim: {
        'call': {
            deps: ['form', 'jquery', 'campaign'],
            exports: 'call'
        },
        'campaign': {
            deps: ['form', 'jquery'],
            exports: 'campaign'
        },
        'form_mods': {
            deps: ['jquery', 'form'],
            exports: 'form_mods',
        },
        'form' : {
            deps : ['an', 'jquery' ],
            exports: 'form',
        },
        'heads' : {
          deps : ['form', 'jquery' ],
          exports: 'heads',
        }
        
    },
    paths: {
			an: 'https://actionnetwork.org/widgets/v2/form/stop-rex-tillerson?format=js&source=widget&style=full' + ref,
    },
    baseUrl: '/call/app/'
});

//Should be able to magically turn a form into a caling form by requiring 'call'
require(['form', 'call', 'form_mods']);