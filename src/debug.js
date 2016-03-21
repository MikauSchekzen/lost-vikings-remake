var mainWindow = require("nw.gui").Window.get();
var debugWindow = mainWindow.showDevTools();
debugWindow.moveTo(0, 0);
mainWindow.focus();
