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
    measurementListChanged = Signal()
    measurementCreatedChanged = Signal()

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
        if self._project_logic.active_measurement:
            return 'image://easyimage/' + self._project_logic.active_measurement

    @Property(bool, notify=measurementCreatedChanged)
    def measurementCreated(self) -> bool:
        """
        Returns True if any measurement has been created.
        """
        if not self._project_logic.get_measurements():
            return False
        return True

    @Property('QVariantList', notify=measurementListChanged)
    def measurementsList(self) -> list[dict[str, str]]:
        """
        Returns the list of measurements in the image provider.
        This is used in the QML code to display the list of measurements.
        """
        return self._project_logic.get_measurements_as_list_of_dicts()
    

    ##########################
    # GUI accessible functions
    ##########################

    # Actions
    @Slot(str)
    def load(self, path: str) -> None:
        self._project_logic.add_measurement_from_file(file_path=IO.generalizePath(path))
        self.activeMeasurementChanged.emit()
        self.measurementListChanged.emit()
        self.measurementCreatedChanged.emit()

    @Slot(str)
    def changeActiveMeasurement(self, name: str) -> None:
        """
        Changes the active measurement in the image provider.
        The name is the name of the measurement in the list of measurements.
        """
        self._project_logic.active_measurement = name
        self.activeMeasurementChanged.emit()
        console.debug(IO.format_msg('main', f"Active measurement changed to '{name}'."))

    @Slot(int)
    def removeMeasurement(self, index: int) -> None:
        """
        Removes a measurement from the project.
        The index is the index of the measurement in the list of measurements.
        """
        self._project_logic.remove_measurement(index)
        self.measurementListChanged.emit()
        self.activeMeasurementChanged.emit()
        self.measurementCreatedChanged.emit()
        console.debug(IO.format_msg('main', f"Measurement at index {index} removed."))

