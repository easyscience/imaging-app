// SPDX-FileCopyrightText: 2024 EasyApp contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtGraphs

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements

import Gui.Globals as Globals


GraphsView {
    id: spectrumView
    anchors.fill: parent

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
        Globals.References.pages.measurement.mainContent.views.spectrumView = spectrumView;
    }

    Connections {
        target: Globals.BackendWrapper.activeBackend.measurements
        function onCreateNewSpectrum(qmlString) {
            let newSeries = Qt.createQmlObject(qmlString, spectrumView);
            spectrumView.addSeries(newSeries);
            Globals.Variables.measurementRoiSeriesList[Globals.BackendWrapper.activeMeasurementIndex].push(newSeries);
            console.debug("Measurement ROI series list after adding new series:", Globals.Variables.measurementRoiSeriesList);
        }
    }

}
