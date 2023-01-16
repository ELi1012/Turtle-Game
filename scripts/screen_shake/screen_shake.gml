/// @desc screen_shake(magnitude, frames)
/// @arg magnitude sets strength of shake (radius)
/// @arg frames set length of shake in frames
function screen_shake(magnitude, frames) {
	with (camera) {
		if (magnitude > shake_remain) {
			shake_magnitude = magnitude;
			shake_remain = magnitude;
			shake_length = frames;
		}
	}
}
