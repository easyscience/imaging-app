from ...imageprovider import EasyImageProvider
import numpy as np
from ..temp.project import Project as ProjectLib
from EasyApp.Logic.Logging import console

class Project():
    def __init__(self, project_lib: ProjectLib):
        self._project_lib = project_lib
        self._active_measurement = None

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
        image = np.sum(image, axis=0)
        #image = image[0]
        image -= image.min()
        image *= (2**16 - 1) / image.max()
        self._image_provider.addOrUpdateLayer(name, image.astype(np.uint16))
        self._active_measurement = name

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
        self._image_provider.removeLayer(name)
        if name == self._active_measurement:
            self._active_measurement = self.get_measurements()[0].name if self.get_measurements() else None
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
        else:
            raise ValueError(f"Measurement '{name}' not found in the project.")