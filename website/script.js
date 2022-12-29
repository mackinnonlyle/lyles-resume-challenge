"use strict";

$(document).ready(() => {
    $.post(' https://lq7si5jjx4.execute-api.us-east-1.amazonaws.com/Prod/dev ')
    .done(visitor_counter => {
        $('#visits').text(visitor_counter);
    })
    .fail(e => {
        console.log('Error');
        console.log(e);
    });
});