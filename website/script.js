"use strict";

fetch('https://dnrpe6jq8b.execute-api.us-east-1.amazonaws.com/Prod/dev', {
  method: 'POST'
})
  .then(response => response.json())
  .then(visitor_counter => {
    console.log('**** VISITOR_COUNTER', visitor_counter);
    const visitsElement = document.querySelector('#visits');
    if (visitsElement) {
      visitsElement.textContent = visitor_counter.visit_count;
    } else {
      console.error("Element with 'visits' ID not found in the DOM");
    }
  })
  .catch(error => {
    console.log('Error');
    console.error(error);
  });
