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
