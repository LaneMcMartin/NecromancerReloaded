shader_type canvas_item;

void fragment() {
	COLOR = texture(TEXTURE, UV); //read from texture
  	COLOR.b = 1.0; //set blue channel to 1.0
}
