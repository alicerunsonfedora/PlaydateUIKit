# ``PlaydateUIKit/UIWheelKeyboard``

## Overview

The keyboard typically appears on the right-hand side of the screen and
scrolls up and down with either the crank or the up and down buttons on
the directional pad.

### Keyboard key sets

The keyboard supports a variety of key sets used for different input
mechanisms. By default, the
``KeySet-swift.enum/alphanumeric(includeCapitalization:)`` key set is used
for inputs that use the standard Latin alphabet. However, a custom key set
can be defined as well with ``KeySet-swift.enum/custom(keys:font:)``,
providing the corresponding keys and font.


## Topics

### Handling delegate events

- ``delegate``
- ``UIWheelKeyboardDelegate``

### Keyboard information

- ``KeySet-swift.enum``
- ``UIWheelKeyboardCode``
