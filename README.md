This project based fork at https://github.com/ripps818/palworld-wine I merged my favorite scripts created by [jammsen](https://github.com/jammsen/docker-palworld-dedicated-server) into that project.It will probably make your server setup easier and simpler.

# Requirements
Everyone knows you need a Linux computer. Also, please have basic knowledge of getting Docker working and preferably using docker compose.

# Getting started
1. Copy ".env.bak" file to ".env"
2. Customize .env file (Please be sure to specify admin password) follow [ENV](#ENV)
3. Edit docker-compose.yml if you want
4. Build Docker image `docker-compose build`
5. Run Docker image `docker-compose up -d`


# ENV
| Variable Name| Default Value | Description |
|------------------------------------------|---------------------|-------------------------------------------------------------------------------------------------------|
| SERVER_SETTINGS_MODE | auto| Mode for server settings (auto/manual) |
| WEBHOOK_ENABLED| false | Enable or disable Discord webhook notifications|
| WEBHOOK_URL| | URL for Discord webhook (empty if disabled)|
| WEBHOOK_START_TITLE| Server is starting| Title for start webhook notification |
| WEBHOOK_START_DESCRIPTION| The gameserver is starting | Description for start webhook notification|
| WEBHOOK_START_COLOR| 2328576 | Color code for start webhook notification|
| WEBHOOK_STOP_TITLE | Server has been stopped | Title for stop webhook notification |
| WEBHOOK_STOP_DESCRIPTION | The gameserver has been stopped | Description for stop webhook notification|
| WEBHOOK_STOP_COLOR | 7413016 | Color code for stop webhook notification |
| WEBHOOK_INFO_TITLE | Info| Title for info webhook notification |
| WEBHOOK_INFO_DESCRIPTION | This is an info from the server | Description for info webhook notification |
| WEBHOOK_INFO_COLOR | 2849520 | Color code for info webhook notification |
| NETSERVERMAXTICKRATE| 120 | Maximum tick rate for the server network |
| DIFFICULTY | None| Difficulty setting for the PalWorld server|
| DAYTIME_SPEEDRATE| 1.000000| Multiplier for day time speed |
| NIGHTTIME_SPEEDRATE| 1.000000| Multiplier for night time speed |
| EXP_RATE | 1.000000| Multiplier for player XP gain from actions|
| PAL_CAPTURE_RATE | 1.000000| Probability of players capturing Pals |
| PAL_SPAWN_NUM_RATE | 1.000000| Rate of Pal appearance|
| PAL_DAMAGE_RATE_ATTACK | 1.000000| Multiplier for damage inflicted by Pals |
| PAL_DAMAGE_RATE_DEFENSE| 1.000000| Multiplier for damage taken by Pals |
| PLAYER_DAMAGE_RATE_ATTACK| 1.000000| Multiplier for damage inflicted by players|
| PLAYER_DAMAGE_RATE_DEFENSE | 1.000000| Multiplier for damage taken by players|
| PLAYER_STOMACH_DECREASE_RATE | 1.000000| Rate of decrease in player hunger |
| PLAYER_STAMINA_DECREACE_RATE| 1.000000| Rate of decrease in player stamina|
| PLAYER_AUTO_HP_REGENE_RATE | 1.000000| Rate of player health regeneration|
| PLAYER_AUTO_HP_REGENE_RATE_IN_SLEEP| 1.000000| Rate of player health regeneration while sleeping |
| PAL_STOMACH_DECREACE_RATE| 1.000000| Rate of decrease in Pal hunger|
| PAL_STAMINA_DECREACE_RATE| 1.000000| Rate of decrease in Pal stamina |
| PAL_AUTO_HP_REGENE_RATE| 1.000000| Rate of Pal health regeneration|
| PAL_AUTO_HP_REGENE_RATE_IN_SLEEP | 1.000000| Rate of Pal health regeneration while sleeping|
| BUILD_OBJECT_DAMAGE_RATE | 1.000000| Damage rate to objects|
| BUILD_OBJECT_DETERIORATION_DAMAGE_RATE | 1.000000| Rate of damage to items outside of the base |
| COLLECTION_DROP_RATE | 1.000000| Rate of items gathered from nodes |
| COLLECTION_OBJECT_HP_RATE| 1.000000| Hits a node can take|
| COLLECTION_OBJECT_RESPAWN_SPEED_RATE | 1.000000| Speed of node respawn |
| ENEMY_DROP_ITEM_RATE | 1.000000| Rate of items dropped by enemies|
| DEATH_PENALTY| Item| Type of penalty upon player death (None, Item, ItemAndEquipment, All) |
| ENABLE_PLAYER_TO_PLAYER_DAMAGE | False | Enable server PvP damage|
| ENABLE_FRIENDLY_FIRE | False | Enable damage from friendly fire |
| ENABLE_INVADER_ENEMY | False | Enable raids|
| ACTIVE_UNKO| False | Unknown |
| ENABLE_AIM_ASSIST_PAD| True| Enable aim assist for controllers|
| ENABLE_AIM_ASSIST_KEYBOARD | False | Enable aim assist for keyboard |
| DROP_ITEM_MAX_NUM| 3000| Maximum number of dropped items at once |
| DROP_ITEM_MAX_NUM_UNKO | 100 | Maximum number of dropped items at once (UNKO)|
| BASE_CAMP_MAX_NUM| 128 | Maximum number of bases that can be built |
| BASE_CAMP_WORKER_MAXNUM| 20| Maximum number of Pals per base |
| DROP_ITEM_ALIVE_MAX_HOURS| 1.000000| Duration for dropped items to last|
| AUTO_RESET_GUILD_NO_ONLINE_PLAYERS | False | Enable wipe for inactive guilds |
| AUTO_RESET_GUILD_TIME_NO_ONLINE_PLAYERS| 72.000000 | Time period for wiping inactive guilds|
| GUILD_PLAYER_MAX_NUM | 20| Maximum number of players per guild |
| PAL_EGG_DEFAULT_HATCHING_TIME| 72| Time taken to hatch huge eggs |
| WORK_SPEED_RATE| 1.000000| Rate of Pals' work speed|
| IS_MULTIPLAY | False | Enable multiple characters per player |
| IS_PVP | False | Enable server Player vs Player|
| CAN_PICKUP_OTHER_GUILD_DEATH_PENALTY_DROP| False | Enable picking up enemy guild items on death|
| ENABLE_NON_LOGIN_PENALTY | True| Enable penalty for non-login players|
| ENABLE_FAST_TRAVEL | True| Enable fast travel|
| IS_START_LOCATION_SELECT_BY_MAP | True| Enable selection of start location by map |
| EXIST_PLAYER_AFTER_LOGOUT| False | Retain player presence after logout |
| ENABLE_DEFENSE_OTHER_GUILD_PLAYER| False | Enable defense against other guild players|
| COOP_PLAYER_MAX_NUM| 4 | Maximum number of players for cooperative play|
| MAX_PLAYERS| 16| Server player cap |
| SERVER_NAME| Moded Pal World | PalWorld server name|
| SERVER_DESCRIPTION | This_Server_is_running_on_LINUX_with_UE4SS | PalWorld server description|
| ADMIN_PASSWORD | | PalWorld server admin password (empty if none) |
| SERVER_PASSWORD| | PalWorld server password (empty if none)|
| PUBLIC_PORT| 8211| PalWorld server port|
| PUBLIC_IP| | PalWorld server IP (empty if none)|
| RCON_ENABLED | True| Enable RCON for server commands |
| RCON_PORT| 25575 | RCON access port|
| REGION | | Server region location|
| USEAUTH| True| Enable server authentication|
| BAN_LIST_URL | https://api.palworldgame.com/api/banlist.txt | URL for the ban list in PalWorld server |
