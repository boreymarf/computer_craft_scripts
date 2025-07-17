# Lava to Mana

This script was created for the "Liminal Industries" modpack (I added Computer Craft and CC:C Bridge on top of a modpack) for Minecraft, where I decided to use Thermalilies to generate mana for the Botania mod.

The script works very simply:

 1. First, it searches for Redrouters from the CC:C Bridge mod
 2. Optionally searches for *one* monitor
 3. Starts a loop consisting of:
	- Activating a dispenser with a bucket
    - Waiting 30 seconds
    - Calculating the Thermalily's cooldown time
    - Waiting
    - Repeating

It also displays on the monitor how many flowers are currently active and how many lava buckets have been used. The script is quite rough, ugly and has almost no exception handling. Also, instead of using Redroutes from CC:C Bridge mod, you can use Redstone Relay from base CC: Tweaked, you only need to change the peripheral.getType to redstone_relay.