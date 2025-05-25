window.addEventListener('message', function(event) {
    switch (event.data.Action) {
        case "SEND_NOTIFICATION":
            
            break;
        case "UPDATE_INVENTORY":

                var inventory = event.data.inventory;
            // Get the left and right inventory divs
                var leftInventory = $(".leftInventory");
                var rightInventory = $(".rightInventory");

                // Add new inventory slots to the appropriate side
                for (var i = 0; i < inventory; i++) {
                    var slot = '<div class="slot">' +
                        '<div class="slot-title">Slot ' + newSlots[i] + '</div>' +
                        '<img class="slot-img" src="https://via.placeholder.com/150x150" alt="Item Image">' +
                        '</div>';
                }
            break;
        case "UPDATE_SPECIFIC_INVENTORY":
            
            break;
        case "UPDATE_MONEY":
            
            break;
        case "OPEN_INVENTORY":
            $(".overlay").fadeIn();
            break;
        default:
            console.log("There isn't such an action as ");
    }
})

window.addEventListener("keyup", (event) => {
   
    if(27 === event.keyCode || 9 === event.keyCode) {
        $(".overlay").fadeOut()
        $.post('http://nuipipe/nui_client_response', JSON.stringify({
            event : "x-inventory:closeInventory",
            data : ""
        }));
    }
   
});