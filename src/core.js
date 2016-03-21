function Core() {
  console.log("This is a static class.");
};
window.onload = function() { Core.init(); };

/**
 * Initializes the game.
 */
Core.init = function() {
  this.initMembers();
  this.initPixi();
  DataManager.onDatabaseLoaded.addOnce(function() {
    this.startGame();
  }, this);
  DataManager.loadDatabase();
};

/**
 * Initializes this object's member variables.
 */
Core.initMembers = function() {
  this.renderer = null;
  this.width = 800;
  this.height = 450;
  this.window = null;
  if(this.isNW()) this.window = require("nw.gui").Window.get();
};

/**
 * Initializes PixiJS.
 */
Core.initPixi = function() {
  this.renderer = PIXI.autoDetectRenderer(800, 450);
  document.body.appendChild(this.renderer.view);
  if(this.isNW()) this.resizeWindow();
};

/**
 * Resizes the Node Webkit window.
 */
Core.resizeWindow = function() {
  var widthDiff = (this.window.width - this.window.window.innerWidth);
  var heightDiff = (this.window.height - this.window.window.innerHeight);
  this.window.resizeTo(
    this.width + widthDiff,
    this.height + heightDiff
  );
  this.window.setPosition("center");
};

/**
 * Checks whether running Node Webkit.
 * @return {Boolean} Whether running Node Webkit.
 */
Core.isNW = function() {
  try {
    return (typeof require("nw.gui") !== "undefined");
  }
  catch(e) {
    return false;
  }
};

/**
 * Renders the game.
 */
Core.animate = function() {
  requestAnimationFrame(Core.animate);

  Core.update();
  SceneManager.scene().update();

  Core.renderer.render(SceneManager.scene().stage());
};

/**
 * Updates the core every frame.
 */
Core.update = function() {
};

/**
 * Starts the game, launching its first scene.
 */
Core.startGame = function() {
  SceneManager.push(Scene_Game);
  Core.animate();
};
