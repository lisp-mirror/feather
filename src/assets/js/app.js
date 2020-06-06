function updateTable () {
    fetch('/api/usernames')
        .then(response => response.json())
        .then( data => {
            //            var tbl = document.getElementById("table");
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

window.onload = function() {
    updateTable();
};
