import scitiff
from scipp import DataArray


class Measurement:
    def __init__(self, data_array: DataArray, name: str):
        self._data_array = data_array
        self._name = name
        self._list_of_ROIs = [((30, 30), (70, 70))]

    @classmethod
    def from_file(cls, file_path: str, name: str):
        """Load a measurement from a file."""
        data_array = scitiff.load_scitiff(file_path)
        return cls(data_array, name)
    
    @property
    def data_array(self) -> DataArray:
        """Get the data array of the measurement."""
        return self._data_array
    
    @property
    def name(self) -> str:
        """Get the name of the measurement."""
        return self._name
    
    @property
    def region_of_interests(self) -> list[tuple[tuple[int, int], tuple[int, int]]]:
        """Get the list of region of interests (ROIs) for the measurement."""
        return self._list_of_ROIs
    
    def get_spectrum(self, ROI: tuple[tuple[int, int], tuple[int, int]]) -> DataArray:
        """Get the spectrum for a given ROI."""
        x_start, y_start = ROI[0]
        x_end, y_end = ROI[1]
        spectrum = self._data_array['image']['x', x_start:x_end, 'y', y_start:y_end]
        return spectrum.mean(dim=['x', 'y'])
    
    @property
    def number_of_time_bins(self) -> int:
        """Get the number of time bins in the measurement."""
        if 't' in self._data_array.dims:
            index = self._data_array.dims.index('t')
            return self._data_array['image'].shape[index]
        return 0