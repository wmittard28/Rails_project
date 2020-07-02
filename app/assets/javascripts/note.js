class Note {
    constructor(json){
      this.prevNotePath = json.prev_note_path;
      this.nextNotePath = json.next_note_path;
      this.title       = json.note.title;
      this.createdAt   = formatDateTimeString(json.note.created_at, 'long');
      this.content     = json.note.content;
    }

    insertHTML(){
      $('a.job_application-notes-prev').attr('href', this.prevNotePath);
      $('a.job_application-notes-next').attr('href', this.nextNotePath);
      $('div.content-header-container h1').html(this.title);
      $('div.content-header-container h3').html(this.createdAt);
      $('div.content-body-container p').html(this.content);
    }
  }
