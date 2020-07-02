$(document).on('turbolinks:load', function(){
    $('a.travel-logs-index').on('click',  showTravel  );
    $('form#new_travel'    ).on('submit', createTravel);
    $('a.travel-logs-prev' ).on('click',  showLog     );
    $('a.travel-logs-next' ).on('click',  showLog     );
  });

  // =============================================================================

  function showTravel(event){
    event.preventDefault();
    xhr_get(event.target.href, event.target).done( function(response){
      insertLogsIndex.call(this, response);
    });
  }

  function createTravel(event){
    event.preventDefault();
    xhr_post(event.target.action, event.target, $(event.target).serializeArray(), formWithErrors).done( function(response){
      insertNewTravel.call(this, response);
    });
  }

  function formWithErrors(response){
    $('div.form-container').replaceWith(
      response.responseText.match(/<div class="form-container">[\s\S]*<\/form>([\s]*<\/div>){2}/)[0]
    );
  }

  function showLog(event){
    event.preventDefault();
    xhr_get(event.target.href).done( function(response){
      new Log(response).insertHTML();
    });
  }

  // =============================================================================

  function insertLogsIndex(json){
    const travel = new Travel(json);
    if (travel.logs.length > 0){
      const $el = $(this).parents('div.link-body-container').children('a.link-primary-subcontainer');
      const $elContent = $el.html().split('<p><span class="make-italic">')[0];
      $el.html( $elContent + travel.logsIndexHTML() );
    }
  }

  function insertNewTravel(json){
    const travel = new Travel(json);
    const today = new Date(); today.setHours(0,0,0,0);
    const [pastDates, futureDates] = existingTravelStartDates(today);
    if (travel.startDate < today){ addToPastTravels(travel, pastDates); }
    else { addToFutureTravels(travel, futureDates); }
    $(this).children('input.form-submit-btn').prop('disabled', false);
    this.reset();
  }

  function addToPastTravels(travel, pastDates){
    const $header = $('h1#past_travels');
    $header.text( `Past Travels (${parseInt($header.text().match(/\d+/))+1})` );

    if (pastDates.length < 1){
      $header.parents('div.content-header-container')
      .after( travel.toHTML() );

    } else if (travel.startDate < pastDates[pastDates.length-1]){
      $( currentTravelElement(pastDates[pastDates.length-1]) )
      .parents('div.link-body-container')
      .after( travel.toHTML() );

    } else {
      for (const date of pastDates){
        if (travel.startDate >= date){
          $( currentTravelElement(date) ).parents('div.link-body-container')
          .before( travel.toHTML() );
          break;
        }
      }
    }
  }

  function addToFutureTravels(travel, futureDates){
    const $header = $('h1#future_travels');
    $header.text( `Future Travels (${parseInt($header.text().match(/\d+/))+1})` );

    if (futureDates.length < 1){
      $header.parents('div.content-header-container')
      .after( travel.toHTML() );

    } else if (travel.startDate > futureDates[futureDates.length-1]){
      $( currentTravelElement(futureDates[futureDates.length-1]) )
      .parents('div.link-body-container')
      .after( travel.toHTML() );

    } else {
      for (const date of futureDates){
        if (travel.startDate <= date){
          $( currentTravelElement(date) ).parents('div.link-body-container')
          .before( travel.toHTML() );
          break;
        }
      }
    }
  }

  function currentTravelElement(date){
    return (
      $('a.link-primary-subcontainer')
      .toArray()
      .filter( link => link.children[0].innerText.split(' – ')[0] === formatDateTimeString(date) )[0]
    );
  }

  function existingTravelStartDates(today){
    return (
      $('a.link-primary-subcontainer')
      .toArray()
      .map( link => new Date(link.children[0].innerText.split(' – ')[0]) )
      .reduce( ([p, f], date) => ( date < today ? [[...p, date], f] : [p, [...f, date]] ), [[], []] )
    );
  }
