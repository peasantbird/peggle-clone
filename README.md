## Rules of the Game

### Firing the Cannon

**Aim**: Drag anywhere on the screen to aim the cannon in that direction.

**Fire**: Tap anywhere on the screen to fire the cannon!

### Win and Lose Conditions

You start with 10 balls. Every time you shoot a ball, the number of balls get subtracted.

To win, clear all orange pegs.

You lose if you run out of balls and there are still orange pegs remaining in the game.

## Dev Guide

This Peggle clone app has two main components: _Level Designer_ and _Game_. It follows
the **MVVM architecture** to structure these components.

## Level Designer

### Model

The model represents the domain logic of Peggle. It is comprised of peggle objects, as well as the board that contains these peggle objects.

**Peggle Objects**

The peggle objects include pegs and blocks. A `peg` has a `pegType` _(optional, compulsory, powerup, stubborn)_ and is circular, with a `radius` and a `center`.
A `block` is a rectangular-shaped object, having a `width`, `height` and a `center`.

**Board**

A board contains a set of pegs, a set of blocks, and has functions for adding, moving, deleting these game objects.
The board ensures that no two game objects overlap each other, and also ensures that all
game objects are fully on the board (no part of any object should be outside of the board),
enforcing these conditions when adding or moving a game object.

### View

**LevelDesignerView**

The `LevelDesignerView` is comprised of 3 constituent childviews, `LevelDesignerBoardView`
displaying the board in the level designer, `PaletteView` displaying the palette of game
objects to build the level, and `ActionButtonsView` displaying a panel of buttons for
loading, saving, resetting and starting the game.

### View Model

The `LevelDesignerViewModel` acts as the singular intermediary between the model and all
the views for the level designer. The view model implements properties and commands to
which the views can data bind to and invoke upon certain user actions. This allows for
a better separation of concerns - the view model defines the functionality to be offered
by the UI, and the views determine how that functionality is to be displayed. Moreover,
this allows for decoupling of the views and the model.

The view model relies heavily on the _Observer Pattern_ to ensure that changes are propagated
from the model to the views. This is further elaborated below:

**View-View Model interaction**

- The views own the view model, and update the view model directly through data binding or
  by calling the associated command in the view model based on a user action
- The view model is marked as an `Observable`. Changes in the view model will be notified
  to all the views observing the view model, and the views will refresh to reflect the changes
  in the view model

**Model-View Model interaction**

- The view model owns and updates the model directly by calling the methods in the model
- The model is marked as an `Observable`. Changes in the model will be notified to the view
  model, which will then get the associated changes.

The diagram below illustrates the above two interactions:

![Diagram explaining MVVM interaction](mvvm-pattern.png)
Reference: Stonis, Warren, Jain, & Pine. (2022, April 11). Model-View-ViewModel (MVVM).
Model-View-ViewModel (MVVM). https://learn.microsoft.com/en-us/dotnet/architecture/maui/mvvm

## Game

The game component for this Peggle clone has 4 main components:

- `PhysicsEngine`: Handles physics in a game-agnostic manner, including collision and gravity
- `GameEngine`: Handles game-specific logic and game objects
- `GameViewModel`: Acts as the intermediary between the view and the model (`GameEngine`
  & `PhysicsEngine`). The view model implements properties and commands to which the view
  can data bind to and invoke upon certain user actions. This allows for a better separation
  of concerns and decoupling - the view model defines the functionality to be offered by the
  UI, and the view determine how that functionality is to be displayed.
- `GameView`: Defines the UI of the game

### Model

### Physics Engine

The `PhysicsEngine` aims to be a game-agnostic framework for implementing physics in any game.
Its design is heavily inspired by the SpriteKit's `SKPhysicsWorld` and `SKPhysicsBody`. The
physics engine comprises of:

- `PhysicsBody`: A body that has physics behaviours, currently supporting collision and
  gravity as of this implementation
