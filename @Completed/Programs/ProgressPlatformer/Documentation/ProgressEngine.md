ProgressEngine
==============
Behind the jumping, scrolling, dynamic world of [Achromatic/ProgressPlatformer](http://www.autohotkey.com/forum/topic69424.html) lies ProgressEngine, a simple and elegant game engine. Designed for ease of use, this extensible library takes care of the boilerplate and the low-level stuff so you don't have to.

Features
--------
* Basic physics engine built in.
* Unlimited, movable, scalable layers.
* Consistent coordinate system - viewports can be freely resized.
* MIDI music support with an asynchronous API and conversion tools.
* Brushes, contexts, bitmaps, and other resources are managed automatically.
* Easy customisation of existing drawtypes and the ability to create your own drawtypes.
* Container entities for grouping multiple entities together.

Tutorial
--------
See the [ProgressEngine tutorial](Tutorial.md) for a step-by-step tutorial for building a game with ProgressEngine.

Coordinates
-----------
The ProgressEngine coordinate system is Cartesian, with the origin at the top left corner of the viewport and (10, 10) at the bottom right. X and Y axis values between 0 and 10 will appear inside the viewport; values not in this range will be outside of the viewport. This coordinate system is independent of the window scaling and does not correspond to any physical units.

Reference
---------

### ProgressEngine.FrameRate

The target framerate to run the engine at, when started using ProgressEngine.Start. Set this value to 0 to avoid framerate limiting altogether.

### ProgressEngine.Layers

Array of ProgressEngine.Layer instances, initially empty. Only layers placed within this array are considered by ProgressEngine; removing a layer from this array effectively deletes it unless stored elsewhere.

### ProgressEngine.Layer

Contains entities and various properties affecting them. Usage requires instaniation and insertion into ProgressEngine.Layers.

| Property    | Purpose                          | Modifiable |
|:------------|:---------------------------------|:-----------|
| X           | Position along X-axis (units)    | Yes        |
| Y           | Position along Y-axis (units)    | Yes        |
| W           | Width (units)                    | Yes        |
| H           | Height (units)                   | Yes        |
| Visible     | Layer visibility (True or False) | Yes        |
| Entities    | Array of entities (array)        | Yes        |

### ProgressEngine.Start(DeltaLimit = 0.05)

Starts the game engine, properly handling timing and framerate management. Returns when a truthy value is returned from ProgressEngine.Update.

The upper limit on the time delta in seconds is specified by _DeltaLimit_ (positive integer or decimal), and if the time delta exceeds this value for whatever reason, it will be reduced to this value.

### ProgressEngine.Update(Delta)

Steps and draws entities in every layer, handling entity callbacks and drawing management.

The time delta since the last invocation of this function in seconds is specified by _Delta_ (positive integer or decimal).

Objects
-------
Various objects are used by ProgressEngine to represent different values. Here are their properties:

### Rectangle

An object designed to describe a rectangular area.

| Property    | Purpose                          | Modifiable |
|:------------|:---------------------------------|:-----------|
| X           | Position along X-axis (units)    | Yes        |
| Y           | Position along Y-axis (units)    | Yes        |
| W           | Width (units)                    | Yes        |
| H           | Height (units)                   | Yes        |

### Viewport

An object designed to describe a viewport, which is the rectangle in which an entity resides.

| Property    | Purpose                                | Modifiable |
|:------------|:---------------------------------------|:-----------|
| X           | Position along X-axis (units)          | No         |
| Y           | Position along Y-axis (units)          | No         |
| W           | Width (units)                          | No         |
| H           | Height (units)                         | No         |
| ScreenX     | Position along X-axis (pixels)         | No         |
| ScreenY     | Position along Y-axis (pixels)         | No         |
| ScreenW     | Width (pixels)                         | No         |
| ScreenH     | Height (pixels)                        | No         |

Entities
--------
See the [built-in entities documentation](Built-in Entities.md) for a description of each built-in entity, as well as how to customize and extend them.