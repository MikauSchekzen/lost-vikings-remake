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