- `PhysicsEngine`: Applies gravity onto `PhysicsBodies`, detecting and resolving collisions,
  as well as updating positions, velocities and forces on `PhysicsBodies`
  - `CollisionDetector` handles detection of collisions between `PhysicsBodies` based on
    various shapes
  - `CollisionResolver` handles resolution of collisions by applying impulses on colliding bodies

**Game Objects and Physics Bodies**

Each relevant game object that needs physics, such as `pegs` and the `ball` in Peggle, contains
a reference to a `PhysicsBody` stored in `PhysicsEngine`. This association allows the game object to possess physical properties and
behaviors like velocity, mass, collision detection, and response to forces such as gravity.

### Game Engine

Every game object itself is stored in the `GameEngine`. The `GameEngine` handles updates for game objects as follows:

1. `GameEngine` contains the `PhysicsEngine`, and calls the `update(dt:)` function of `PhysicsEngine`
2. `PhysicsEngine` applies gravity, detects and resolves collisions, and updates the positions,
   velocities of `PhysicsBodies`
3. Because each game object contains a reference to its corresponding `PhysicsBody`, the game object
   knows about changes made by `PhysicsEngine`, and their computed properties change
4. `GameEngine` handles other game logic through methods invoked by `GameViewModel`, updating game
   objects themselves in various ways (for instance, marking pegs hit by the ball)

### Rendering the Game View

The `GameViewModel` owns the `GameEngine`, and gets all the changes to game objects from the model. It then relies
on the _Observer Pattern_ to ensure that changes are propagated from itself to the view. This
is further elaborated below:

**View-View Model interaction**

- The `GameView` owns the `GameViewModel`, and updates the view model directly through data binding or by
  calling the associated command in the view model based on a user action.
- The `GameViewModel` conforms to the `ObservableObject` protocol. Changes in the view model will be
  notified to the view observing the view model through `objectWillChange.send()` which repeats in the game loop, and the
  view will repeatedly refresh to reflect the changes in the view model.

## Tests

This section includes integration test plans for user testing.

### Integration tests

Menu

- The menu screen should show itself when the app is initialized
- Tapping on the 'Design a Level' button will lead to the level designer
- Tapping on the 'Play' button will lead to a level selection screen
- Tapping anywhere else on the screen will not do anything

Level Designer

- Test board
  - Peg on board
    - When tapped, if the delete action is selected, it should be deleted. Else, do nothing.
    - When long pressed, it should be deleted irregardless of selected action.
    - When dragged, it should follow the cursor and move to the next location if valid. Holding it
      while dragging for too long will not invoke the long press action.
- Test palette
  - Blue peg button
    - When tapped, the other buttons become more transparent while the button becomes opaque.
    - Tapping on the board should add a blue peg immediately at the selected location if the peg
      does not overlap other objects and is within the bounds of the board
  - Orange peg button
    - Similar to the behaviour of the blue peg button, except that an orange peg is added.
  - Green peg button
    - Similar to the behaviour of the blue peg button, except that a green peg is added.
  - Grey peg button
    - Similar to the behaviour of the blue peg button, except that a grey peg is added.
  - Block button
    - Similar to the behaviour of the blue peg button, except that a block is added.
  - Delete button
    - When tapped, the other buttons become more transparent while the button becomes opaque.
    - Tapping on empty sections of the board should not do anything.
    - Tapping on pegs on the board should delete them immediately.
