# SPDX-FileCopyrightText: 2024 EasyApp contributors
# SPDX-License-Identifier: BSD-3-Clause
# © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

import time
from pathlib import Path
from PySide6.QtCore import QObject, Signal, Slot, Property

from EasyApp.Logic.Logging import console
from .logic.helpers import IO
from .logic.helpers import DottyDict
from .logic.project import Project as ProjectLogic
from .temp.project import Project as ProjectLib

_INFO = {
    'description': '',
    'location': str(Path.home()),
    'creationDate': ''
}

_EXAMPLES = [
    {
        'description': 'neutrons, powder, constant wavelength, HRPT@PSI',
        'name': 'La0.5Ba0.5CoO3 (HRPT)',
        'path': ':/Examples/La0.5Ba0.5CoO3_HRPT@PSI/project.cif'
    },
    {
        'description': 'neutrons, powder, constant wavelength, HRPT@PSI',
        'name': 'La0.5Ba0.5CoO3-Raw (HRPT)',
        'path': ':/Examples/La0.5Ba0.5CoO3-Raw_HRPT@PSI/project.cif'
    }
]


class Project(QObject):
    createdChanged = Signal()
    nameChanged = Signal()
    infoChanged = Signal()
    examplesChanged = Signal()

    def __init__(self, project_lib: ProjectLib):
        super().__init__()
        self._logic = ProjectLogic(project_lib)
        self._created = False
        self._name = ''
        self._info = _INFO
        self._examples = _EXAMPLES

    ##########################
    # GUI accessible variables
    ##########################

    # Properties

    @Property(bool, notify=createdChanged)
    def created(self):
        return self._created

    @created.setter
    def created(self, new_value):
        if self._created == new_value:
            return
        self._created = new_value
        self.createdChanged.emit()

    @Property(str, notify=nameChanged)
    def name(self):
        return self._name

    @name.setter
    def name(self, new_value):
        if self._name == new_value:
            return
        console.debug(IO.format_msg('main', f"Changing project name from '{self.name}' to '{new_value}'"))
        self._name = new_value
        self.nameChanged.emit()

    @Property('QVariant', notify=infoChanged)
    def info(self):
        return self._info

    @Property('QVariant', constant=True)
    def examples(self):
        return self._examples

    ##########################
    # GUI accessible functions
    ##########################

    @Slot()
    def create(self):
        console.debug(IO.format_msg('main', f"Creating project '{self.name}'"))
        self.info['creationDate'] = time.strftime("%d %b %Y %H:%M", time.localtime())
        self.infoChanged.emit()
        self.created = True

    @Slot()
    def save(self):
        console.debug(IO.format_msg('main', f"Saving project '{self.name}'"))

    @Slot(str, str)
    def editInfo(self, path, new_value):
        if DottyDict.get(self._info, path) == new_value:
            return
        console.debug(IO.format_msg('main', f"Changing project info.{path} from '{DottyDict.get(self._info, path)}' to '{new_value}'"))
        DottyDict.set(self._info, path, new_value)
        self.infoChanged.emit()
