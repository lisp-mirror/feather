function updateTable () {
    fetch('/api/usernames')
        .then(response => response.json())
        .then( data => {
            var tbl = document.querySelector("#table");
            var oldBody = document.getElementsByTagName("tbody")[0];
            var tblBody = document.createElement("tbody");

            for (var i = 0; i < data.length; i++) {
                var row = document.createElement("tr");

                var cell = document.createElement("td");
                var cellText = document.createTextNode(data[i].key);
                cell.appendChild(cellText);
                row.appendChild(cell);

                var cell = document.createElement("td");
                var cellText = document.createTextNode(data[i].username);
                cell.appendChild(cellText);
                row.appendChild(cell);

                tblBody.appendChild(row);
            }
            if (oldBody != null) 
                tbl.removeChild(oldBody);
            tbl.appendChild(tblBody);
        });
}

function sendData() {
    const FD = new FormData( document.getElementById( "formAddName" ) );

    fetch('/api/usernames', {
        method: 'POST',
        body: FD
    })
        .then(response => {
            if (!response.ok) {
                alert(response.statusText);
            }
            updateTable()
        })
};

window.onload = function() {
    document.getElementById( "formAddName" )
        .addEventListener( "submit", function ( event ) {
            event.preventDefault();
            sendData();
        });
    
    updateTable();
};
