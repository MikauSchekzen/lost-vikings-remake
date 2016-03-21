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
