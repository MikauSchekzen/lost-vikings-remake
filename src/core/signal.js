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
