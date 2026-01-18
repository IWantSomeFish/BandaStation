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
	actions_types = list(/datum/action/item_action/camera_control)

#define DEFAULT_MAP_SIZE 15

/datum/action/item_action/camera_control
	name = "Контроль камер"
	button_icon_state = "round_end"

	var/list/network = list(CAMERANET_NETWORK_SS13)
	var/obj/machinery/camera/active_camera

	var/turf/last_camera_turf
	var/list/concurrent_users = list()

	var/atom/movable/screen/map_view/camera/cam_screen

/datum/action/item_action/camera_control/Trigger(mob/clicker, trigger_flags)
	. = ..()

	var/map_name = "camera_console_[REF(src)]_map"
	// Convert networks to lowercase
	for(var/i in network)
		network -= i
		network += LOWER_TEXT(i)
	// Initialize map objects
	cam_screen = new
	cam_screen.generate_view(map_name)
	ui_interact(clicker,null)

// Переписать в триггер попробовать
/datum/action/item_action/camera_control/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	if(!user.client)
		return
	ui = SStgui.try_update_ui(user, src, ui)
	update_active_camera_screen()

	if(!ui)
		var/user_ref = REF(user)
		var/is_living = isliving(user)
		if(is_living)
			concurrent_users += user_ref
		if(length(concurrent_users) == 1 && is_living)
			playsound(src, 'sound/machines/terminal/terminal_on.ogg', 25, FALSE)
		ui = new(user, src, "CameraConsole220", name)
		ui.open()
		ui.set_autoupdate(FALSE)
		cam_screen.display_to(user, ui.window)

/datum/action/item_action/camera_control/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(. == UI_DISABLED)
		return UI_CLOSE
	return .

/datum/action/item_action/camera_control/ui_data()
	var/list/data = list()
	data["activeCamera"] = null
	if(active_camera)
		data["activeCamera"] = list(
			name = active_camera.c_tag,
			ref = REF(active_camera),
			status = active_camera.camera_enabled,
		)
	return data

/datum/action/item_action/camera_control/ui_static_data()
	var/list/data = list()
	data["network"] = network
	data["mapRef"] = cam_screen.assigned_map
	data["cameras"] = SScameras.get_available_cameras_data(network)
	return data

/datum/action/item_action/camera_control/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(action == "switch_camera")
		active_camera?.on_stop_watching(src)
		var/obj/machinery/camera/selected_camera = locate(params["camera"]) in SScameras.cameras
		active_camera = selected_camera

		if(isnull(active_camera))
			return TRUE

		active_camera.on_start_watching(src)
		update_active_camera_screen()

		return TRUE

/datum/action/item_action/camera_control/proc/update_active_camera_screen()

	if(!active_camera?.can_use())
		cam_screen.show_camera_static()
		return

	var/list/visible_turfs = list()
	var/new_cam_turf = get_turf(active_camera)
	if(last_camera_turf == new_cam_turf)
		return

	last_camera_turf = new_cam_turf

	var/list/visible_things = active_camera.isXRay(ignore_malf_upgrades = TRUE) ? range(active_camera.view_range, new_cam_turf) : view(active_camera.view_range, new_cam_turf)

	for(var/turf/visible_turf in visible_things)
		visible_turfs += visible_turf

	var/list/bbox = get_bbox_of_atoms(visible_turfs)
	var/size_x = bbox[3] - bbox[1] + 1
	var/size_y = bbox[4] - bbox[2] + 1

	cam_screen.show_camera(visible_turfs, size_x, size_y)

/datum/action/item_action/camera_control/ui_close(mob/user)
	. = ..()
	var/user_ref = REF(user)
	var/is_living = isliving(user)
	// Living creature or not, we remove you anyway.
	concurrent_users -= user_ref
	// Unregister map objects
	cam_screen?.hide_from(user)
	// Turn off the console
	if(length(concurrent_users) == 0 && is_living)
		active_camera?.on_stop_watching(src)
		active_camera = null
		last_camera_turf = null
		playsound(src, 'sound/machines/terminal/terminal_off.ogg', 25, FALSE)

// /atom/movable/screen/map_view/camera
// 	/// All the plane masters that need to be applied.
// 	var/atom/movable/screen/background/cam_background

// /atom/movable/screen/map_view/camera/Destroy()
// 	QDEL_NULL(cam_background)
// 	return ..()

// /atom/movable/screen/map_view/camera/generate_view(map_key)
// 	. = ..()
// 	cam_background = new
// 	cam_background.del_on_map_removal = FALSE
// 	cam_background.assigned_map = assigned_map

// /atom/movable/screen/map_view/camera/display_to_client(client/show_to)
// 	show_to.register_map_obj(cam_background)
// 	. = ..()

// /atom/movable/screen/map_view/camera/proc/show_camera(list/visible_turfs, size_x, size_y)
// 	vis_contents = visible_turfs
// 	cam_background.icon_state = "clear"
// 	cam_background.fill_rect(1, 1, size_x, size_y)

// /atom/movable/screen/map_view/camera/proc/show_camera_static()
// 	vis_contents.Cut()
// 	cam_background.icon_state = "scanline2"
// 	cam_background.fill_rect(1, 1, DEFAULT_MAP_SIZE, DEFAULT_MAP_SIZE)
