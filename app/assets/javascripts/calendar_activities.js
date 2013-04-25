 $(document).ready(function() {
	
                var date = new Date();
                var d = date.getDate();
                var m = date.getMonth();
                var y = date.getFullYear();
		
                $('#calendar').fullCalendar({
                    editable: true,
                    events: [
                        {
                            title:'Review Frasca',
                            start:new Date(y,m,16,10,0),
                            end:new Date(y,m,16)
                        },
                        {
                            title:'Review Frasca',
                            start:new Date(y,m,16,11,0),
                            end:new Date(y,m,16)
                        },
                        {
                            title:'Frasca,Boulder',
                            start:new Date(y,m,13,10,0),
                            end:new Date(y,m,13)
                        },
                        {
                            title:'AMC,Westminister',
                            start:new Date(y,m,14,11,0),
                            end:new Date(y,m,14)
                        },
                        {
                            title: 'Click for Google',
                            start: new Date(y, m, 28),
                            end: new Date(y, m, 28),
                            url: 'http://google.com/'
                        }
                    ]
                });
		
            });
