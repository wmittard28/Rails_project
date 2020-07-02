function xhr_get(url, context){
    return $.ajax({
      method: 'get',
      url: url,
      context: context,
      dataType: 'json'
    });
  }

  function xhr_post(url, context, data, showErrors){
    return $.ajax({
      method: 'post',
      url: url,
      context: context,
      data: data,
      dataType: 'json'
    })
    .fail( function(response){
      showErrors(response);
    });
  }
