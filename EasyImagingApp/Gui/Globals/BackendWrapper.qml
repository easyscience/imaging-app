// SPDX-FileCopyrightText: 2024 EasyApp contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

pragma Singleton

import QtQuick

// This module is registered in the main.py file and allows access to the properties
// and backend  methods of the singleton object of the ‘PyBackend’ class.
// If ‘PyBackend’ is not defined, then 'MockBackend' from directory 'Backends' is used.
// It is needed to run the GUI frontend via the qml runtime tool without any Python backend.
import Backends as Backends
import Gui.Globals as Globals

QtObject {

    ////////////////
    // Backend proxy
    ////////////////

    readonly property var activeBackend: {
        if (typeof Backends.PyBackend !== 'undefined') {
            console.debug('REAL python backend is in use')
            return Backends.PyBackend
        } else {
            console.debug('MOCK QML backend is in use')
            return Backends.MockBackend
        }
    }

    /////////////
    // Status bar
    /////////////

    readonly property string statusProject: activeBackend.status.project
    readonly property string statusPhasesCount: activeBackend.status.phasesCount
    readonly property string statusMeasurementsCount: activeBackend.status.measurementsCount
    readonly property string statusCalculator: activeBackend.status.calculator
    readonly property string statusMinimizer: activeBackend.status.minimizer
    readonly property string statusVariables: activeBackend.status.variables

    ///////////////
    // Project page
    ///////////////

    readonly property var projectInfo: activeBackend.project.info
    readonly property var projectExamples: activeBackend.project.examples

    property bool projectCreated: activeBackend.project.created
    onProjectCreatedChanged: activeBackend.project.created = projectCreated
    property string projectName: activeBackend.project.name
    onProjectNameChanged: activeBackend.project.name = projectName

    function projectCreate() { activeBackend.project.create() }
    function projectSave() { activeBackend.project.save() }
    function projectEditInfo(path, new_value) { activeBackend.project.editInfo(path, new_value) }
    function projectLoad(file_path) { activeBackend.project.load(file_path) }

    ///////////////
    // Measurement page
    ///////////////

    property bool measurementCreated: activeBackend.report.created
    onMeasurementCreatedChanged: activeBackend.report.created = measurementCreated

    property string activeMeasurement: activeBackend.measurements.activeMeasurement
    onActiveMeasurementChanged: Globals.References.pages.measurement.mainContent.measurementViewer.source = activeBackend.measurements.activeMeasurement

    function measurementLoad(value) {activeBackend.measurements.load(value)}

    ///////////////
    // Summary page
    ///////////////

    readonly property string reportAsHtml: activeBackend.report.asHtml

    property bool reportCreated: activeBackend.report.created
    onReportCreatedChanged: activeBackend.report.created = reportCreated
}
