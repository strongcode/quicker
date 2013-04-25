   $(function() {
                $( "#slider-vertical" ).slider({
                    orientation: "vertical",
                    range: "min",
                    min: 0,
                    max: 100,
                    value: 60,
                    slide: function( event, ui ) {
                        $( "#amount" ).val( ui.value );
                    }
                });
                $( "#amount" ).val( $( "#slider-vertical" ).slider( "value" ) );
            });
               $(function() {
                $( "#slider-vertical1" ).slider({
                    orientation: "vertical",
                    range: "min",
                    min: 0,
                    max: 100,
                    value: 60,
                    slide: function( event, ui ) {
                        $( "#amount1").val( ui.value );
                    }
                });
                $( "#amount1", "%" ).val( $( "#slider-vertical1" ).slider( "value" ) );
            });