/datum/station_goal/stormbreaker
	name = "Разрушитель штормов"


/datum/station_goal/stormbreaker/New()
	..()

/datum/station_goal/stormbreaker/get_report()
	return list(
		"#### Разрушитель штормов",
	).Join("\n")


/datum/station_goal/stormbreaker/on_report()
		// var/datum/supply_pack/P = SSshuttle.supply_packs[/datum/supply_pack/engineering/stormbreaker]
		// P.order_flags |= ORDER_SPECIAL_ENABLED

/datum/station_goal/stormbreaker/check_completion()

/obj/machinery/stormbreaker
	name = "Stormbreaker"
	desc = "Разбить стекло в случае апокалипсиса."
	icon = 'modular_bandastation/stormbreaker/icons/stormbreaker.dmi'
	icon_state = "machine_hole"
	density = TRUE
	anchored = TRUE
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 5
	pixel_x = -32
	pixel_y = -64
	light_range = 3
	light_power = 1.5
	var/list/obj/structure/fillers = list()

/obj/machinery/stormbreaker/Initialize(mapload)
	. = ..()
	var/mutable_appearance/shar_underlay = mutable_appearance(icon, "shar", layer = BELOW_OPEN_DOOR_LAYER)
	shar_underlay.color = rgb(120, 180, 255)
	underlays += shar_underlay
	light_color = rgb(120, 180, 255)

	var/list/occupied = list()
	for(var/direct in list(EAST,WEST,SOUTHEAST,SOUTHWEST, SOUTH))
		occupied += get_step(src,direct)

	for(var/T in occupied)
		var/obj/structure/filler/F = new(T)
		F.parent = src
		fillers += F
	AddComponent(/datum/component/seethrough)
