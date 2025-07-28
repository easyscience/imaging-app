import scitiff
from scipp import DataArray
from .region_of_interest import RegionOfInterest
from typing import TYPE_CHECKING
from scipp import scalar
from EasyApp.Logic.Logging import console
if TYPE_CHECKING:
    from scipp import scalar

class Measurement:
    def __init__(self, data_array: DataArray, name: str):
        self._data_array = data_array
        self._name = name
        self._regions_of_interest = []

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
    def number_of_time_bins(self) -> int:
        """Get the number of time bins in the measurement."""
        if 't' in self._data_array.dims:
            index = self._data_array.dims.index('t')
            return self._data_array['image'].shape[index]
        return 0

    @property
    def regions_of_interest(self) -> list[RegionOfInterest]:
        """Get the list of regions of interest in the measurement."""
        return self._regions_of_interest

    def create_region_of_interest(self, name: str, x_start: scalar, y_start: scalar, x_end: scalar, y_end: scalar) -> None:
        """Create a new region of interest (ROI) for the measurement."""
        roi = RegionOfInterest(name, x_start, y_start, x_end, y_end)
        self._regions_of_interest.append(roi)

    def get_region_of_interest(self, name: str) -> RegionOfInterest:
        """Get a region of interest (ROI) by name."""
        for roi in self._regions_of_interest:
            if roi.name == name:
                return roi
        raise KeyError(f"Region of interest '{name}' not found in measurement '{self._name}'.")
    
    def spectrum(self, region_of_interest: RegionOfInterest = None) -> DataArray:
        """
        Get the spectrum of the measurement.
        If a region of interest is provided, the spectrum is calculated for that region.
        """
        if region_of_interest:
            x_start = region_of_interest.x_start
            y_start = region_of_interest.y_start
            x_end = region_of_interest.x_end
            y_end = region_of_interest.y_end
            console.debug(f"x_start: {x_start}, y_start: {y_start}, x_end: {x_end}, y_end: {y_end}")
            return self._data_array['image']['x', x_start:x_end]['y', y_start:y_end].mean('x').mean('y')
        return self._data_array['image'].mean('x').mean('y')