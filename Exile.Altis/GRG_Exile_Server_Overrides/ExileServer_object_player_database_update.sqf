/**
 * ExileServer_object_player_database_update
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. 
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 */
 
private["_player", "_playerID", "_playerPos", "_data", "_extDB2Message"];
_player = _this;
_playerID = _player getVariable["ExileDatabaseID", -1];
_playerPos = getPosATL _player;
_data = 
[
	_player getVariable ["ExileName",""],
	damage _player,
	_player getVariable ["ExileHunger", 100],
	_player getVariable ["ExileThirst", 100],
	_player getVariable ["ExileAlcohol", 0],
	getOxygenRemaining _player,
	getBleedingRemaining _player,
	_player call ExileClient_util_player_getHitPointMap,
	getDir _player,
	_playerPos select 0,
	_playerPos select 1,
	_playerPos select 2,
	assignedItems _player,
	backpack _player,
	(getItemCargo backpackContainer _player) call ExileClient_util_cargo_getMap,
	(backpackContainer _player) call ExileClient_util_cargo_getMagazineMap,
	(getWeaponCargo backpackContainer _player) call ExileClient_util_cargo_getMap,
	currentWeapon _player,
	goggles _player,
	handgunItems _player,
	handgunWeapon _player,
	headgear _player,
	binocular _player,
	_player call ExileClient_util_inventory_getLoadedMagazinesMap,
	primaryWeapon _player,
	primaryWeaponItems _player,
	secondaryWeapon _player,
	secondaryWeaponItems _player,
	uniform _player,
	(getItemCargo uniformContainer _player) call ExileClient_util_cargo_getMap,
	(uniformContainer _player) call ExileClient_util_cargo_getMagazineMap,
	(getWeaponCargo uniformContainer _player) call ExileClient_util_cargo_getMap,
	vest _player,
	(getItemCargo vestContainer _player) call ExileClient_util_cargo_getMap,
	(vestContainer _player) call ExileClient_util_cargo_getMagazineMap,
	(getWeaponCargo vestContainer _player) call ExileClient_util_cargo_getMap,
	_player getVariable ["ExileTemperature", 0],
	_player getVariable ["ExileWetness", 0],
	_playerID
];
_extDB2Message = ["updatePlayer", _data] call ExileServer_util_extDB2_createMessage;
_extDB2Message call ExileServer_system_database_query_fireAndForget;

// Update level 7 trading info if needed
// Calculate Time Remaining
private _level7LastChecked = _player getVariable["level7LastChecked",0];
private _timeElapsed = diag_tickTime - _level7LastChecked;
private _level7timeRemaining = (_player getVariable["level7",0]) - _timeElapsed;
if (_level7timeRemaining > 0) then 
{
	_player setVariable["level7",_level7timeRemaining];
	_player setVariable["level7LastChecked",diag_tickTime];

	// Update Dabase 
	format["updatePlayerLevel7:%1:%2",_level7timeRemaining,getPlayerUID _player] call ExileServer_system_database_query_fireAndForget;
} else {
	_player setVariable["level7",0];
	_player setVariable["level7Lastchecked",diag_tickTime];
};
// Send info to update client variables 
//[_player,"updateLevel7TimeRemainingRequest", [_plyaer,_level7timeRemaining]] call ExileServer_system_network_send_to; 
//[_plyaer,_level7timeRemaining] call ExileServer_GRGApps_network_updateLevel7TradingTimeRequest;

// Log updated info
//diag_log format["ExileServer_object_player_database_update: updating level7 info for player %1 to %2",_player,_player getVariable["level7",-1]];

true