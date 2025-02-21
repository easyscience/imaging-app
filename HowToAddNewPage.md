Add new folder to Gui/Pages named after the page containing a Layout.qml file, a "MainArea" folder and a "Sidebar" folder
Add the new files to the .pyproject file
Add the page to the ApplicationWindow.qml file in the Gui folder
Add the page to the BackendWrapper.qml file in Gui/Globals
Add the page button to the References.qml in Gui/Globals
Add the page to the MockBackend.qml file in Backends
Add the mock logic for the page as a .qml file in Backends/MockQml
Add the new mock logic file to the qmldir in Backends/MockQml
Change the signal/slots of the previous/new page in layout.qml to ensure the new page can be navigated to.