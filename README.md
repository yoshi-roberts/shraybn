
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
$is_set = false

[Start]

Character: This is some dialogue.    
Character: It is time to make a choice.

* First choice [First Choice]
* Second choice [Second Choice]

[First Choice]

Character: You chose the first option.
$is_set = true
@goto End

[Second Choice]

Character: You chose the second option.
@goto End

[End]

{$is_set == true} Character: This dialogue only appears if a condition is met.
Character: You have reached the end.
```

## Libs
