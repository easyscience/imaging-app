from .measurement import Measurement


class Project:
    def __init__(self):
        self._measurements = []
        self._measurements_index = 0

    def add_measurement_from_file(self, file_path: str) -> None:
        """Create a new measurement from a file and add it to the project."""
        name = 'Measurement_' + str(self._measurements_index)
        measurement = Measurement.from_file(file_path=file_path, name=name)
        self._measurements.append(measurement)
        self._measurements_index += 1

    def get_measurements(self):
        """Get all measurements in the project."""
        return self._measurements

    def clear_measurements(self):
        """Clear all measurements from the project."""
        self._measurements.clear()