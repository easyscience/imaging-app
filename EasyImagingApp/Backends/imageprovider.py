from PySide6.QtQuick import QQuickImageProvider
import numpy as np
from PySide6.QtCore import QSize
from PySide6.QtGui import QImage
from easyscience.utils.classUtils import singleton

@singleton
class EasyImageProvider(QQuickImageProvider):
    def __init__(self):
        super().__init__(QQuickImageProvider.ImageType.Image)
 
        self.name = 'easyimage'

        """Image provider data."""
        self._images: dict[str, np.ndarray] = dict()
 
        """Suggested utility objects."""
        # self.SharedConstants = SharedConstants()
        # self._imageConstructor = ImageConstructor()
        # self._idConstructor = IdConstructor()

    def requestImage(self, image_id: str, size: QSize, requested_size: QSize) -> QImage:
        if (image_id in self._images.keys()) and (self._images[image_id] is not None):
            """Retrieve the image data from the image library."""
            _pixels = self._images[image_id]
    
            """According to the documentation: 
            In all cases, size must be set to the original size of the image. 
            This is used to set the width and height of the relevant Image if 
            these values have not been set explicitly."""
            image_size = QSize(_pixels.shape[1], _pixels.shape[0])
            if size:
                size = image_size
    
            """Construct the size of the returned image."""
            width = (
                requested_size.width()
                if requested_size.width() > 0
                else image_size.width()
            )
            height = (
                requested_size.height()
                if requested_size.height() > 0
                else image_size.height()
            )
    
            """Construct the image."""
            img = QImage(
                _pixels.data,
                width,
                height,
                QImage.Format_Grayscale16,
            )
    
            return img
        else:
            raise ValueError(
                " image provider was unable to find image "
                + image_id
            )
        
    def addOrUpdateLayer(self, layer_id: str, pixel_data: np.ndarray) -> dict:
        """Data validation and manipulations to prep for the render-ready format"""
        # Insert your data validation code
        # Insert your data manipulation code
    
        """Map the new data to the desired id and save to the library."""
        layer = {layer_id: pixel_data}
        self._images.update(layer)
    
        return layer
    
    def removeLayer(self, layer_id: str) -> None:
        """Apply key-value pair deletion logic"""
        del self._images[layer_id]
