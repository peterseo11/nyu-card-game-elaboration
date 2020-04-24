/// @description creating, sorting, and tracking cards
global.deck = ds_list_create(); //sorts the deck of cards
global.discard_pile = ds_list_create(); //sorts discarded cards

global.hand_player = ds_list_create(); //sorts player hand
global.hand_computer = ds_list_create(); //sorts computer hand.

//manual timers
deal_timer = 0;
computer_timer = 0
eval_time = 0;
eval_wait_time = 0;
time_to_discard = 0;
reshuffle_time = 0;

//card types
global.rock = 0;
global.paper = 1
global.scissors = 2;

//scores
global.player_score = 0;
global.computer_score = 0;

//main game states
global.current_game_state = 0;
//different states 
global.dealing = 0;
global.computer_choosing = 1;
global.player_choosing = 2;
global.evaluate_cards = 3;
global.discard_wait = 4;
global.discard = 5;
global.reshuffle_to_deck = 6;
global.max_deck_cards= 24;

//loop to assign card values and attributes.
for(var counter = 0 ; counter < global.max_deck_cards; counter++){
    var new_card = instance_create_layer(x,y, "Instances", obj_card); //create card
	//assigning card positions (x,y)
 	new_card.target_x = 96;
	new_card.target_y = 0;
    // define what type of card it should be
    new_card.type = floor(3 * counter / global.max_deck_cards); //floor rounds down the value from equation.
  
    new_card.face_up = false; //set the card face down when card is made
	ds_list_add(global.deck, new_card);
}


randomize();

ds_list_shuffle(global.deck);

//loop to stack each card in proper positioning.
for(var counter = 0 ; counter < global.max_deck_cards; counter++){
    var chosen_card = global.deck[|counter];
    chosen_card.depth = -counter;
	//chosen_card.y -= counter * 2;
	chosen_card.target_y = 450 - 4*counter;
}

