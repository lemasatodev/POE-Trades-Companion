### The README.md is being reworked and some parts will be missing for now.  
&nbsp;  

<a href="https://www.paypal.me/masato/"><img src="https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/others/Banners/Donate using PayPal.png" height=40></a> <!-- Paypal Banner -->  
[paypal.me/masato](https://www.paypal.me/masato) - [Alternative paypal cart button](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=BSWU76BLQBMCU)
    
POE Trades Companion is and will always be free to use.  
Your name will appear on a special "Hall of Fame" tab within the application and also on [this page](https://github.com/lemasato/POE-Trades-Companion/wiki/Support)!  

Join the official discord channel!  
<a href="https://discord.gg/UMxqtfC"><img src="https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/resources/imgs/Discord_big.png" height=50></a>

If needed, you can contact me on:  
<a href="https://www.pathofexile.com/forum/view-thread/1755148/"><img src="https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/resources/imgs/POE_big.png" height=30></a>&nbsp;&nbsp;&nbsp;
<a href="https://discord.gg/UMxqtfC"><img src="https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/resources/imgs/Discord_big.png" height=30></a>&nbsp;&nbsp;&nbsp;
<a href="https://www.reddit.com/user/lemasato/submitted/"><img src="https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/resources/imgs/Reddit_big.png" height=30></a>  

***

## Usage
- Download and install [AutoHotKey](https://autohotkey.com/download/) from the official website.  
- Download and extract [POE-Trades-Companion-AHK.zip](https://github.com/lemasato/POE-Trades-Companion/releases) from the releases page.  
- Run POE Trades Companion.ahk  

You can access the Settings menu by right clicking the icon.  
**[POE Trades Companion Wiki Page](https://github.com/lemasato/POE-Trades-Companion/wiki)**  

You could also download the executable but some protections are flagging it as malicious.  

## Key Features  
- **Keep track of your incoming trading whispers in a convenient interface.**  
With the tabbing system, you will know exactly what to look at and where.  
- **Up to 9 customizable buttons + 5 smaller predefined buttons**
Custom buttons can have multiple actions, be renamed, moved, resized or disabled. 
The smaller buttons are set to perform predefined actions (Copy item name / Whisper buyer / Party invite / Trade request / Party kick). These can also be moved and disabld.
- **Hotkeys**
An infinite amount of hotkeys can be created.  
By default, pressing F2 will teleport you to your hideout.  
- **Quickly communicate with your buyer.**  
Using the `%buyer%`, `%item%`, `%price%` variables in your messages, communication is even faster.  
- **Find the desired items in seconds.**  
With the precise Item Grid overlay, you will be able to find your item as fast as possible.  
Works with premium stash tabs, premium quad stash tabs, and the map stash tab.  
Requires no set-up from the user. All automated.  
- **Price check against scammers.**  
Compare your item's price on poe.trade with the price sent in the whisper to avoid scammers that change the price in the whisper.  
- **Path of Exile themed skin.**  
Additionally, two simplistic skins "White" and its night counterpart "Dark Blue" are available.  
- **Tab color codes.**  
When your buyer joins your area, his corresponding tab colour will turn green.  
This allows to know which trades should be prioritized first.  
Additionally, a tab will turn purple if you receive another whisper from the same person.  
All whispers from the buyer can be seen from the interface.  
- **Sound notifications.**  
Play custom sound files upon receiving a trading whisper / regular whisper / when the buyer joins your area.  
- **PushBullet notifications.**  
Receive notifications on your phone when receiving trading whispers.  
You may also enable these notifications only if you are AFK in game.  
- **Tabbed notifications.**  
Receive a notification on your screen when you receive a whisper while tabbed out of the game.  
- **Instantly send a trading whisper upon copying.**  
If you are holding CTRL upon copying a trading whisper, it will automatically be sent in-game upon releasing.  
You can press SPACE when the pop-up appears to prevent this behaviour.  
- **Minimized / Maximized states**  
While minimized, the interface takes much less space on your screen.  
- **Completely hide the interface when all tabs are closed.**  
By setting the "No tab remaining" transparency to 0 and enabling the "click-through" setting, the interface will be effectively invisible.  
- **Take a look at your previously completed trades**  
Closing a tab with a button containing the "Save trade stats" action will add it to the "My Stats" interface.  
- **Automatic updates.**  
Receive a notification when an update is available.  
The entire updating process is automated.  

***

## Skins

|Path of Exile|White|Dark Blue|  
|---|---|---|  
|Based on Path of Exile, blends perfectly with the game.|A sleek, simplistic combination of white and blue|The "night" alternative to the White skin.|
|![](https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/resources/skins/Path%20of%20Exile/Preview.png)|![](https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/resources/skins/White/Preview.png)|![](https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/resources/skins/Dark%20Blue/Preview.png)

If interested, you may as well **[make your own skin](https://github.com/lemasato/POE-Trades-Companion/wiki/Creating-Your-Skin)**

***

## Interface

<img src="https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/screenshots/Main%20interface.png">

## Price checking

Price checking compares your item's price on poe.trade and the price in the whisper.  
This features allows to avoid scammers that edit the price before sending the whisper.  

It can be done by clicking the grey dot as shown in the screenshot above.  

After verifying an item's price, the dot will change color based on the results.  
Green means the price matches or is in your favour.  
Orange means an error occured.  
Red means the price is different.  

## Item location grid

See the exact position of your item in your stash.
Entirely automated, does not require user setup.

Requires to press a button with the "Show item location grid" action.
On default settings, this occurs when pressing the "Invite to Party" button.

By default, both normal and quad tab locations are shown. If you wish, you can choose to hide one or another from the Settings.
If the item is detected to be a map, only the map stash tab will be shown. If you do not own this special tab, you can re-enable normal and quad locations for map items.

Note that this feature also shows your item name and stash tab name to make finding even easier.

<img src=https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/screenshots/ItemGrid%20Maps.png width=300> <img src=https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/screenshots/ItemGrid%20Normal.png width=300>

## Easily trade currency with an hotkey  

For currency trades, you can take advantage of a special built-in hotkey.  
It allows you to get just the right amount of currency asked.  

**Press Ctrl+RightClick while hovering the currency type.**  
Based on the currency max stack and the amount requested, it will move a stack of currency in your inventory (like Ctrl+Click) or put the currency on your cursor (like Shift+Click).  

For example, your buyer requests 56 chaos orbs.  
Chaos orbs are stacked by 10.  
This means you will have to Ctrl+RightClick at least 6 times to get the currency requested.  
The first 5 clicks will act as Ctrl+Click (moving 5 stacks on your inventory) and the last 6th one will serve as "Shift+Click, send 6, send Enter" to put the last remaining 6 chaos on your cursor.

While it should be safe to "spam" this hotkey (because there are some countermeasure to prevent you from taking too much of said currency in case of lag, and once you've got enough of said currency the hotkey will notify you) some issues can happen with in-game latency.  

(.gif will come later to showcase this feature more easily)

## Stats

**Coming later**

## Settings 

*Pictures have been hidden. Click on each message to show them*

<a href="https://github.com/lemasato/POE-Trades-Companion/wiki/How-to-use#customizing-buttons">Wiki: Customizing buttons</a>
<br><a href="https://github.com/lemasato/POE-Trades-Companion/wiki/How-to-use#explaining-some-actions
">Wiki: Explaining some actions</a>
<br><a href="https://github.com/lemasato/POE-Trades-Companion/wiki/How-to-use#variables">Wiki: Variables</a>

<details>
    <summary>Settings Main tab
    <br>Set the behaviour of the interface.</summary>
        <img src="https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/screenshots/Settings 1-Main.png">
</details>
&nbsp;  
    
<details>
    <summary>Customization Skins tab
    <br>Change the skin, or adjust it to your likings.</summary>
        <img src="https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/screenshots/Settings 2-Skins.png">
</details>
&nbsp;  
    
<details>
    <summary>Customization Buttons tab
    <br>Move, disable, rename, customize your buttons.</summary>
        <img src="https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/screenshots/Settings 3-Buttons.png">
</details>
&nbsp;  
    
<details>
    <summary>Hotkeys Basic tab
    <br>Set-up simple hotkeys limited to one action.</summary>
        <img src="https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/screenshots/Settings 4-Basic.png">
</details>
&nbsp;  

<details>
    <summary>Hotkeys Advanced tab
    <br>Set-up advanced hotkeys that can perform multiple actions.
    <br>Some keys are not compatible with the hotkey control.
    <br>In such cases, switch to a manual hotkey by using the "HK Type Switch" button.
    <br>https://autohotkey.com/docs/Hotkeys.htm
    <br>https://autohotkey.com/docs/KeyList.htm</summary>
        <img src="https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/screenshots/Settings 5-Advanced.png">
</details>
&nbsp;  
    
<details>
    <summary>Available actions
    <br>Note that "Custom Buttons" actions are only available for hotkeys.
    <br>This allows you to bind an hotkey to a Custom Button.</summary>
        <img src="https://raw.githubusercontent.com/lemasato/POE-Trades-Companion/master/others/Help/Settings 6-Actions List.png">
</details>
