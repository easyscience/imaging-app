
from ...imageprovider import EasyImageProvider
import numpy as np
import scipp as sc
from ..temp.project import Project as ProjectLib
from EasyApp.Logic.Logging import console

class Project():
    def __init__(self, project_lib: ProjectLib):
        self._project_lib = project_lib
        self._active_measurement = None
        self._time_frame = 0

        # This class is a singleton, so it can be accessed globally
        self._image_provider = EasyImageProvider()

    def add_measurement_from_file(self, file_path: str) -> None:
        """Create a new measurement from a file and add it to the project."""
        self._project_lib.add_measurement_from_file(file_path)
        measurement = self._project_lib.get_measurements()[-1]
        data_array = measurement.data_array
        name = measurement.name
        # Rescale and add the measurement image to the image provider
        image = data_array['image']['c', 0].values
        for frame in range(image.shape[0]):
            image[frame] -= image[frame].min()
            if image[frame].max() == 0:
                console.debug(f"Measurement '{name}' frame {frame} has no data, skipping rescaling.")
            else:
                image[frame] *= (2**16 - 1) / image[frame].max()
            if frame == 0:
                console.debug(f'Frame {frame} of measurement {name} has shape {image[frame].shape} and max value {image[frame].max()}')
            self._image_provider.addOrUpdateLayer(name+f"_{frame}", image[frame].astype(np.uint16))
        self._active_measurement = measurement
        self._time_frame = 0

    def get_measurements(self):
        """Get all measurements in the project."""
        return self._project_lib.get_measurements()

    def clear_measurements(self):
        """Clear all measurements from the project."""
        self._project_lib.clear_measurements()

    def remove_measurement(self, index: int) -> None:
        """Remove a measurement from the project by index."""
        measurement = self._project_lib.get_measurements().pop(index)
        name = measurement.name
        for frame in range(self.number_of_time_bins):
            self._image_provider.removeLayer(name + f"_{frame}")
        if measurement == self.active_measurement:
            self._active_measurement = self.get_measurements()[0] if self.get_measurements() else None
        self._time_frame = 0
        console.debug(f"Measurement '{name}' removed from the project.")

    def get_measurements_as_list_of_dicts(self) -> list[dict[str, str]]:
        """Get the list of measurements as a list of dictionaries."""
        return [{'name': m.name} for m in self._project_lib.get_measurements()]

    @property
    def active_measurement(self):
        """Get the active measurement."""
        return self._active_measurement
    
    @active_measurement.setter
    def active_measurement(self, name: str):
        """Set the active measurement."""
        measurements_list = self._project_lib.get_measurements()
        measurement = [m for m in measurements_list if m.name == name][0]
        self._active_measurement = measurement
        self._time_frame = 0

    @property
    def time_frame(self) -> int:
        """Get the current time frame of the active measurement."""
        return self._time_frame

    @time_frame.setter
    def time_frame(self, value: int):
        """Set the current time frame of the active measurement."""
        if self.active_measurement is None:
            raise ValueError("No active measurement set.")
        self._time_frame = value

    @property
    def number_of_time_bins(self) -> int:
        """Get the number of time bins in the active measurement."""
        if self.active_measurement:
            return self.active_measurement.number_of_time_bins
        return 0
    
    @property
    def max_intensity(self) -> float:
        """Get the maximum intensity of the active measurement."""
        max_intensity = 1.0
        if self.active_measurement:
            if self.active_measurement.regions_of_interest:
                regions_of_interest = self.active_measurement.regions_of_interest
                for roi in regions_of_interest:
                    spectrum = self.active_measurement.spectrum(roi).values
                    max_intensity = max(max_intensity, spectrum.max())
        return float(max_intensity)

    def spectrum(self, region_of_interest=None):
        """
        Get the spectrum of the active measurement.
        If a region of interest is provided, the spectrum is calculated for that region.
        """
        if self.active_measurement:
            return self.active_measurement.spectrum(region_of_interest)
        raise ValueError("No active measurement set or measurement not found.")

    def spectrum_line_series(self, region_of_interest=None) -> str:
        """
        Returns a string that can be used in QML to create a line series from the spectrum of the active measurement.
        If a region of interest is provided, the spectrum is calculated for that region.
        """
        spectrum = self.spectrum(region_of_interest)
        times = sc.midpoints(spectrum.coords['tof']).values
        intensities = spectrum['c', 0].values

        points = [f'XYPoint {{ x: {times[i]}; y: {intensities[i]} }}' for i in range(len(times))]
        
        begining_string = """import QtGraphs;
            import Gui.Globals as Globals;
            import QtQuick;
            LineSeries {
            id: spectrumSeries
            """
        end_string = """            Component.onCompleted: {
                Globals.References.pages.measurement.mainContent.views.spectrumView.addSeries(spectrumSeries);
                console.debug('Spectrum series added to spectrum view');
            }
            }"""
        console.debug(f"Creating line series with {len(points)} points.")
        return begining_string + '\n'.join(points) + end_string

    def create_ROI(self, relative_startX: float, relative_startY: float, relative_endX: float, relative_endY: float) -> None:
        """
        Create a region of interest (ROI) in the active measurement.
        The ROI is defined by the start and end coordinates.
        """
        if self.active_measurement is None:
            raise ValueError("No active measurement set.")
        
        data = self.active_measurement.data_array['image']

        x_min, x_max = data.coords['x'].values.min(), data.coords['x'].values.max()
        y_min, y_max = data.coords['y'].values.min(), data.coords['y'].values.max()
        unit = data.coords['x'].unit

        if relative_startX > relative_endX:
            startX = (relative_endX * (x_max - x_min) + x_min)*unit
            endX = (relative_startX * (x_max - x_min) + x_min)*unit
        else:
            startX = (relative_startX * (x_max - x_min) + x_min)*unit
            endX = (relative_endX * (x_max - x_min) + x_min)*unit
        if relative_startY > relative_endY:
            startY = (relative_endY * (y_max - y_min) + y_min)*unit
            endY = (relative_startY * (y_max - y_min) + y_min)*unit
        else:
            startY = (relative_startY * (y_max - y_min) + y_min)*unit
            endY = (relative_endY * (y_max - y_min) + y_min)*unit

        name = 'Region_' + str(len(self.active_measurement.regions_of_interest))

        self.active_measurement.create_region_of_interest(name, startX, startY, endX, endY)
        console.debug(f"ROI created from ({startX}, {startY}) to ({endX}, {endY}) in measurement '{self.active_measurement.name}'.")

    def get_regions_of_interest_as_list_of_dicts(self) -> list[dict[str, str]]:
        """Get the list of regions of interest as a list of dictionaries."""
        if self.active_measurement:
            return [{'name': roi.name} for roi in self.active_measurement.regions_of_interest]
        return []
    
    def remove_ROI(self, index: int) -> None:
        """
        Remove a region of interest (ROI) from the active measurement.
        The index is the index of the ROI in the list of ROIs.
        """
        if self.active_measurement is None:
            raise ValueError("No active measurement set.")
        
        rois = self.active_measurement.regions_of_interest
        
        roi = rois.pop(index)
        console.debug(f"ROI '{roi.name}' removed from measurement '{self.active_measurement.name}'.")