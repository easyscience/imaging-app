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
        color: EaStyle.Colors.themeBackground

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
        
        color: "blue"
        width: parent.width

        height: parent.height * 0.3

        GraphsView {

            id: spectrumViewer
            anchors.fill: parent

                axisX: ValueAxis {
                id: xAxis
                max: 4.1
            }
            axisY: ValueAxis {
                id: yAxis
                max: 4.9
            }

            LineSeries {
                name: "Line"
                XYPoint { x: 0; y: 0 }
                XYPoint { x: 1.1; y: 2.1 }
                XYPoint { x: 1.9; y: 3.3 }
                XYPoint { x: 2.1; y: 2.1 }
                XYPoint { x: 2.9; y: 4.9 }
                XYPoint { x: 3.4; y: 3.0 }
                XYPoint { x: 4.1; y: 3.3 }
            }

        Component.onCompleted: {
            Globals.References.pages.measurement.mainContent.views.spectrumView = spectrumViewer;
        }
        }
    }
}

