/************************************************************
	
	jQuery OSDI Plugin
	
	Submit forms to OSDI-compatible systems using OSDI's non-authenticated POST functions and triggers. Requires jQuery 1.8 or above. More info on OSDI at http://opensupporter.org/
	
	Version: 1.2.0
	Last Updated: January 25, 2017
	Authors: Jason Rosenbaum
	Repository: https://github.com/opensupporter/jquery-osdi
	License: MIT open source, https://github.com/opensupporter/jquery-osdi/blob/master/LICENSE.md
	
************************************************************/

;( function( $, window, document, undefined ) {

	"use strict";
	
		var pluginName = "osdi",
			defaults = {
				autoresponse: true,
				done: function() {},
				fail: function() {},
				always: function() {},
				status: "subscribed",
				immediate: false,
				ajax_options: {
					type: "POST",
					dataType: 'json',
					contentType: 'application/json'
				}
			},
			methods = {
				submit: function() {
				}
			};

		// The actual plugin constructor
		function Plugin ( element, options ) {
			//console.log($element.length);
			this.$element = $(element);
			
			this.settings = $.extend( {}, defaults, options );
			this._defaults = defaults;
			this._name = pluginName;
			this.init(this.$element);
			
			this.submit = function() {
			    this.form_submit(this.$element, this);
			};
		}
		
		

		// Avoid Plugin.prototype conflicts
		$.extend( Plugin.prototype, {
			init: function($element) {
				
				// validate to make sure we can use this form on a basic level
				if (this.validate_form( $element )) {
					this.form_submit($element, this);
				}
			},
			validate_form: function( $element ) {
				//console.log($element);
				if (!$element.is('form')) {
					console.log('JQUERY OSDI ERROR: The DOM element passed to the jQuery OSDI plugin is not a form. The jQuery OSDI plugin only supports form elements.');		
					return false;
				} else {
					return true;
				}
			},
			form_submit: function ( $element, that ) {
				//console.log(that.settings.immediate);
				if (that.settings.immediate) {
					that.submit_handler($element, that);
				} else {
					$element.on('submit', function() {
						that.submit_handler($element, that);
						
						// stop normal form submission
						return false;
					});
				}
			},
			submit_handler: function( $element, that ) {
				//console.log('submithandler');
				//console.log($element);
				//console.log(that);
				if (that.validate_submit( $element )) {
					var	body,
						endpoint,
						ajax_options,
						done,
						fail,
						always;
					
					body = that.create_body($element);
					
					if (that.settings.endpoint && that.settings.endpoint != '') {
						if (typeof(that.settings.endpoint) == 'function') {
							endpoint = that.settings.endpoint();
						} else {
							endpoint = that.settings.endpoint;
						}
					} else {
						endpoint = $element.attr('action');
					}
					
					ajax_options = {
						url: endpoint,
						data: JSON.stringify(body),
					}
					
					if (typeof(that.settings.ajax_options) == 'function') {
						ajax_options = $.extend( ajax_options, that.settings.ajax_options() ); 
					} else {
						ajax_options = $.extend( ajax_options, that.settings.ajax_options ); 
					}
					
					
					done = that.settings.done;
					fail = that.settings.fail;
					always = that.settings.always;
					
					//console.log(body);
					//console.log(JSON.stringify(body));
					//console.log(endpoint);
					//console.log(ajax_options);
					//console.log(done);
					//console.log(fail);
					//console.log(always);
					
					that.perform_ajax(ajax_options, done, fail, always);
				}
						
				
			},
			validate_submit: function( $element ) {
				if (this.validate_endpoint($element) && this.validate_add_tags()
				) {
					return true;
				} else {
					return false;
				}
			},
			validate_endpoint: function ( $element ) {
				//console.log($element);
				//console.log(!this.settings.endpoint);
				//console.log(!$element.attr('action'));
				if (!this.settings.endpoint && !$element.attr('action')) {
					console.log('JQUERY OSDI ERROR: An endpoint is required. Either set the endpoint option with a string when calling the jQuery OSDI plugin, or give your form an action attribute with the endpoint as its value.');
					return false;
				} else {
					return true;
				}
			},
			validate_add_tags: function() {
				//console.log(this.settings.add_tags);
				//console.log(this.settings.add_tags.length);
				//console.log(this.settings.add_tags);
				//console.log(!$.isArray(this.settings.add_tags));
				//console.log(this.settings.add_tags.length <= 0);
				if (this.settings.add_tags) {
					if (typeof(this.settings.add_tags) == 'function') {
						if (!$.isArray(this.settings.add_tags()) || !this.settings.add_tags().length > 0) {
							console.log('JQUERY OSDI ERROR: The add_tags option is not a valid array of at least one element. You must pass an array with at least one element to the jQuery OSDI plugin to add tags.');
							return false;
						} else {
							return true;
						}
					} else {
						if (!$.isArray(this.settings.add_tags) || !this.settings.add_tags.length > 0) {
							console.log('JQUERY OSDI ERROR: The add_tags option is not a valid array of at least one element. You must pass an array with at least one element to the jQuery OSDI plugin to add tags.');
							return false;
						} else {
							return true;
						}
					}
					
				} else {
					return true;
				}
			},
			create_body: function( $element ) {
				var	body,
					autoresponse,
					email_address,
					postal_address,
					postal_addresses,
					phone_number,
					custom_fields,
					add_tags;
				
				if (this.settings.body) {
					if (typeof(this.settings.body) == 'function') {
						body = this.settings.body();
					} else {
						body = this.settings.body;
					}
				} else {
					body = {
						"person" : {}
					}
					
					if (typeof(this.settings.autoresponse) == 'function') {
						if (this.settings.autoresponse() === true) {
							autoresponse = {
								"triggers" : {
									"autoresponse" : {
										"enabled" : true
									}
								}
							}
						}
					} else if (this.settings.autoresponse) {
						if (this.settings.autoresponse === true) {
							autoresponse = {
								"triggers" : {
									"autoresponse" : {
										"enabled" : true
									}
								}
							}
						}
					}
					
					$.extend( body, autoresponse );
					
					if (this.settings.add_tags) {
						if (typeof(this.settings.add_tags) == 'function') {
							add_tags = {
								"add_tags": this.settings.add_tags()
							}
						} else {
							add_tags = {
								"add_tags": this.settings.add_tags
							};
						}
						
						
						$.extend( body, add_tags );
					}
					
					if ($element.find(':input[name="family_name"]').length && $element.find(':input[name="family_name"]').val()) {
						body.person.family_name = $.isArray($element.find(':input[name="family_name"]').val()) ? $element.find(':input[name="family_name"]').val().pop() : $element.find(':input[name="family_name"]').val();
					}
					
					if ($element.find(':input[name="given_name"]').length && $element.find(':input[name="given_name"]').val()) {
						body.person.given_name = $.isArray($element.find(':input[name="given_name"]').val()) ? $element.find(':input[name="given_name"]').val().pop() : $element.find(':input[name="given_name"]').val();
					}
					
					if ($element.find(':input[name="email_address"]').length && $element.find(':input[name="email_address"]').val()) {
						var email_address_string = $.isArray($element.find(':input[name="email_address"]').val()) ? $element.find(':input[name="email_address"]').val().pop() : $element.find(':input[name="email_address"]').val();
						
						email_address = {
							"email_addresses" : [ 
								{ 
									"address" : email_address_string
								}
							]
						};
						
						$.extend( body.person, email_address );
						
						// add status here, if we have email
						if (typeof(this.settings.status) == 'function') {
							if (this.settings.status() !== false) {
								body.person.email_addresses[0].status = this.settings.status();
							}
						} else {
							if (this.settings.status !== false) {
								body.person.email_addresses[0].status = this.settings.status;
							}
						}
					}
					
					if (
						   	($element.find(':input[name="street"]').length && $element.find(':input[name="street"]').val()) 
						|| 	($element.find(':input[name="locality"]').length && $element.find(':input[name="locality"]').val()) 
						||	($element.find(':input[name="region"]').length && $element.find(':input[name="region"]').val()) 
						|| 	($element.find(':input[name="postal_code"]').length && $element.find(':input[name="postal_code"]').val())
						|| 	($element.find(':input[name="country"]').length && $element.find(':input[name="country"]').val())
					) {
						postal_address = {};
						
						if ($element.find(':input[name="street"]').length && $element.find(':input[name="street"]').val()) {
							postal_address.address_lines = [
								$.isArray($element.find(':input[name="street"]').val()) ? $element.find(':input[name="street"]').val().pop() : $element.find(':input[name="street"]').val()
							];
						}
						
						if ($element.find(':input[name="locality"]').length && $element.find(':input[name="locality"]').val()) {
							postal_address.locality = $.isArray($element.find(':input[name="locality"]').val()) ? $element.find(':input[name="locality"]').val().pop() : $element.find(':input[name="locality"]').val();
						}
						
						if ($element.find(':input[name="region"]').length && $element.find(':input[name="region"]').val()) {
							postal_address.region = $.isArray($element.find(':input[name="region"]').val()) ? $element.find(':input[name="region"]').val().pop() : $element.find(':input[name="region"]').val();
						}
						
						if ($element.find(':input[name="postal_code"]').length && $element.find(':input[name="postal_code"]').val()) {
							postal_address.postal_code = $.isArray($element.find(':input[name="postal_code"]').val()) ? $element.find(':input[name="postal_code"]').val().pop() : $element.find(':input[name="postal_code"]').val();
						}
						
						if ($element.find(':input[name="country"]').length && $element.find(':input[name="country"]').val()) {
							postal_address.country = $.isArray($element.find(':input[name="country"]').val()) ? $element.find(':input[name="country"]').val().pop() : $element.find(':input[name="country"]').val();
						}
						
						postal_addresses = {
							"postal_addresses" : [
								postal_address
							]
						};
						
						$.extend( body.person, postal_addresses );
					}
					
					if ($element.find(':input[name="phone_number"]').length && $element.find(':input[name="phone_number"]').val()) {
						var phone_number_string = $.isArray($element.find(':input[name="phone_number"]').val()) ? $element.find(':input[name="phone_number"]').val().pop()	: $element.find(':input[name="phone_number"]').val();
						
						phone_number = {
							"phone_numbers" : [ 
								{ 
									"number" : phone_number_string
								}
							]
						};
						
						$.extend( body.person, phone_number );
					}
					
					if ($element.find(':input[name^="custom["]').length) {
						custom_fields = {};

						$.each($element.find(':input[name^="custom["]').serializeArray(), function() {
							if (this.value != '') {
								custom_fields[this.name.replace(/^custom\[|\]$/g, '')] = this.value;
							}
						});

						if (!$.isEmptyObject(custom_fields)) {
							body.person.custom_fields = custom_fields;
						}
					}

				}
				
				return body;
			},
			perform_ajax: function(ajax_options, done, fail, always) {
				$.ajax(
					ajax_options
				).done(function(data, textStatus, jqXHR) {
					done(data, textStatus, jqXHR);
				}).fail(function(jqXHR, textStatus, errorThrown) {
					fail(jqXHR, textStatus, errorThrown);
				}).always(function(data_jqXHR, textStatus, jqXHR_errorThrown) {
					always(data_jqXHR, textStatus, jqXHR_errorThrown)
				});
			}	
		});

		// A really lightweight plugin wrapper around the constructor,
		// preventing against multiple instantiations
		$.fn[ pluginName ] = function( options ) {
			return this.each( function() {
				if ( !$.data( this, "plugin_" + pluginName ) ) {
					$.data( this, "plugin_" +
						pluginName, new Plugin( this, options ) );
				} else {
					//console.log($.data( this, "plugin_" + pluginName ));
					//console.log(options);
					
					//$(this).osdi().submit;
					$.data( this, "plugin_" + pluginName ).submit();
				}
			} );
		};
		
		

} )( jQuery, window, document );