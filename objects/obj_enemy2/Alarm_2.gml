///@desc pick up item

// equip item
if (instance_exists(item_to_pickup)) {
	current_item = item_to_pickup;
	//item_to_pickup.can_be_picked = false;
	// already set before alarm

	detected_item = false;
	picking_up = false;
	item_to_pickup = -1;
}