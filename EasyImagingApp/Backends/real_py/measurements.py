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
    createNewSpectrum = Signal(str)

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
            return 'image://easyimage/' + self._project_logic.active_measurement.name + '_' + str(self._project_logic.time_frame)

    @Property(str, notify=activeMeasurementChanged)
    def activeMeasurement(self):
        """
        Returns the name of the active measurement in the image provider.
        This is used in the QML code to display the image.
        """
        if self._project_logic.active_measurement:
            return self._project_logic.active_measurement.name

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
    def roiList(self) -> list[dict[str, str]]:
        """
        Returns the list of ROIs in the active measurement.
        This is used in the QML code to display the list of ROIs.
        """
        return self._project_logic.get_regions_of_interest_as_list_of_dicts()

    @Property(float, notify=ROIListChanged)
    def maxIntensity(self) -> float:
        """
        Returns the maximum value of the spectrum data.
        This is used in the QML code to set the maximum value of the spectrum.
        """
        return self._project_logic.max_intensity

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

    @Slot(float, float, float, float)
    def createROI(self, relative_startX: float, relative_startY: float, relative_endX: float, relative_endY: float) -> None:
        self._project_logic.create_ROI(relative_startX, relative_startY, relative_endX, relative_endY)
        self.ROIListChanged.emit()
        self.plotSpectrum(-1)  # Plot spectrum for the newly created ROI

    @Slot(int)
    def removeROI(self, index: int) -> None:
        """
        Removes a region of interest (ROI) from the active measurement.
        The index is the index of the ROI in the list of ROIs.
        """
        self._project_logic.remove_ROI(index)
        self.ROIListChanged.emit()

    @Slot(int)
    def plotSpectrum(self, index: int) -> None:
        ROI = self._project_logic.active_measurement.regions_of_interest[index]
        string = self._project_logic.spectrum_line_series(ROI)
        self.createNewSpectrum.emit(string)
