from typing import TYPE_CHECKING
from scipp import scalar
if TYPE_CHECKING:
    from scipp import scalar

class RegionOfInterest:
    """
    Class representing a region of interest (ROI) in an image.
    It is used to define a specific area within an image for further processing or analysis.
    """
    def __init__(self, name: str, x_start: scalar, y_start: scalar, x_end: scalar, y_end: scalar):
        """
        Initialize the ROI with start and end coordinates.

        :param name: Name of the ROI.
        :param x_start: Starting x-coordinate of the ROI.
        :param y_start: Starting y-coordinate of the ROI.
        :param x_end: Ending x-coordinate of the ROI.
        :param y_end: Ending y-coordinate of the ROI.
        """
        self.name = name
        self.x_start = x_start
        self.y_start = y_start
        self.x_end = x_end
        self.y_end = y_end

    def __repr__(self):
        return f"RegionOfInterest {self.name}: (x_start={self.x_start}, y_start={self.y_start}, x_end={self.x_end}, y_end={self.y_end})"