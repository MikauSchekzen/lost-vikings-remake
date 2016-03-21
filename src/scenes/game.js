function Scene_Game() {
  this.initialize.apply(this, arguments);
};
Scene_Game.prototype = Object.create(Scene.prototype);
Scene_Game.prototype.constructor = Scene_Game;

/**
 * Initializes the scene.
 */
Scene_Game.prototype.initialize = function() {
  Scene.prototype.initialize.call(this);
};

/**
 * Renders the Game Scene.
 */
Scene_Game.prototype.update = function() {
  Scene.prototype.initialize.call(this);
};
