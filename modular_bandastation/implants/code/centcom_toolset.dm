/obj/item/organ/cyberimp/arm/toolkit/centcom
	name = "Набор инструментов Центрального Командования"
	desc = "Имплант руки, разработанный по заказу Центрального Командования NanoTrasen. Встроенный набор корпоративных инструментов для решения полевых вопросов."
	icon_state = "toolkit_generic"

	actions_types = list(/datum/action/item_action/organ_action/toggle/toolkit)

	items_to_create = list(
		/obj/item/door_remote/omni,
		/obj/item/gun/energy/pulse/pistol/m1911,
		/obj/item/melee/sabre/centcom_sabre,
		/obj/item/stamp/centcom,
		/obj/item/gun/medbeam,
		/obj/item/assembly/flash/armimplant
	)

/obj/item/autosurgeon/centcom
	desc = "Одноразовый автохирург, который содержит аугментацию Центрального Командования NanoTrasen."
	uses = 1
	starting_organ = /obj/item/organ/cyberimp/arm/toolkit/centcom
