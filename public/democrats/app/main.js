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
            deps: ['jquery'],
            exports: 'form_mods',
        },
        'form' : {
            deps : ['form_mods', 'jquery' ],
            exports: 'form',
        },
        'referrer_controls' : {
            deps : [ 'js-yaml.min', 'form_mods', 'jquery'],
            exports: 'referrer_controls',
        },
        'js-yaml.min' : {
            deps : ['jquery'],
            exports: 'js-yaml.min',
        }
        
    }
});

//Should be able to magically turn a form into a caling form by requiring 'call'
require(['form_mods']);