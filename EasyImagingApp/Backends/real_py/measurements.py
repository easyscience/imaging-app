# SPDX-FileCopyrightText: 2024 EasyApp contributors
# SPDX-License-Identifier: BSD-3-Clause
# © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

from pathlib import Path
from PySide6.QtCore import QObject, Signal, Slot, Property

from EasyApp.Logic.Logging import console
from .logic.helpers import IO
from .logic.helpers import DottyDict
from .logic.project import Project as ProjectLogic
from .temp.project import Project as ProjectLib

class Measurements(QObject):
    activeMeasurementChanged = Signal()

    def __init__(self, project_lib: ProjectLib):
        super().__init__()
        self._project_logic = ProjectLogic(project_lib)

    ##########################
    # GUI accessible variables
    ##########################

    # Properties

    @Property(str, notify=activeMeasurementChanged)
    def activeMeasurement(self):
        """
        Returns the name of the active measurement in the image provider.
        This is used in the QML code to display the image.
        """
        return 'image://easyimage/' + self._project_logic.active_measurement
    
    @activeMeasurement.setter
    def activeMeasurement(self, new_value):
        """
        Sets the name of the active measurement in the image provider.
        This is used in the QML code to display the image.
        """
        if self._project_logic.active_measurement == new_value:
            return
        console.debug(IO.format_msg('main', f"Changing active measurement from '{self.activeMeasurement}' to '{new_value}'"))
        self._project_logic.active_measurement = new_value
        self.activeMeasurementChanged.emit()

    ##########################
    # GUI accessible functions
    ##########################

    # Actions
    @Slot(str)
    def load(self, path: str) -> None:
        self._project_logic.add_measurement_from_file(file_path=IO.generalizePath(path))
        self.activeMeasurementChanged.emit()

    # @Slot('QVariant')
    # def setImageSource(self, source: QObject):
    #     source.setPath("image://easyimage/unique_image_id")
    #     #source."image://easyimage/unique_image_id"