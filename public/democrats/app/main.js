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
			an: 'https://actionnetwork.org/widgets/v2/form/stop-the-worst-of-the-worst?format=js&source=widget&style=full&clear_id=true',
    }
});

//Should be able to magically turn a form into a caling form by requiring 'call'
require(['form', 'form_mods', 'heads', 'referrer_controls']);