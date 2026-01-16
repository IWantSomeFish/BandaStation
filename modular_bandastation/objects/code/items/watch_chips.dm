/obj/item/skyfall_chip
	name = "Чип для Skyfall Watch"
	desc = "Маленький модуль, предназначенный для вставки в Skyfall Watch. Позволяет расширить функционал часов."
	icon = 'modular_bandastation/objects/icons/obj/items/watch_chip.dmi'
	icon_state = "base_chip"
	w_class = WEIGHT_CLASS_TINY
	action_slots = ITEM_SLOT_GLOVES
	actions_types = list()

/obj/item/skyfall_chip/dagger
	name = "Чип скрытого клинка"
	desc = "Чип, разработанный Donk&Soft, который при установке в Skyfall Watch позволяет активировать энергитический клинок."
	icon_state = "dagger_chip"

/obj/item/skyfall_chip/gun
	name = "Чип импульсного пистолета"
	desc = "Чип, разработанный CyberSun Industries, который при установке в Skyfall Watch позволяет активировать встроенный лазерный пистолет."
	icon_state = "gun_chip"

/obj/item/skyfall_chip/ai
	name = "Чип контроля камер"
	desc = "Чип, позволяющий вам понимать, когда взгляды ИИ направлены на вас, а также подключаться к сети станционных камер."
	icon_state = "ai_chip"
	actions_types = list(/datum/action/itam_action/camera_control)

/datum/action/itam_action/camera_control
	name = "Контроль камер"
	button_icon_state = "round_end"
