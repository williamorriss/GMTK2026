extends Node2D

@export var sfx_player: AudioStreamPlayer2D
@export var music_player: AudioStreamPlayer2D

func get_sfx_player() -> AudioStreamPlayer2D:
	return sfx_player
func get_music_player() -> AudioStreamPlayer2D:
	return music_player

func play_sfx(audio: AudioStream, volume: float = 0.0, pitch: float = 1.0) -> void:
	sfx_player.volume_db = volume
	sfx_player.pitch_scale = pitch
	sfx_player.stream = audio
	sfx_player.play()
