/// @description Insert description here
// You can write your code in this editor

//changing card faces.
if(face_up)
{
	if(type == global.rock)
		sprite_index = spr_rock;	
	
	if(type == global.paper)
		sprite_index = spr_paper;
		
	if(type == global.scissors)
		sprite_index = spr_scissors;
} else {
	sprite_index = spr_cardback;	
	
}


if(x!= target_x){
	x = lerp(x, target_x, 0.25);
}
if(y!= target_y){
	y = lerp(y, target_y, 0.25);
}
