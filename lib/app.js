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
  if(this.isNW()) {
    this.window.on("resize", function(w, h) {
      Core.window.setPosition("center");
    });
    this.resetWindowSize();
  }
};

/**
 * Resizes the Node Webkit window.
 */
Core.resetWindowSize = function() {
  var widthDiff = (this.window.window.outerWidth - this.window.window.innerWidth);
  var heightDiff = (this.window.window.outerHeight - this.window.window.innerHeight);
  this.window.resizeTo(
    this.width + widthDiff,
    this.height + heightDiff
  );
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
function Signal() {
  this.initialize.apply(this, arguments);
};

/**
 * Initializes the Signal.
 */
Signal.prototype.initialize = function() {
  this.initMembers();
};

/**
 * Initializes the Signal's member variables.
 */
Signal.prototype.initMembers = function() {
  this.listeners = [];
};

/**
 * Adds a listener to this Signal.
 * @param  {Function} callback        The callback function to be dispatched.
 * @param  {Object}   callbackContext The context to call this from.
 * @param  {...}      [params]        Extra parameters for the callback to call.
 */
Signal.prototype.add = function(callback, callbackContext) {
  var args = [];
  for(var a = 2;a < arguments.length;a++) args.push(arguments[a]);
  var listener = {
    callback: callback,
    callbackContext: callbackContext,
    args: args,
    once: false
  };
  this.listeners.push(listener);
};

/**
 * Adds a listener to this Signal, but only for one event.
 * @param  {Function} callback        The callback function to be dispatched.
 * @param  {Object}   callbackContext The context to call this from.
 * @param  {...}      [params]        Extra parameters for the callback to call.
 */
Signal.prototype.addOnce = function(callback, callbackContext) {
  var args = [];
  for(var a = 2;a < arguments.length;a++) args.push(arguments[a]);
  var listener = {
    callback: callback,
    callbackContext: callbackContext,
    args: args,
    once: true
  };
  this.listeners.push(listener);
};

/**
 * Dispatches the event to all listeners.
 */
Signal.prototype.dispatch = function() {
  for(var a = 0;a < this.listeners.length;a++) {
    var listener = this.listeners[a];
    listener.callback.apply(listener.callbackContext, listener.args);
    if(listener.once) {
      this.listeners.splice(a, 1);
      a--;
    }
  }
};

/**
 * Removes a listener from this Singal.
 * @param  {Function} callback        The assigned callback to check for.
 * @param  {Object}   callbackContext The assigned listener context to check for.
 */
Signal.prototype.remove = function(callback, callbackContext) {
  for(var a = 0;a < this.listeners.length;a++) {
    var listener = this.listeners[a];
    if(listener.callback === callback && listener.callbackContext === callbackContext) {
      this.listeners.splice(a, 1);
      a--;
    }
  }
};
function Bitmap() {
  this.initialize.apply(this, arguments);
};

/**
 * Initializes the Bitmap
 * @param {String} url - The URL to load the image from.
 */
Bitmap.prototype.initialize = function(url) {
};
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
function Prefab() {
  this.initialize.apply(this, arguments);
};

/**
 * Initializes the Prefab.
 */
Prefab.prototype.initialize = function() {
  this.initMembers();
};

/**
 * Initializes the Prefab's members.
 */
Prefab.prototype.initMembers = function() {
  this.exists = false;
};
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
function DataManager() {
  console.log("This is a static class.");
};

/**
 * The database objects to load at start.
 * @type {Array}
 */
DataManager.dbObjects = [
  { url: "assets/data/actors.js", name: "$dataActors" }
];

/**
 * The size of the remaining queue.
 * @type {Number}
 */
DataManager.queueSize = 0;

/**
 * Event that dispatches when the whole (base) database has been loaded.
 * @type {Signal}
 */
DataManager.onDatabaseLoaded = new Signal();

/**
 * Starts loading the database.
 */
DataManager.loadDatabase = function() {
  for(var a = 0;a < this.dbObjects.length;a++) {
    var dbObj = this.dbObjects[a];
    this.loadData(dbObj);
    this.queueSize++;
  }
};

/**
 * Loads a database object.
 * @param  {Object} dbObj The Object as defined in DataManager.dbObjects.
 */
DataManager.loadData = function(dbObj) {
  var xhr = new XMLHttpRequest();
  // xhr.overrideMimeType("application/json");
  xhr.open("GET", dbObj.url, true);
  xhr.onreadystatechange = function() {
    if(this.readyState === 4) {
      DataManager.queueSize--;
      if(DataManager.queueSize === 0) DataManager.onDatabaseLoaded.dispatch();
      window[dbObj.name] = JSON.parse(this.responseText);
    }
  };
  xhr.send(null);
};
function ImageManager() {
  console.log("This is a static class.");
};

ImageManager.loadBitmap = function(url) {
};
function SceneManager() {
  console.log("This is a static class.");
};

SceneManager.scenes = [];

/**
 * Returns the current scene.
 * @return {Scene} Current scene.
 */
SceneManager.scene = function() {
  return this.scenes[this.scenes.length-1];
};

/**
 * Adds a scene to the stack.
 * @param  {Scene} scene The scene class to add.
 */
SceneManager.push = function(scene) {
  this.scenes.push(new scene());
};
var mainWindow = require("nw.gui").Window.get();
var debugWindow = null;
// mainWindow.showDevTools(null, function() {
//   // debugWindow.moveTo(0, 0);
//   // mainWindow.focus();
// });
