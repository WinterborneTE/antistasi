params ["_vehGroup", "_origin", "_dest", "_mrk", "_infGroups", "_duration"];

diag_log format ["QRF - fast rope // veh: %1; origin: %2; destination: %3; mark: %4; inf groups: %5; duration: %6", _vehGroup, _origin, _dest, _mrk, _infGroups, _duration];

private _infGroup1 = _infGroups;
private _infGroup2 = "";

if (typeName _infGroups == "ARRAY") then {
	_infGroup1 = _infGroups select 0;
	_infGroup2 = _infGroups select 1;
	diag_log format ["QRF - fast rope // two inf groups: %1; %2", _infGroup1, _infGroup2];
};

_wp600 = _vehGroup addWaypoint [_dest, 10];
_wp600 setWaypointBehaviour "CARELESS";
_wp600 setWaypointSpeed "FULL";

private _veh = vehicle (units _infGroup1 select 0);

waitUntil {sleep 1; ((not alive _veh) || (speed _veh < 20)) && (_veh distance _dest < 300)};

_infGroup1 call SHK_Fastrope_fnc_AIs;
if (typeName _infGroups == "ARRAY") then {
	sleep 2;
	(_infGroups select 1) call SHK_Fastrope_fnc_AIs;
};

_wp601 = _infGroup1 addWaypoint [getMarkerPos _mrk, 0];
_wp601 setWaypointType "SAD";
_wp601 setWaypointBehaviour "AWARE";
_infGroup1 setCombatMode "RED";

if (typeName _infGroups == "ARRAY") then {
	//0 = [leader _infGroup2, _mrk, "AWARE", "SPAWNED","NOVEH", "NOFOLLOW"] execVM "scripts\UPSMON.sqf";
	_wp602 = _infGroup2 addWaypoint [getMarkerPos _mrk, 0];
	_wp602 setWaypointType "SAD";
	_wp602 setWaypointBehaviour "AWARE";
	_infGroup2 setCombatMode "RED";
};

[_vehGroup, _origin] spawn AS_fnc_QRF_RTB;

sleep _duration;

[_infGroup1, _origin] spawn AS_fnc_QRF_RTB;
if (typeName _infGroups == "ARRAY") then {
	[_infGroup2, _origin] spawn AS_fnc_QRF_RTB;
};