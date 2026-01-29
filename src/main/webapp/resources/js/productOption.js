
function addOptionRow() {
    var table = document.getElementById("optionTable");
    var rowCount = table.rows.length;
    var row = table.insertRow(rowCount);

    var colorCell = row.insertCell(0);
    var sizeCell = row.insertCell(1);
    var stockCell = row.insertCell(2);
    var deleteCell = row.insertCell(3);

    colorCell.innerHTML = `
        <select name="options[${rowCount-1}].optionColor">
            <option value="Black">Black</option>
            <option value="White">White</option>
            <option value="Red">Red</option>
            <option value="Blue">Blue</option>
        </select>
    `;
    sizeCell.innerHTML = `
        <select name="options[${rowCount-1}].optionSize">
            <option value="S">S</option>
            <option value="M">M</option>
            <option value="L">L</option>
            <option value="XL">XL</option>
        </select>
    `;
    stockCell.innerHTML = `<input type="number" name="options[${rowCount-1}].productStock" value="0" />`;
    deleteCell.innerHTML = `<button type="button" onclick="deleteRow(this)">삭제</button>`;
}

function deleteRow(btn) {
    var row = btn.parentNode.parentNode;
    row.parentNode.removeChild(row);
}

