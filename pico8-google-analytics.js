<!-- PICO-8 Google Analytics adapter -->
<!-- by matthias, special thanks to nucleartide -->
<script>
    var chars = ' !"#%\'()*+,-./0123456789:;<=>?abcdefghijklmnopqrstuvwxyz[]^_{~}'
    var index = 0
    var event_category = ""
    var event_action = ""
    var event_label = ""
    var event_value = null

    // Data read functions
    function readByte(arr) {
        var b = arr[index]
        index++
        return b
    }

    function readChar(arr) {
        var charCode = arr[index]
        index++
        return chars[charCode - 1]
    }

    function readString(arr) {
        var strlen = readByte(arr)
        if (strlen === 255) {
            return null
        }
        var str = ''
        for (var i = 0; i < strlen; i++) str += readChar(arr)
        return str
    }

    var arrayChangeHandler = {
        // Fire when array has changed
        set: function(target, property, value, receiver) {
            // Wait for finishing byte of array change
            if (value === 255) {
                // Read data from GPIO
                event_category = readString(pico8_gpio)
                event_action = readString(pico8_gpio)
                event_label = readString(pico8_gpio)
                event_value = parseInt(readString(pico8_gpio))
                // Fire analytics event
                if (typeof ga === "function") {
                    if (event_value) {
                        ga('send', 'event', event_category, event_action, event_label, event_value)
                    } else {
                        ga('send', 'event', event_category, event_action, event_label)
                    }
                } else {
                    console.warn("Tried to fire a PICO-8 Google Analytics event, but no ga object seems to exist.")
                }
            }
            // Reset data
            index = 0
            event_category = ""
            event_action = ""
            event_label = ""
            // Finish array change
            target[property] = value
            return true
        }
    };

    // Set new listener for pico8_gpio changes
    var pico8_gpio = new Proxy(new Array(128), arrayChangeHandler)
</script>
<!-- End of PICO-8 Google Analytics adapter -->