# SPDX-FileCopyrightText: 2024 EasyApp contributors
# SPDX-License-Identifier: BSD-3-Clause
# © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

from PySide6.QtCore import QObject, Signal, Slot, Property

from EasyApp.Logic.Logging import console
from .logic.helpers import IO
from .logic.project import Project as ProjectLogic
from .temp.project import Project as ProjectLib

class Measurements(QObject):
    activeMeasurementChanged = Signal()
    measurementListChanged = Signal()
    measurementCreatedChanged = Signal()
    imageSourceChanged = Signal()
    timeBinsChanged = Signal()
    timeFrameChanged = Signal()
    ROIListChanged = Signal()
    maxIntensityChanged = Signal()

    def __init__(self, project_lib: ProjectLib):
        super().__init__()
        self._project_logic = ProjectLogic(project_lib)

    ##########################
    # GUI accessible variables
    ##########################

    # Properties

    @Property(str, notify=imageSourceChanged)
    def imageSource(self) -> str:
        """
        Returns the image source for the image provider.
        This is used in the QML code to display the image.
        """
        if self._project_logic.active_measurement:
            return 'image://easyimage/' + self._project_logic.active_measurement + '_' + str(self._project_logic.time_frame)

    @Property(str, notify=activeMeasurementChanged)
    def activeMeasurement(self):
        """
        Returns the name of the active measurement in the image provider.
        This is used in the QML code to display the image.
        """
        if self._project_logic.active_measurement:
            return self._project_logic.active_measurement
        
    @Property(int, notify=timeBinsChanged)
    def timeBins(self) -> int:
        """
        Returns the number of time bins in the active measurement.
        This is used in the QML code to display the number of time bins.
        """
        if self._project_logic.active_measurement:
            return self._project_logic.number_of_time_bins
        return 0
    
    @Property(int, notify=timeFrameChanged)
    def timeFrame(self) -> int:
        """
        Returns the current time frame of the active measurement.
        This is used in the QML code to display the current time frame.
        """
        if self._project_logic.active_measurement:
            return self._project_logic.time_frame
        return 0
    
    @timeFrame.setter
    def timeFrame(self, value: int):
        """
        Sets the current time frame of the active measurement.
        This is used in the QML code to change the time frame.
        """
        if self._project_logic.active_measurement:
            if value < 0:
                value = 0
            elif value >= self._project_logic.number_of_time_bins:
                value = self._project_logic.number_of_time_bins - 1
            self._project_logic.time_frame = value
            self.timeFrameChanged.emit()
        else:
            raise ValueError("No active measurement set.")

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
    
    @Property('QVariantList', notify=ROIListChanged)
    def ROIList(self) -> list[dict[str, str]]:
        """
        Returns the list of ROIs in the active measurement.
        This is used in the QML code to display the list of ROIs.
        """
        if self._project_logic.active_measurement:
            measurement = self._project_logic.get_measurements()[-1]
            
        return []

    @Property(str, constant=True)
    def lineSeriesString(self) -> str:
        """
        Returns the QML string representation of the line series for the active measurement.
        This is used in the QML code to create the line series.
        """
        if self._project_logic.active_measurement:
            return self._project_logic.spectrum_line_series()
        return ""
    
    @Property(float, notify=maxIntensityChanged)
    def maxIntensity(self) -> float:
        """
        Returns the maximum value of the spectrum data.
        This is used in the QML code to set the maximum value of the spectrum.
        """
        if self._project_logic.active_measurement:
            max_intensity = self._project_logic.spectrum().values.max()
            return max_intensity
        return 0.0
    
    @Property(float, notify=activeMeasurementChanged)
    def minTime(self) -> float:
        """
        Returns the minimum time value of the active measurement.
        This is used in the QML code to set the minimum time value of the spectrum.
        """
        if self._project_logic.active_measurement:
            return self._project_logic.spectrum().coords['tof'].values.min()
        return 0.0

    @Property(float, notify=activeMeasurementChanged)
    def maxTime(self) -> float:
        """
        Returns the maximum time value of the active measurement.
        This is used in the QML code to set the maximum time value of the spectrum.
        """
        if self._project_logic.active_measurement:
            return self._project_logic.spectrum().coords['tof'].values.max()
        return 0.0

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

    @Slot(int)
    def removeMeasurement(self, index: int) -> None:
        """
        Removes a measurement from the project.
        The index is the index of the measurement in the list of measurements.
        """
        self._project_logic.remove_measurement(index)
        self.activeMeasurementChanged.emit()
        self.measurementListChanged.emit()
        self.measurementCreatedChanged.emit()

