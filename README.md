
<p align="center">
    <img src="assets/logo.png" style="width: 60%" />
    </br>
    </br>
    A cross-platform game engine for creating narrative and story focused games.
    </br>
    </br>
</p>

## About

Shraybn uses **Lua** for scripting game code, as well as **Shrift**, a custom scripting language for interactive dialogue.</br>
Targets OpenGL, Vulkan, and Metal.</br>

<picture>
    <source media="(prefers-color-scheme: dark)" srcset="/assets/brainmade/white-logo.svg">
    <source media="(prefers-color-scheme: light)" srcset="/assets/brainmade/black-logo.svg">
    <img alt="Humanmade mark." src="/assets/brainmade/black-logo.svg">
</picture></br>

[brainmade.org](https://brainmade.org/)

### Shrift

```
# Comment.
$is_tired false                 # Define a variable.

@ Start                         # Create a dialogue "location."

    # Dialogue.
    Charles: Hey there!
    Charles: What are you doing?

    # Choices.
    - Errands.

        I neede a few things.
        # Check if the variabls "is_tired" is true.
        = $is_tired true
            They get pretty exhausting!
        ;
        ~ Errands               # Jump to the "Errands" location.

    - Not much.

        I'm just taking a walk!
        ~ Not Much              # Jump tp the "Not Much" location.

@ Errands

    Charles: Oh, me too!
    Charles: I'm picking up some flowers for my mother.

@ Not Much

    Charles: Nice!
    Charles: Great weather for it.
```
