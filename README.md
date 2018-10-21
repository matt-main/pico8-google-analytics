# Google Analytics for PICO-8
Easy Google Analytics event tracking for all your PICO-8 games.

![PICO-8 Google Analytics example](https://i.imgur.com/MGM435n.png)

It's very important to understand what's going on in your games and how players actually play your game. With this simple integration you can use Google Analytics with all your PICO-8 games (HTML export version) and track events according to your reporting needs.


## Setup

1. Add the code from [`event.lua`](./event.lua) to your PICO-8 source code. This will expose the `event()` function for tracking. The code uses 144 tokens in PICO-8.

2. Add a Google Analytics snippet to your exported game HTML file, refer to this
[link](https://developers.google.com/analytics/devguides/collection/analyticsjs/).
> Note: The snippet should be placed near the top of the head section and should look like the one in [`example-analytics-snippet.js`](./example-analytics-snippet.js). Don't forget to enter your personal tracking ID of your analytics property.

3. Find the game's `<script>` tag in the exported HTML file with the form:

```html
<script async type="text/javascript" src="game_title.js"></script>
```
and add the script from [`pico8-google-analytics.js`](./pico8-google-analytics.js) right before it. 

You can check out [`example.html`](./example.html) for a working example (add a tracking ID to test with your Analytics account).

## Usage

Having added the code from [`event.lua`](./event.lua) to your game will expose a single `event()` function which can be used like this:

```lua
API:
event(category,action,label?,value?)

examples:
event('got item','pick-axe')
event('level 12','clear','found treasure')
event('level 1','win','perfect',64)
```
The `event()` function is modelled after the Google Analytics send event method, i.e. event category and action are required and event label and value are optional.

### Notes

- The data to be sent via the `event()` function cannot exceed 128 bytes.
- Obviously, event tracking will only work with the HTML version of your games.
- If you host your game on pages like itch.io (i.e. where your game is embedded via iFrame) you should:  
  - set the cookie option of the analytics snippet to 'none' (as in [`example-analytics-snippet.js`](./example-analytics-snippet.js).
  - use a separate Google Analytics property, because otherwise you will get a duplicate user count from your itch game page (if you use tracking there) and the actual iFrame of the game.
  - be aware that with some browsers (Safari) tracking via an embedded iFrame might not work.

### Tips for testing

- Testing from a local html file (e.g. your-game.html) won't work since Google Analytics will block such requests.
- Instead, either
   - upload the game files to a server (or itch page) and test from there
   - or run a local webserver. A simple solution can be [`local-web-server`](https://www.npmjs.com/package/local-web-server) (installed via npm).
- You can use this excellent [Google Analytics Debugger](https://chrome.google.com/webstore/detail/google-analytics-debugger/jnkmfdileelhofjcijamephohjechhna?hl=de) with Google Chrome to check for problems with your analytics snippet and to see if the event hits are fired correctly. [Here](https://twitter.com/mtths_flk/status/1045647528811798528) is a short video of the example cart with the Analytics Debugger in action.


## Feedback
You can use the [issue tracker](https://github.com/mtthsflk/pico8-google-analytics/issues) for feedback and requests.