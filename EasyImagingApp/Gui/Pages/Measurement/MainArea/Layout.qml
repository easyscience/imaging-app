// SPDX-FileCopyrightText: 2024 EasyApp contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>
import QtGraphs
import QtQuick
import QtQuick.Layouts


import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents
import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations
// import EasyApp.Gui.Charts as EaCharts
import EasyApp.Gui.Globals as EaGlobals

import Gui.Globals as Globals

import QtGraphs

Column {

    Layout.fillHeight: true

    Rectangle {
        width: parent.width
        height: parent.height * 0.7
        color: EaStyle.Colors.mainContentBackground

        Image {
        id: measurementViewer
        anchors.fill: parent
        // fillMode: Image.Stretch
        fillMode: Image.PreserveAspectFit
        cache: false
        smooth: false
        retainWhileLoading: true
        asynchronous: true
        source: Globals.BackendWrapper.imageSource
        Component.onCompleted: {
            Globals.References.pages.measurement.mainContent.views.measurementViewer = measurementViewer
        }
    }
    }

    Rectangle {

        color: EaStyle.Colors.chartBackground
        width: parent.width

        height: parent.height * 0.3

        GraphsView {

            id: spectrumViewer
            anchors.fill: parent
            theme: EaStyle.Colors.theme

            axisX: ValueAxis {
                id: xAxis
                min: Globals.BackendWrapper.minTime
                max: Globals.BackendWrapper.maxTime
                gridVisible: false
            }
            axisY: ValueAxis {
                id: yAxis
                min: 0.0
                max: Globals.BackendWrapper.maxIntensity
                gridVisible: false
            }

        Component.onCompleted: {
            Globals.References.pages.measurement.mainContent.views.spectrumView = spectrumViewer;
        }
        }
    }
}