- Test action buttons
  - Reset button
    - Tapping on the reset button should immediately clear out the board. The board will display
      no game objects.
  - Save button
    - Tapping on the save button with a new `Level Name` inputed in the textfield will create
      a json file with that name and save the current state of the board into that file.
    - Tapping on the save button with an existing `Level Name` inputed in the textfield will
      overwrite the json file with that name with the current state of the board without warning.
  - Load button
    - Tapping on the load button will immediately load the json file with the name specified in
      the textfield. The level designer will show the board with the game objects saved in the file.
    - Tapping on the load button with a `Level Name` that does not exist will show an error on the
      screen.
  - Start button
    - Tapping on the start button will immediately navigate to the game view, using the current board
      designed in the level designer. The game will start (use test cases in **Game** to test this).
      Tapping on the back button will retain the progress of this game view.
      - Clicking start again without changing the board will go back to this game view with the same state.
      - Clicking start again after adding or removing an object on the board will restart the game view.

Level Selection

- Tapping 'Back' will lead to the menu screen
- Tapping on a certain 'LevelName' item in the list will load the game, using the board saved in the json file
  of that 'LevelName'
- Tapping anywhere else on the screen (not on the list or `Back` button) will not do anything

Game

- Test initialization
  - The ball count on the top left of the screen should be 10.
  - The cannon should face vertically downwards initially.
  - All pegs should not be lit up.
  - There should be no ball launched.
- Test powerup pop-up
  - Upon starting the game, a popup should appear in the center of the screen, with two buttons,
    one for explosion and one for spooky ball. The game should still run while showing the popup.
  - Tapping on any one of the two buttons will dismiss the pop-up immediately, and allow tapping
    to launch a ball.
  - Tapping anywhere on the screen will not do anything, and a ball cannot be launched while the
    popup is active.
  - The powerup chosen in the popup will change all green pegs to use that powerup, until the game ends.
- Test cannon
  - When dragging to a point vertically higher than the middle of the cannon, the cannon will
    at most turn 90 degrees to the right/left, whichever is closer to the drag gesture.
  - When dragging to any other point vertically lower than the middle of the cannon, the cannon
    will rotate towards the drag gesture.
  - Other gestures do not affect the rotation of the cannon.
- Test ball launch
  - When the screen is tapped, a ball should be shot from the cannon, in the direction that the
    cannon is facing. The ball count on the top left of the screen should reduce by 1.
  - Since the cannon cannot rotate above 90 degress to the right/left, the ball should never be
    launched to a position higher than the center of the cannon.
  - Other gestures should not cause the ball to launch.
  - After launching the ball, you cannot launch until the ball exits the screen.
- Test ball movement
  - The position of the ball should be refreshed as it moves after being launched.
  - Gravity
    - The ball should accelerate downwards at all points in time, unless it collided with an
      object below it.
  - Collision
    - Upon collision with a peg/block, the ball should bounce away from the peg/block.
    - Upon collision with the top, left and right boundaries of the screen, the ball should
      bounce away from the boundary.
    - The ball should not collide with the bottom boundary of the screen, and fall through it.
    - Upon collision with a few objects, the ball should slow down as some of its momentum
      should be lost to the collisions.
- Test pegs
  - Blue & orange pegs
    - Pegs should not move upon being hit by the ball.
    - Pegs should light up after being hit by the ball, and stay lit up while the ball is still
      on the screen.
    - Lit pegs should be removed after the ball exits the screen, with a fade-out animation.
  - Green pegs
    - If explosion was chosen earlier, when the green peg is hit by the ball, it should remove
      itself and nearby game objects. If a surrounding green peg is removed by this green peg, that
      green peg's surrounding game objects are also removed, and so on.
    - If spooky ball was chosen earlier:
      - Green peg should not move upon being hit by the ball.
      - Green peg should light up after being hit by the ball, and stay lit up while the ball is still
        on the screen.
      - Lit green peg should be removed after the ball exits the screen, with a fade-out animation.
  - Grey pegs
    - Grey peg should move upon being hit by the ball.
    - Grey peg should not light up after being hit by the ball.
    - Grey peg should not be removed after the ball exits the screen.
- Test spooky ball
  - After choosing a spooky ball powerup and then hitting a green peg, when the ball falls through the screen,
    instead of being reset, it will teleport to the top of the screen at the same x coordinate and
    fall through the screen again.
