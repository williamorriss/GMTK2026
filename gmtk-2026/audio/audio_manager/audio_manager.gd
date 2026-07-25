extends Node2D

@export_group("References")
@export var sfx_player: AudioStreamPlayer
@export var music_player_a: AudioStreamPlayer
@export var music_player_b: AudioStreamPlayer

@export_group("Music")
@export var fade_time: float

signal finished_transition
var _is_fading: bool = false
var _using_a: float = true

func get_sfx_player() -> AudioStreamPlayer:
	return sfx_player

func play_sfx(audio: AudioStream, volume: float = 0.0, pitch: float = 1.0) -> void:
	sfx_player.volume_db = volume
	sfx_player.pitch_scale = pitch
	sfx_player.stream = audio
	sfx_player.play()

func get_is_fading() -> bool:
	return _is_fading

func queue_music(music_audio: AudioStream, volume: float = 0.0, pitch: float = 1.0) -> void:
	_is_fading = true
	
	var using_player: AudioStreamPlayer = music_player_a if _using_a else music_player_b
	var other_player: AudioStreamPlayer = music_player_a if not _using_a else music_player_b
	
	using_player.stream = music_audio
	using_player.volume_db = -40
	using_player.pitch_scale = pitch
	using_player.play()
	
	var tween: Tween = create_tween()
	var _x: PropertyTweener = tween.parallel().tween_property(using_player, "volume_db", volume, fade_time)
	var _y: PropertyTweener = tween.parallel().tween_property(other_player, "volume_db", -40, fade_time)
	await tween.finished
	
	other_player.stop()
	_using_a = not _using_a
	
	_is_fading = false
	finished_transition.emit()
