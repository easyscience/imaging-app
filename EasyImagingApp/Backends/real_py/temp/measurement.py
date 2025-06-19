import scitiff
from scipp import DataArray

class Measurement:
    def __init__(self, data_array: DataArray, name: str):
        self._data_array = data_array
        self._name = name

    @classmethod
    def from_file(cls, file_path: str, name: str):
        """Load a measurement from a file."""
        data_array = scitiff.load_scitiff(file_path)
        return cls(data_array, name)
    
    @property
    def data_array(self) -> DataArray:
        """Get the data array of the measurement."""
        return self._data_array