

window.onload = function(){  
    setUpEvents();
};

function setUpEvents(){
    fetch("https://lq7si5jjx4.execute-api.us-east-1.amazonaws.com/Prod/visit")
    .then(response=>response.json())
    .then((data)=>console.log(data))
    .catch((error)=>console.log(error))

}


fetch("https://lq7si5jjx4.execute-api.us-east-1.amazonaws.com/Prod/visit")
.then(response=>response.json())
.then((data)=>console.log(data))
return document.getElementById('data').innerHTML = data.text()
.catch((error)=>console.log(error))

