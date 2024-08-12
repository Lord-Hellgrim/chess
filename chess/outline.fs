#version 330

in vec2 fragTexCoord;

out vec4 fragColor;

uniform sampler2D texture0;
uniform vec2 resolution;

void main()
{
    vec2 texelSize = 1.0 / resolution;
    vec4 color = texture(texture0, fragTexCoord);

    if (color.rgb == vec3(1.0)) // Check if the pixel is white
    {
        bool outline = false;

        // Check surrounding pixels
        vec4 north = texture(texture0, fragTexCoord + vec2(0.0, texelSize.y));
        vec4 south = texture(texture0, fragTexCoord - vec2(0.0, texelSize.y));
        vec4 east = texture(texture0, fragTexCoord + vec2(texelSize.x, 0.0));
        vec4 west = texture(texture0, fragTexCoord - vec2(texelSize.x, 0.0));

        if (north.rgb != vec3(1.0) || south.rgb != vec3(1.0) ||
            east.rgb != vec3(1.0) || west.rgb != vec3(1.0))
        {
            outline = true;
        }

        if (outline)
        {
            fragColor = vec4(0.0, 0.0, 0.0, 1.0); // Draw black outline
        }
        else
        {
            fragColor = vec4(1.0, 1.0, 1.0, 1.0); // Keep white color
        }
    }
    else
    {
        fragColor = color; // Keep original color
    }
}
