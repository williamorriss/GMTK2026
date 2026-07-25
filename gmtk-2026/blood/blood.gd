extends Node2D

@export var droplet_particles: CPUParticles2D
@export var splatter_scene: PackedScene
@export var ray_count := 8
@export var max_distance := 120.0
@export var collision_mask := 1

func burst(direction: Vector2, origin: Vector2):
	global_position = origin
	droplet_particles.direction = direction
	droplet_particles.restart()
	droplet_particles.emitting = true

	var space_state = get_world_2d().direct_space_state
	for i in ray_count:
		var spread_angle = direction.angle() + randf_range(-0.5, 0.5)
		var ray_dir = Vector2.RIGHT.rotated(spread_angle)
		var query = PhysicsRayQueryParameters2D.create(
			origin,
			origin + ray_dir * randf_range(max_distance * 0.4, max_distance),
			collision_mask
		)
		var result = space_state.intersect_ray(query)
		if result:
			BloodFX.spawn_splatter(result.position, result.normal)

	# let particles finish, then clean up the burst node itself (decals persist separately)
	await get_tree().create_timer(droplet_particles.lifetime + 0.2).timeout
	queue_free()
