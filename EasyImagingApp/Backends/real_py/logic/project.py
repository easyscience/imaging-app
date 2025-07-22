from matplotlib import image
from ...imageprovider import EasyImageProvider
import numpy as np
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
        self._active_measurement = name
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
        if name == self._active_measurement:
            self._active_measurement = self.get_measurements()[0].name if self.get_measurements() else None
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
        names = [m.name for m in self._project_lib.get_measurements()]
        if name in names:
            self._active_measurement = name
            self._time_frame = 0
        else:
            raise ValueError(f"Measurement '{name}' not found in the project.")

    @property
    def time_frame(self) -> int:
        """Get the current time frame of the active measurement."""
        return self._time_frame

    @time_frame.setter
    def time_frame(self, value: int):
        """Set the current time frame of the active measurement."""
        if self._active_measurement is None:
            raise ValueError("No active measurement set.")
        self._time_frame = value

    @property
    def number_of_time_bins(self) -> int:
        """Get the number of time bins in the active measurement."""
        if self._active_measurement:
            list_of_measurements = self._project_lib.get_measurements()
            for measurement in list_of_measurements:
                if measurement.name == self._active_measurement:
                    return measurement.number_of_time_bins
        return 0
    
    @property
    def line_series_string(self) -> str:
        """
        Returns a string that can be used in QML to create a line series.
        """
        return """import QtGraphs;
            import Gui.Globals as Globals;
            import QtQuick;
            LineSeries { 
                id: "testSeries"
                XYPoint { x: 0; y: 0 }
                XYPoint { x: 1.1; y: 2.1 }
                XYPoint { x: 1.9; y: 3.3 }
                XYPoint { x: 2.1; y: 2.1 }
                XYPoint { x: 2.9; y: 4.9 }
                XYPoint { x: 3.4; y: 3.0 }
                XYPoint { x: 4.1; y: 3.3 }
                Component.onCompleted: {
                    console.debug('Test series created');
                    Globals.References.pages.measurement.mainContent.views.spectrumView.addSeries(testSeries);
                    console.debug('Test series added to spectrum view');
                    }
                }
        """
        