- Test walls
  - The top, left and right boundaries should not move upon being hit by the ball, i.e. if the
    ball hits them again, the ball should be reflected at the same x or y position.
- Test bucket
  - The bucket be initialized at the bottom left of the screen, moving to the right with a constant velocity.
  - When the bucket hits the left or right boundary of the screen, it should change direction of its
    movement but maintain the same speed.
  - When the ball falls into the bucket and spooky ball is not active, the ball count should increase by 1
    upon the ball being reset.
- Test 'Back' button
  - Tapping on the 'Back' button will lead to the previous screen, be it level designer or level selection screen.
- Test ball is stuck
  - When the ball is stuck with pegs/blocks under it preventing it from moving downwards, after some time, the
    peg/block that is stuck on top of should be removed.
- Test game is won
  - When there are no orange pegs on the screen left, an alert should appear showing that the game is won.
  - In any other case, the game is won alert should not be shown.
  - When the alert is dismissed, it should lead back to the level selection/level designer screen, depending on
    where the user came from.
- Test game is lost
  - When the ball count reaches zero and there are still orange pegs, an alert should appear showing that the game is lost.
  - In any other case, the game is lost alert should not be shown.
  - When the alert is dismissed, it should lead back to the level selection/level designer screen, depending on
    where the user came from.

## Written Answers

### Reflecting on your Design

> Now that you have integrated the previous parts, comment on your architecture
> in problem sets 2 and 3. Here are some guiding questions:
>
> - do you think you have designed your code in the previous problem sets well
>   enough?
> - is there any technical debt that you need to clean in this problem set?
> - if you were to redo the entire application, is there anything you would
>   have done differently?

I do not think I designed my code in the previous problem sets well enough.
There was a lot of technical debt left that I had to clean in this problem set.

For instance, the way my `board` checked for overlaps in the board objects
was through invoking `overlaps(with:)` of `peg`, which was immediately not
extensible when I had to support a new board object `block` in my `board`.
This meant that I had to create a protocol `PeggleObject` that all board
objects conformed to, and also implement a visitor pattern for the
`PeggleObject` protocol so that `peg`s and `block`s can check for overlaps
between each other.

In addition, I placed quite a bit of the logic that was supposed to be in
the `GameEngine` into the `GameViewModel`, and as I had to add new features
in this problem set, there was quite a bit of technical debt to put the logic
back into the `GameEngine`, some of which were needed to support the new
features being added.

There were also a lot of switch-cases, which as many new features were being
implemented in this problem set, meant that the codebase was getting a bit
hard to track. I tried my best to refactor switch-cases into dictionaries or
shared factory methods in Utils. For instance, `PegView` and `renderPegView`
of `GameView` both use the `pegToImageName` method to determine the image
name based on the type of peg and whether the peg is hit.

There were also a fair bit of technical debt that I did not manage to solve
with the limited time I had, which includes how game objects contain a
`PhysicsBody` in order to work with physics. Because of this, I had to
continue working with whatever implementation I had come with, which I
realise is quite a problem. Imagine if I create a codebase in the future that
is already structured in a certain problematic way, that would mean that
other people working on the same codebase would have to spend a lot of time
to either refactor issues or continue adding onto the problem as more features
continue to be added.

If I were to redo the entire application, I would tell myself not to take
shortcuts to certain functionalities. The very first problem I faced of
`board` being coupled with `peg`, as well as other issues I faced such as
pegs reacting to all collisions including `stubborn peg`s instead of only
reacting to collisions with the ball, would not have been there if I made
sure to think about extensibility and stick to feature requirements. In
addition, if I were to redo the application, I would have definitely
thought through certain design decisions more, such as my implementation
of physics for game objects, thinking more about extensibility. I think
problem set 4 was a good problem set as we had to implement many features,
and it highlighted to me a lot of the technical debt that could arise with
poor design choices.
