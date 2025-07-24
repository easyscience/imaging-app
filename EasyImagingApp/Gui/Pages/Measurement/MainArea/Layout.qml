// SPDX-FileCopyrightText: 2024 EasyApp contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

import QtQuick
import QtQuick.Layouts


import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents
import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Globals as EaGlobals

import Gui.Globals as Globals

import QtGraphs

Column {

    Layout.fillHeight: true


    Rectangle {
        width: parent.width
        height: parent.height * 0.7
        color: EaStyle.Colors.chartBackground
        Behavior on color { EaAnimations.ThemeChange {} }

        Loader { 
            anchors.fill: parent
            source: 'Views/MeasurementView.qml' 
        }
    }

    Rectangle {
        width: parent.width
        height: parent.height * 0.3
        color: EaStyle.Colors.chartBackground
        Behavior on color { EaAnimations.ThemeChange {} }

        Loader { 
            anchors.fill: parent
            source: 'Views/SpectrumView.qml' 

        }
    }
}
