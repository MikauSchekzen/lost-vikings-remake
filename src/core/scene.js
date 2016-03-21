function Scene() {
  this.initialize.apply(this, arguments);
};

/**
 * Initializes the object.
 */
Scene.prototype.initialize = function() {
  this.initMembers();
};

/**
 * Initializes the Scene's member variables.
 */
Scene.prototype.initMembers = function() {
  this._stage = new PIXI.Container();
};

/**
 * Returns the Scene's stage object.
 * @return {PIXI.Container} The Scene's stage object.
 */
Scene.prototype.stage = function() {
  return this._stage;
};

/**
 * Updates the scene and renders it.
 */
Scene.prototype.update = function() {
};
