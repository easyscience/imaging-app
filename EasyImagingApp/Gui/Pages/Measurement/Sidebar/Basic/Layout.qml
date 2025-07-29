// SPDX-FileCopyrightText: 2024 EasyApp contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

import QtQuick

import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents

import Gui.Globals as Globals


EaComponents.SideBarColumn {

    EaElements.GroupBox {
        enabled: true
        title: qsTr('Measurements')
        icon: 'microscope'
        collapsed: false

        Loader { source: 'Groups/ImportMeasurement.qml' }
    }

    EaElements.GroupBox {
        visible: Globals.BackendWrapper.measurementCreated
        title: qsTr('Time frame')
        icon: 'layer-group'
        collapsed: false

        Loader { source: 'Groups/TimeFrameSlider.qml' }
    }

    EaElements.GroupBox {
        visible: Globals.BackendWrapper.measurementCreated
        title: qsTr('Regions of Interest')
        icon: 'crop-simple'
        collapsed: false

        Loader { source: 'Groups/RegionsOfInterest.qml' }
    }

}
