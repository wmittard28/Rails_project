function formatDateTimeString(jsonDateTime, format){
    const jsDateTime = ( typeof(jsonDateTime) === "string" ? new Date(jsonDateTime) : jsonDateTime );

    const monthNames = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun",
                         "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ];

    const yr  = jsDateTime.getFullYear();
    const mon = monthNames[ jsDateTime.getMonth() ];
    const day = jsDateTime.getDate();

    let hr  = jsDateTime.getHours();
    let min = jsDateTime.getMinutes();
    let ap  = "AM";
    if (hr  > 11) { ap  = "PM";      }
    if (hr  > 12) { hr  = hr - 12;   }
    if (hr === 0) { hr  = 12;        }
    if (min < 10) { min = "0" + min; }

    return (format === "long" ? `Created on ${day} ${mon} ${yr} at ${hr}:${min} ${ap} ET` : `${mon} ${day}, ${yr}`);
  }
