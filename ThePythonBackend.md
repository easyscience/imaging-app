In main.py the backend gets instantiated at `qmlRegisterSingletonType(Backend, 'Backends', 1, 0, 'PyBackend')` which registers the backend as a QML module, the first argument is the actual backend class imported from `Backends.real_backend`, the second argument is the location the class is to be imported from: "Backends", the third and fourth argument are Major and Minor versions of the module, and the last argument is the QML name of the instantiated module. I.e. this creates a QML "module" from the imported and instantiated python class which can get imported in QML via `import Backends.PyBackend as Backend`

In "BackendWrapper.qml" this QML module is imported: `import Backends as Backends`, and it is checked if the "PyBackend" submodule exists, i.e. if it has been registered. If it hasn't, the GUI defaults to the QML MockBackend. In either case the backend is made available to QML as the property "activeBackend":
```c++
readonly property var activeBackend: {
    if (typeof Backends.PyBackend !== 'undefined') {
        console.debug('REAL python backend is in use')
        return Backends.PyBackend
    } else {
        console.debug('MOCK QML backend is in use')
        return Backends.MockBackend
    }
}
```
For each QT property in the backend, a corresponding property in the QML BackendWrapper is created and linked to the property in the backend. This ensures that when the backend property is updated, the update is propagated to QML.
```c++
property bool projectCreated: activeBackend.project.created
onProjectCreatedChanged: activeBackend.project.created = projectCreated
```
where `onProjectCreatedChanged` is a signal emitted from within the backend.

In "real_backend.py" is the actual `Backend` class. This class is a slim class which is mostly responsible for holding other GUI classes and connecting signals between those classes. 
The `Project` class of the easyscience library gets imported here as `ProjectLib`, gets instantiated in the `__init__` method and gets passed on to the other GUI classes: 
```python
from easyimaging import Project as ProjectLib
from .sample_model import SampleModel

class PyBackend(QObject):
    def __init__(self):
        super().__init__()

        self._project_lib = ProjectLib()

        # Page and Status bar backend parts
        self._home = Home()
        self._project = Project(self._project_lib)
        self._sample_model = SampleModel(self._project_lib)
        self._measurements = Measurements(self._project_lib)
        self._analysis = Analysis(self._project_lib)
        self._summary = Summary(self._project_lib)
        self._status = Status(self._project_lib)
```
this ensures that the project is shared among all pages in the GUI.

For each page in the GUI (and more), there is a corresponding GUI class at the top-level of the python backend. These classes are purely GUI functionality, with Signals and Slots for different properties and functions. Actual functionality is handled by the logic classes in the `logic` sub-module which are attached to these GUI classes and also gets the instantiated easyscience project as an argument:
```python
from .logic.project import Project as ProjectLogic

class Project(QObject):
    createdChanged = Signal()
    nameChanged = Signal()

    def __init__(self, project_lib: ProjectLib):
        super().__init__()
        self._logic = ProjectLogic(project_lib)
```
Each property or function in the GUI classes calls functionality from the attached logic classes:
```python
@Property(bool, notify=createdChanged)
def created(self) -> bool:
    return self._logic.created


@Slot()
def create(self) -> None:
    self._logic.create()
    self.createdChanged.emit()
```

The logic classes handles the easyscience functionality.