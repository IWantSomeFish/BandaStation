/obj/item/clothing/gloves/skyfall
	name = "Skyfall Watch"
	desc = "Элегантные часы с титановым корпусом, вершина дизайна корпорации SELF. Созданы для доказательства того, что машины также способны творить шедевры искусства"
	icon = 'modular_bandastation/objects/icons/obj/clothing/accessories.dmi'
	worn_icon = 'modular_bandastation/objects/icons/mob/inhands/skyfall_hands.dmi'
	gender = NEUTER
	w_class = WEIGHT_CLASS_SMALL
	icon_state = "skyfall_watch"
	inhand_icon_state = null
	worn_icon_state = "skyfall_watch"
	body_parts_covered = 0
	resistance_flags = list(FIRE_PROOF, ACID_PROOF)
	clothing_traits = list(TRAIT_FINGERPRINT_PASSTHROUGH)
	siemens_coefficient = 1

/obj/item/clothing/gloves/skyfall/examine(mob/user)
	. = ..()
	. += span_notice("Сейчас время: <b>[station_time_timestamp()]</b>.")

/obj/item/clothing/gloves/skyfall/syndi
	desc = "Элегантные часы с титановым корпусом, вершина дизайна корпорации SELF. Созданы для доказательства того, что машины также способны творить шедевры искусства. Эта модель имеет несколько коннекторов для подключения неизвестных устройств."
	var/CHIP_SLOTS = 2
	var/chips = list()
	actions = list()
	action_slots = ITEM_SLOT_GLOVES

/obj/item/clothing/gloves/skyfall/syndi/Initialize(mapload)
	. = ..()
	if(!mapload)
		chips = list()
		actions = list()
	register_context()

/obj/item/clothing/gloves/skyfall/syndi/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	var/result = NONE
	if(isnull(held_item))
		if(length(chips) > 0)
			context[SCREENTIP_CONTEXT_CTRL_LMB] = "Извлечь чип"
			result = CONTEXTUAL_SCREENTIP_SET
	else
		if(istype(held_item,/obj/item/skyfall_chip))
			if(length(chips) < CHIP_SLOTS)
				context[SCREENTIP_CONTEXT_LMB] = "Вставить чип"
				result = CONTEXTUAL_SCREENTIP_SET
	return result

/obj/item/clothing/gloves/skyfall/syndi/examine(mob/user)
	. = ..()
	. += span_notice("Установлено чипов: [length(chips)].")

/obj/item/clothing/gloves/skyfall/syndi/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()

	if(length(chips) >= CHIP_SLOTS)
		to_chat(user, span_warning("Нет свободных слотов для чипов."))
		return ITEM_INTERACT_BLOCKING
	if(istype(tool,/obj/item/skyfall_chip))
		for(var/obj/item/skyfall_chip/chip in chips)
			if(istype(chip, tool))
				to_chat(user, span_warning("Этот чип уже установлен."))
				return ITEM_INTERACT_BLOCKING
		user.transferItemToLoc(tool, src)
ч		LAZYADD(chips, tool)
		LAZYADD(actions, get_chip_actions(tool))
		for (var/datum/action/item_action/action in get_chip_actions(tool))
			action.Grant(user)
		playsound(src,pick('sound/machines/pda_button/pda_button1.ogg','sound/machines/pda_button/pda_button2.ogg'), 50, FALSE)
		to_chat(user, span_notice("[tool.name] успешно установлен."))
		return ITEM_INTERACT_SUCCESS
	else
		to_chat(user, span_warning("Этот предмет не может быть установлен в Skyfall Watch."))
		return ITEM_INTERACT_BLOCKING

/obj/item/clothing/gloves/skyfall/syndi/item_ctrl_click(mob/living/user)
	. = ..()


	if(length(chips) == 0)
		to_chat(user, span_warning("В Skyfall Watch нет установленных чипов."))
		return CLICK_ACTION_BLOCKING
	if(!check_interactable(user))
		return CLICK_ACTION_BLOCKING

	var/obj/item/skyfall_chip/chip = tgui_input_list(user, "Выберите извлекаемый чип", "Чипы Skyfall", chips, null)

	if(isnull(chip))
		return CLICK_ACTION_BLOCKING

	try_put_in_hand(chip, user)
	LAZYREMOVE(chips, chip)
	LAZYREMOVE(actions, get_chip_actions(chip))
	for (var/datum/action/item_action/action in get_chip_actions(chip))
		action.Remove(user)
	playsound(src,pick('sound/machines/pda_button/pda_button1.ogg','sound/machines/pda_button/pda_button2.ogg'), 50, FALSE)
	to_chat(user, span_notice("[chip.name] извлечен из Skyfall Watch."))
	return CLICK_ACTION_SUCCESS

/obj/item/clothing/gloves/skyfall/syndi/proc/try_put_in_hand(obj/item/object, mob/living/user)
	if(!issilicon(user) && in_range(src, user))
		object.do_pickup_animation(user, src)
		user.put_in_hands(object)
	else
		object.forceMove(drop_location())

/obj/item/clothing/gloves/skyfall/syndi/proc/check_interactable(mob/living/user)
	PRIVATE_PROC(TRUE)
	return user.can_perform_action(src, ALLOW_SILICON_REACH | FORBID_TELEKINESIS_REACH)

/obj/item/clothing/gloves/skyfall/syndi/proc/get_chip_actions(obj/item/skyfall_chip/chip)
	return chip.actions
