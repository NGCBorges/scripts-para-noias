// por Borges

#include <open.mp>
#include <streamer>
#include <foreach>

#define Azul_Claro	0x33CCFFFF
#define MAX_LABELS  25

enum labelsenum{
	Text3D:Label,
	Time,
	bool:LabelCriado
}
new InfoLabel[MAX_LABELS][labelsenum];
new Iterator:Labels<MAX_LABELS>;

//Callbacks

public OnPlayerConnect(playerid){
	return 1;
}
public OnPlayerDisconnect(playerid, reason){
	if(GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0){
		GerarLabel(playerid, reason);
	}
	return 1;
}
GerarLabel(playerid, reason){
	foreach(new i: Labels){

		if(InfoLabel[i][LabelCriado] && (gettime() - InfoLabel[i][Time]) > 60){ // 60 = 1 minuto.
			DestroyDynamic3DTextLabel(InfoLabel[i][Label]);

			InfoLabel[i][LabelCriado] = false;
			InfoLabel[i][Time] = 0;
			Iter_Remove(Labels, i);
		}

		if(!InfoLabel[i][LabelCriado]){	

			new array[128], Float: x, Float: y, Float: z, hora[3];
			GetPlayerPos(playerid, x, y, z);

			gettime(hora[0], hora[1], hora[2]);
			format(array, sizeof array, "%s desconectou do servidor.\n%2d:%2d\n\n%s", nome(playerid), hora[0], hora[1], GetDisType(reason));	
			
			InfoLabel[i][LabelCriado] = true;
			InfoLabel[i][Label] = CreateDynamic3DTextLabel(array, Azul_Claro, x,y,z,25.0);
			InfoLabel[i][Time] = gettime();
			Iter_Add(Labels, i);
		}
	}
	return 1;
}
GetDisType(reason){
	new texto[16] = "Crash";
	switch(reason){
		case 1: texto = "Vontade Propria";
		case 2: texto = "Kick/Ban";
	}
	return texto;
}
nome(playerid){
	new name[24];
	GetPlayerName(playerid, name, sizeof name);
	return name;
}


//...