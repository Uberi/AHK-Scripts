Built-in Entities
=================
ProgressEngine includes several basic entities by default. Extending and customizing these entities allows for a wide variety of behaviors and properties.

Entity Basis
------------

All entities possess certain properties by default:

| Property    | Purpose                                | Modifiable |
|:------------|:---------------------------------------|:-----------|
| X           | Position along X-axis (units)          | Yes        |
| Y           | Position along Y-axis (units)          | Yes        |
| W           | Width (units)                          | Yes        |
| H           | Height (units)                         | Yes        |
| ScreenX     | Position along X-axis (pixels)         | No         |
| ScreenY     | Position along Y-axis (pixels)         | No         |
| ScreenW     | Width (pixels)                         | No         |
| ScreenH     | Height (pixels)                        | No         |
| Visible     | Entity visibility (True or False)      | Yes        |

There are also a number of functions available to each entity. These functions are implemented in the ProgressEntities.Basis class, from which all entities should inherit. All entity functions are overridable.

### ProgressEntities.Basis.Start(Delta,Layer,Viewport)

Defines entity frame start logic, such as setup or initialization.

| Parameter | Purpose                                          |
|:----------|:-------------------------------------------------|
| Delta     | Time since last invocation of callback (seconds) |
| Layer     | Layer the entity resides in (layer object)       |
| Viewport  | Current viewport (viewport object)               |

Returns a truthy value to stop the game engine, otherwise a falsy value.

### ProgressEntities.Basis.Step(Delta,Layer,Viewport)

Defines entity behavior, such as movement or game logic.

| Parameter | Purpose                                          |
|:----------|:-------------------------------------------------|
| Delta     | Time since last invocation of callback (seconds) |
| Layer     | Layer the entity resides in (layer object)       |
| Viewport  | Current viewport (viewport object)               |

Returns a truthy value to stop the game engine, otherwise a falsy value.

### ProgressEntities.Basis.End(Delta,Layer,Viewport)

Defines entity frame end logic, such as cleanup or uninitialization.

| Parameter | Purpose                                          |
|:----------|:-------------------------------------------------|
| Delta     | Time since last invocation of callback (seconds) |
| Layer     | Layer the entity resides in (layer object)       |
| Viewport  | Current viewport (viewport object)               |

Returns a truthy value to stop the game engine, otherwise a falsy value.

### ProgressEntities.Basis.Draw(Delta,Layer,Viewport)

Defines entity appearance, such as drawing or animation.

| Parameter | Purpose                                          |
|:----------|:-------------------------------------------------|
| Delta     | Time since last invocation of callback (seconds) |
| Layer     | Layer the entity resides in (layer object)       |
| Viewport  | Current viewport (viewport object)               |

Return value is ignored.

### ProgressEntities.Basis.Intersect(Rectangle,ByRef IntersectX = "",ByRef IntersectY = "")

Used to determine whether the entity intersects a given rectangle object.

| Parameter  | Purpose                                      |
|:-----------|:---------------------------------------------|
| Rectangle  | Rectangle to test against (rectangle object) |
| IntersectX | Output intersection along X-axis (units)     |
| IntersectY | Output intersection along Y-axis (units)     |

Returns True to indicate intersection, False otherwise.

### ProgressEntities.Basis.Inside(Rectangle)

Used to determine whether the entity is completely inside a given rectangle object.

| Parameter  | Purpose                                      |
|:-----------|:---------------------------------------------|
| Rectangle  | Rectangle to test against (rectangle object) |

Returns True to indicate that the entity is completely inside the rectangle, False otherwise.

Built-in Entities
-----------------

### ProgressEntities.Rectangle

A drawtype that appears as a filled, borderless rectangle.

| Property    | Purpose                                | Modifiable |
|:------------|:---------------------------------------|:-----------|
| Color       | Fill color (RGB hex)                   | Yes        |

### ProgressEntities.Static
A drawtype that appears as a filled, borderless rectangle and is considered in physics simulations; entities that are dynamic are able to collide with it.

| Property    | Purpose                                                  | Modifiable |
|:------------|:---------------------------------------------------------|:-----------|
| Color       | Fill color (RGB hex)                                     | Yes        |
| Density     | Material density (mass/volume)                           | Yes        |
| Restitution | Material bounciness (rebound speed/incoming speed        | Yes        |
| Friction    | Material coefficient of friction (friction/normal force) | Yes        |

### ProgressEntities.Dynamic

A drawtype that appears as a filled, borderless rectangle and is active in physics simulations; it moves and collides according to forces acting upon it.
Similar to ProgressEntities.Dynamic, this entity type is still a rectangle and is still affected by physics, except that it can move, collide, and be affected by forces. In addition to all the usable properties of ProgressEntities.Static, two other properties are available: SpeedX and SpeedY, which affect the entity's speed along the X axis and speed along the Y axis, respectively.

| Property    | Purpose                                | Modifiable |
|:------------|:---------------------------------------|:-----------|
| Color       | Fill color (RGB hex)                   | Yes        |
| Density     | Material density (mass/volume)         | Yes        |
| Restitution | Material bounciness (rebound/incoming) | Yes        |
| SpeedX      | Speed along X-axis (units/second)      | Yes        |
| SpeedY      | Speed along Y-axis (units/second)      | Yes        |

### ProgressEntities.Text

A drawtype that appears as text with a transparent background.

| Property  | Purpose                                       | Modifiable |
|:----------|:----------------------------------------------|:-----------|
| W         | Width (units)                                 | No         |
| H         | Height (units)                                | Yes        |
| Align     | Text alignment ("Left", "Center", or "Right") | Yes        |
| Weight    | Font weight (0 to 1000)                       | Yes        |
| Italic    | Font italic flag (True or False)              | Yes        |
| Underline | Font underline flag (True or False)           | Yes        |
| Strikeout | Font strikeout flag (True or False)           | Yes        |
| Typeface  | Text typeface (typeface name)                 | Yes        |
| Text      | Text to display (string)                      | Yes        |