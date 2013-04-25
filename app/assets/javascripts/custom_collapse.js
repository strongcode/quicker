      /**
             * jQuery Cookie Plugin
             * https://github.com/carhartl/jquery-cookie
             *
             * Copyright 2011, Klaus Hartl
             * Dual licensed under the MIT or GPL Version 2 licenses.
             * http://www.opensource.org/licenses/mit-license.php
             * http://www.opensource.org/licenses/GPL-2.0
             */
        
            (function(a) {
                a.cookie = function(b, c, d) {
                    if (arguments.length > 1 && (!/Object/.test(Object.prototype.toString.call(c)) || c === null || c === undefined)) {
                        d = a.extend({}, d);
                        if (c === null || c === undefined) {
                            d.expires = -1
                        }
                        if (typeof d.expires === "number") {
                            var e = d.expires,
                            f = d.expires = new Date;
                            f.setDate(f.getDate() + e)
                        }
                        c = String(c);
                        return document.cookie = [encodeURIComponent(b), "=", d.raw ? c : encodeURIComponent(c), d.expires ? "; expires=" + d.expires.toUTCString() : "", d.path ? "; path=" + d.path : "", d.domain ? "; domain=" + d.domain : "", d.secure ? "; secure" : ""].join("")
                    }
                    d = c || {};
                    var g = d.raw ?
                        function(a) {
                        return a
                    } : decodeURIComponent;
                    var h = document.cookie.split("; ");
                    for (var i = 0, j; j = h[i] && h[i].split("="); i++) {
                        if (g(j[0]) === b) return g(j[1] || "")
                    }
                    return null
                }
            })(jQuery)

            //jQuery.noConflict();

            jQuery(document).ready(function($) {
                // Collapsible Sidebar //
                if ($.cookie("sidebar") == "collapsed") {
                    $('#sidebarToggle').attr("title", "Expand Sidebar");
                    $("#container").css("width", "100%");
                    $("#sidebar").hide();
                }

                $('#sidebarToggle').click(function(event) {
                    event.preventDefault();

                    if ($('#sidebar').is(':visible')) {
                        //$('#sidebarToggle').toggleClass('sidebar_collapse sidebar_expand');
                        $('#sidebarToggle').attr("title", "Expand Sidebar");
                        
                        $("#sidebar").stop(true, true).fadeOut("slow", function() {
                            $("#container").stop(true, true).animate({
                                width: "100%"
                            }, 500);
                            $.cookie("sidebar", "collapsed");
                            $('#sidebarToggle').find('img').attr('src','/assets/expand_btn.png');
                        });
                    }
                    else {
                        //$('#sidebarToggle').toggleClass('sidebar_collapse sidebar_expand');
                        $('#sidebarToggle').attr("title", "Collapse Sidebar");
                        
                        $("#container").stop(true, true).animate({
                            width: "75.9%"
                        }, 500, function() {
                            $("#sidebar").stop(true, true).fadeIn("slow", function(){
                                $('#sidebarToggle').find('img').attr('src','/assets/colapse_btn.png');
                            });
                            $.cookie("sidebar", "expanded");
                            
                        });
                    }
                });
                $('.btn_collapse').click(function(){
                    $(this).parent('div').next('div.collapse1').toggle('fast', function(){
                        if($(this).css('display') == 'none' ) {
                            $(this).prev('div').find('img').attr('src','/assets/plus_icon.png')
                        }
                        else {
                            $(this).prev('div').find('img').attr('src','/assets/minus_icon.png')
                        }
                       
                    });                        
                });
                // Collapsible Sidebar //
            });
        
