class Travel {
    constructor(json){
      this.id          = json.id;
      this.position    = json.position;
      this.notes      = json.notes;
      this.company = json.company;
      this.user        = json.user;
      [this.startDate, this.job_applicationDates] = newjob_applicationDates(json.start_date, json.end_date);
    }

    notesIndexHTML(){
      return (
        '<p><span class="make-italic">&ndash; ' +
        this.notes.map( note => note.title ).join('</span></p><p><span class="make-italic">&ndash; ') +
        '</span></p>'
      );
    }

    toHTML(){
      return (
        `<div class="link-body-container">` +
          `<div class="link-secondary-subcontainer">` +
            `<p><a class="job_application-notes-index" href="/job_applications/${this.id}">Preview</a></p>` +
            `<p><a data-confirm="Are you sure?" rel="nofollow" data-method="delete" href="/job_applications/${this.id}">Delete</a></p>` +
            `<p><a href="/job_applications/${this.id}/edit">Edit</a></p>` +
          `</div>` +
          `<a href="/travels/${this.id}" class="link-primary-subcontainer">` +
            `<p>${this.job_applicationDates}</p>` +
            `<p><span class="make-bold">${this.company.name}</span></p>` +
            `<p>${this.position || "No Position"}</p>` +
            `<p>0 Application notes</p>` +
          `</a>` +
        `</div>`
      );
    }
  }

  function newJobApplicationDates(jsonStartDate, jsonEndDate){
    const dates = [];
    let d = new Date(jsonStartDate);
    d.setTime( d.getTime() + d.getTimezoneOffset()*60*1000 );
    dates.push( d, formatDateTimeString(d) );
    if (!!jsonEndDate){
      d = new Date(jsonEndDate);
      d.setTime( d.getTime() + d.getTimezoneOffset()*60*1000 );
      dates[1] += ` – ${formatDateTimeString(d)}`;
    }
    return dates;
  }
