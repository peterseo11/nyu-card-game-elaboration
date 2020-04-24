/// @description checking states

deal_timer += 1;
if (deal_timer == 20) {
	deal_timer = 0;
}

switch(global.current_game_state){
	case(global.dealing):
		if(deal_timer == 0){
			if(ds_list_size(global.hand_computer) < 3){ //if comp has < 3 in hand - add to hand
			
				var last_card_val = ds_list_size(global.deck) - 1;
				var card_to_deal = global.deck[|last_card_val] //gets 24th card.
			
				ds_list_delete(global.deck, last_card_val); //delete card from deck list.
				ds_list_add(global.hand_computer, card_to_deal); //add card to computer list.
			
				//positioning code
				card_to_deal.target_x = 140 + 100 * ds_list_size(global.hand_computer); //90 pix from the left side of screen; 44 pixels apart
				card_to_deal.target_y = 100;
				audio_play_sound(snd_cardmove, 90, false);
			}else if(ds_list_size(global.hand_player) < 3){ //if comp has < 3 in hand - add to hand
			
				var last_card_val = ds_list_size(global.deck) - 1;
				var card_to_deal = global.deck[|last_card_val] //gets 24th card.
			
				ds_list_delete(global.deck, last_card_val); //delete card from deck list.
				ds_list_add(global.hand_player, card_to_deal); //add card to computer list.
			
				//positioning code
				card_to_deal.target_x = 140 + 100 * ds_list_size(global.hand_player); //90 pix from the left side of screen; 44 pixels apart
				card_to_deal.target_y = 668;
				card_to_deal.face_up = true;
				audio_play_sound(snd_cardmove, 90, false);
			}		
			
			if(ds_list_size(global.hand_computer) == 3 && ds_list_size(global.hand_player) == 3){
				global.current_game_state = global.computer_choosing;
			}
		}
		
		break; //end case
		
	case(global.computer_choosing):
	show_debug_message("computer deciding...");
		computer_timer +=1;
		if(computer_timer == 20){
			var ran_compu_card = choose(0,1,2);
			var compu_card = global.hand_computer[|ran_compu_card];
			
			computer_card = ran_compu_card;
			
			//positioning code
			compu_card.target_x = room_width/2;
			compu_card.target_y = 300;
			audio_play_sound(snd_cardmove, 90, false);
			
			computer_timer = 0; //reset timer
			global.current_game_state = global.player_choosing;
		}
		
		break; //end case
		
	case(global.player_choosing): //player turn...
	show_debug_message("choosing...");
		var card_pressed = instance_position(mouse_x, mouse_y, obj_card)
		if(card_pressed != noone){ //if hand hovering card
			
				if(mouse_check_button_pressed(mb_left)){
				var p_card = ds_list_find_index(global.hand_player, card_pressed); //finds value in player hand
				
				player_card = p_card;
				
					if (p_card >= 0){	//if card is any of the states...
						//positioning code.
						card_pressed.target_x = room_width/2;
						card_pressed.target_y = 468;
						audio_play_sound(snd_cardmove, 90, false);
					global.current_game_state = global.evaluate_cards;
					
				}
			}
		}
	
		break;
		
	case(global.evaluate_cards):
	show_debug_message("evaluating...");
		eval_time += 1; //wait time for evaluation/reveal.
		if(eval_time > 45){
			show_debug_message("reveal!"); 
			var com_card = ds_list_find_value(global.hand_computer, computer_card); //find value of the computer's selected card
			var p_card = ds_list_find_value(global.hand_player, player_card);
			com_card.face_up = true; //reveal computer card
				
			if(com_card.type == global.rock){ //if opponent is rock
				
				if(p_card.type == global.paper){ //if player is paper
					global.player_score += 1; //add point
					audio_play_sound(snd_player_point, 90, false);
					audio_play_sound(snd_paper, 90, false);
					instance_create_depth(55,173,1,obj_win);
					
				}
				
				if(p_card.type == global.scissors){ //if player is scissors
					global.computer_score += 1; //add opp point.
					audio_play_sound(snd_comp_point, 90, false);
					audio_play_sound(snd_rock, 90, false);
					instance_create_depth(55,173,1,obj_lose);
					
				}
				
			}
			
			if(com_card.type == global.paper){ //if opp is paper
				
				if(p_card.type == global.scissors){ //if player is scissors
					global.player_score += 1; //add point
					audio_play_sound(snd_player_point, 90, false);
					audio_play_sound(snd_scissors, 90, false);
					instance_create_depth(55,173,1,obj_win);
				}
				
				if(p_card.type == global.rock){ //if opp is rock.
					global.computer_score += 1; // add opp point
					audio_play_sound(snd_comp_point, 90, false);
					audio_play_sound(snd_paper, 90, false);
					instance_create_depth(55,173,1,obj_lose);
				}
			}
			
			if(com_card.type == global.scissors){ //if opp is scissors
				
				if(p_card.type == global.rock){ //if player is rock
					global.player_score += 1; //add point
					audio_play_sound(snd_player_point, 90, false);
					audio_play_sound(snd_rock, 90, false);
					instance_create_depth(55,173,1,obj_win);
				}
				
				if(p_card.type == global.paper){ //if player is paper
					global.computer_score += 1; //add opp point.
					audio_play_sound(snd_comp_point, 90, false);
					audio_play_sound(snd_scissors, 90, false);
					instance_create_depth(55,173,1,obj_lose);
				}
			}	
			
			global.current_game_state = global.discard_wait;
			
			
		}
		
		break; //finish eval phase
		
	case(global.discard_wait):
		eval_wait_time += 1;
		if(eval_wait_time > 45){
			global.current_game_state = global.discard
			eval_wait_time = 0;
		}
		
	break;
		
	case(global.discard): 
	show_debug_message("discarding");
	eval_time = 0;
		time_to_discard += 1; //wait before discarding
		if(time_to_discard > 10){ //after waiting
			//code to remove chosen card first before the hand. COMPUTER.
			if(ds_list_size(global.hand_computer) == 3){ //if computer has all 3 cards
			//get value for chosen card
				var com_card = ds_list_find_value(global.hand_computer, computer_card);
			//remove the chosen card from their hand list
				ds_list_delete(global.hand_computer, computer_card);
			//add the chosen card to discard list.
				ds_list_add(global.discard_pile, com_card);
			//move the chosen card to discard pile position.
				com_card.target_x = 585;
				com_card.target_y = 450 - 4*ds_list_size(global.discard_pile);
				com_card.face_up = false;
				com_card.depth = -ds_list_size(global.discard_pile);
				audio_play_sound(snd_cardmove, 90, false);
				
			} else if(ds_list_size(global.hand_player) == 3){ //if computer has all 3 cards
			//get value for chosen card
				var p_card = ds_list_find_value(global.hand_player, player_card);
			//remove the chosen card from their hand list
				ds_list_delete(global.hand_player, player_card);
			//add the chosen card to discard list.
				ds_list_add(global.discard_pile, p_card);
			//move the chosen card to discard pile position.
				p_card.target_x = 585;
				p_card.target_y = 450 - 4*ds_list_size(global.discard_pile);
				p_card.face_up = false;
				p_card.depth = -ds_list_size(global.discard_pile);
				audio_play_sound(snd_cardmove, 90, false);
				
			}else if(ds_list_size(global.hand_computer) > 0){ //if they still have cards in hand.
				var com_card = ds_list_find_value(global.hand_computer, 0);
				//delete cards from hand list.
				ds_list_delete(global.hand_computer, 0);
				//add hand cards to discard list.
				ds_list_add(global.discard_pile, com_card); //using com_card value 
				//position cards to discard pile.
				com_card.target_x = 585;
				com_card.target_y = 450 - 4*ds_list_size(global.discard_pile);
				com_card.face_up = false;
				com_card.depth = -ds_list_size(global.discard_pile);
				audio_play_sound(snd_cardmove, 90, false);
				
			}else if(ds_list_size(global.hand_player) > 0){ //if they still have cards in hand.
				var p_card = ds_list_find_value(global.hand_player, 0);
				//delete cards from hand list.
				ds_list_delete(global.hand_player, 0);
				//add hand cards to discard list.
				ds_list_add(global.discard_pile, p_card); //using p_card value 
				//position cards to discard pile.
				p_card.target_x = 585;
				p_card.target_y = 450 - 4*ds_list_size(global.discard_pile);
				p_card.face_up = false;
				p_card.depth = -ds_list_size(global.discard_pile);
				audio_play_sound(snd_cardmove, 90, false);
				
			}else{
				if(ds_list_size(global.deck) > 0){
					global.current_game_state = global.dealing;
				}else{
					global.current_game_state = global.reshuffle_to_deck;
				}
			
			}
		time_to_discard = 0;
		
		}
		
		break; //finish discard loop phase
	
	case(global.reshuffle_to_deck):
	show_debug_message("reshuffling to main deck");
		reshuffle_time += 1; //wait before reshuffling to deck.
		if(reshuffle_time > 2){
			reshuffle_time = 0; //reset time.
		}
		
		//if main deck cards are 0 and reshuffle time is 0
		if(ds_list_size(global.discard_pile) > 0 and reshuffle_time == 0){
			var disc_card = ds_list_find_value(global.discard_pile, 0);
			//remove from discard pile
			ds_list_delete(global.discard_pile, 0);	
			//add values to main deck list.
			ds_list_add(global.deck, disc_card);
			//positioning to main deck area.
			disc_card.target_x = 96;
			disc_card.target_y = 450 - 4*ds_list_size(global.deck);
			audio_play_sound(snd_cardmove, 90, false);
		}
		//if reshuffled and empty discard pile, go back to dealer code & shuffle main deck
		if(ds_list_size(global.discard_pile) == 0){
			global.current_game_state = global.dealing;
		}
}

if(keyboard_check_pressed(ord("R"))){
	room_restart();
}